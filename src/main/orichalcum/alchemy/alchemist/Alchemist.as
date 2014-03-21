package orichalcum.alchemy.alchemist 
{
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.lifecycle.IAlchemyLifecycle;
	import orichalcum.alchemy.mapper.AlchemyMapper;
	import orichalcum.alchemy.mapper.IAlchemyMapper;
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.ingredient.processor.ConstructorArgumentProcessor;
	import orichalcum.alchemy.ingredient.processor.EventHandlerProcessor;
	import orichalcum.alchemy.ingredient.processor.MultiprocessProcessor;
	import orichalcum.alchemy.ingredient.processor.PostConstructProcessor;
	import orichalcum.alchemy.ingredient.processor.PreDestroyProcessor;
	import orichalcum.alchemy.ingredient.processor.PropertyProcessor;
	import orichalcum.alchemy.ingredient.processor.SignalHandlerProcessor;
	import orichalcum.alchemy.ingredient.processor.SymbiotProcessor;
	import orichalcum.alchemy.resolver.ExpressionResolver;
	import orichalcum.alchemy.resolver.IDependencyResolver;
	import orichalcum.alchemy.resolver.ProviderlessTypeResolver;
	import orichalcum.alchemy.resolver.ProviderlessValueResolver;
	import orichalcum.alchemy.resolver.ProviderResolver;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.reflection.IReflector;
	import orichalcum.reflection.Reflector;
	import orichalcum.utility.ObjectUtil;
	
	public class Alchemist extends EventDispatcher implements IDisposable, IAlchemist
	{
		
		/**
		 * Used to avoid creating a new recipes every recursive step taken during the conjure|create|inject processes.
		 * The caller of the recursive-compound-recipe-consuming-function must return the recipe flyweight after use.
		 * @private
		 */
		private var _recipeFlyweights:Array = [];
		
		/**
		 * Used to manage the recipe flyweight pool
		 * @private
		 */
		private var _recipeFlyweightsIndex:int;
		
		/**
		 * Creational lifecylce processes
		 * @private
		 */
		private var _creator:InstanceFactory = new InstanceFactory;
		
		/**
		 * lifecylce processes
		 * @private
		 */
		private var _lifecycle:IAlchemyLifecycle = new MultiprocessProcessor([
			new ConstructorArgumentProcessor,
			new PropertyProcessor,
			new PostConstructProcessor,
			new PreDestroyProcessor,
			new EventHandlerProcessor,
			new SignalHandlerProcessor,
			new SymbiotProcessor
		]);
		
		/**
		 * Dependency resolvers
		 * @private
		 */
		private var _resolvers:Vector.<IDependencyResolver> = new <IDependencyResolver>[
			new ProviderResolver,
			new ProviderlessTypeResolver,
			new ExpressionResolver,
			new ProviderlessValueResolver
		];
		
		/**
		 * Reflection utility
		 * @private
		 */
		private var _reflector:IReflector = Reflector.getInstance(ApplicationDomain.currentDomain);
		
		/**
		 * Generates recipes based on class metatags
		 * @private
		 */
		private var _recipeFactory:RecipeFactory;
		
		/**
		 * Contains all mappings
		 * This includes IProvider, "{stringExpressions}" or values
		 * @private
		 */
		private var _mappings:Dictionary = new Dictionary;
		
		/**
		 * Contains all mapped recipes
		 * @private
		 */
		private var _recipes:Dictionary = new Dictionary;
		
		/**
		 * Used to facilitate providers' provision destruction hook
		 * @private
		 */
		private var _providersByInstance:Dictionary = new Dictionary;
		
		/**
		 * Used to facilitate unbinding and pre-destroy hooks for runtime configured instances
		 * @private
		 */
		private var _recipesByInstance:Dictionary = new Dictionary;
		
		/**
		 * Holds active friends, friends stay active so long as any of their friends is in play (not destroyed)
		 * @private
		 */
		private var _symbiotsByInstance:Dictionary = new Dictionary;
		
		/**
		 * @private used to prevent infinite loops for circular dependencies
		 */
		private var _instancesInProcessById:Dictionary = new Dictionary;
		
		/**
		 * The backward reference to the source of the this Alchemist
		 * Finding fallback providers and recipes in the parent alchemist
		 * thisAlchemist = parentAlchemist.extend()
		 * @private
		 */
		private var _parent:Alchemist;
		
		public function get parent():Alchemist 
		{
			return _parent;
		}
		
		public function set parent(value:Alchemist):void 
		{
			//_parent = value == null ? DEFAULT_PARENT : value;
			_parent = value;
		}
		
		public function get lifecycle():IAlchemyLifecycle 
		{
			return _lifecycle;
		}
		
		public function set lifecycle(value:IAlchemyLifecycle):void 
		{
			_lifecycle = value;
		}
		
		public function get reflector():IReflector 
		{
			return _reflector;
		}
		
		public function set reflector(value:IReflector):void 
		{
			_reflector = value;
		}
		
		public function get resolvers():Vector.<IDependencyResolver> 
		{
			return _resolvers;
		}
		
		public function set resolvers(value:Vector.<IDependencyResolver>):void 
		{
			_resolvers = value;
		}
		
		public function Alchemist()
		{
			_recipeFactory = new RecipeFactory(this);
			
			/**
			 * Maps itself as a value for the IAlchemist interface
			 */
			map(IAlchemist).to(this);
		}
		
		public function dispose():void
		{
			for (var mappingId:String in _mappings)
			{
				_mappings[mappingId] is IDisposable && (_mappings[mappingId] as IDisposable).dispose();
				delete _mappings[mappingId];
			}
			for (var recipeId:String in _recipes)
			{
				_recipes[recipeId] is IDisposable && (_recipes[recipeId] as IDisposable).dispose();
				delete _recipes[recipeId];
			}
			_recipeFactory is IDisposable && (_recipeFactory as IDisposable).dispose();
			
			_recipeFlyweights = null;
			_creator = null;
			_lifecycle = null;
			_resolvers = null;
			_reflector = null;
			_recipeFactory = null;
			_mappings = null;
			_recipes = null;
			_providersByInstance = null;
			_recipesByInstance = null;
			_symbiotsByInstance = null;
			_instancesInProcessById = null;
			_parent = null;
		}
		
		public function extend():IAlchemist
		{
			const child:Alchemist = new Alchemist;
			child._parent = this;
			return child;
		}
		
		public function map(id:*):IAlchemyMapper
		{
			/**
			 * This method cannot function with a null Id
			 */
			id || throwError('Argument "id" passed to method Alchemist.conjure() must not be null.');
			
			return new AlchemyMapper(this, normalizeId(id), _mappings, _recipes);
		}
		
		public function unmap(id:*):void
		{
			delete _mappings[id];
			delete _recipes[id];
		}
		
		public function conjure(id:*, recipe:Dictionary = null):*
		{
			/**
			 * This method cannot function with a null Id
			 */
			id || throwError('Argument "id" passed to method Alchemist.conjure() must not be null.');
			
			const validId:String = normalizeId(id);
			
			/**
			 * Allows support for symbiots with cyclical property injections
			 */
			if (validId in _instancesInProcessById)
				return _instancesInProcessById[validId];
			
			/**
			 * Fallback on mapped recipe when it is not explicitley set
			 */
			if (recipe == null)
				recipe = getRecipe(validId);
			
			/**
			 * It is important to remember that a mapping can be a provider,
			 * expression or even a plain value
			 */
			const mapping:* = getMapping(validId);
			
			/**
			 * This is the reference to the resolved value of an expression or provider
			 */
			const instance:* = resolve(validId, mapping, recipe);
			
			/**
			 * Remember the instance's provider to invoke its destroy hook on a call to destroy(instance)
			 */
			if (mapping is IProvider)
				_providersByInstance[instance] = mapping;
			
			/**
			 * Remember the instance's recipe for use in the lifecycle deactivate phase in destroy()
			 */
			if (recipe)
				_recipesByInstance[instance] = recipe;
			
			/**
			 * Execute lifecyle provide phase
			 */
			lifecycle.provide(instance, recipe, this);
			
			return instance;
		}
		
		public function evaluate(providerReferenceOrValue:*):*
		{
			return resolve(null, providerReferenceOrValue, null);
		}
		
		private function resolve(id:String, mapping:*, recipe:Dictionary):* 
		{
			for each(var resolver:IDependencyResolver in resolvers)
			{
				if (resolver.resolves(id, mapping))
					return resolver.resolve(id, mapping, recipe, this);
			}
			
			throwError('Alchemist cannot resolve mapping "{}" id "{}".', mapping, id);
		}
		
		public function create(type:Class, recipe:Dictionary = null, id:* = null):Object
		{
			
			/**
			 * This method requires that the type argument is not null to function
			 */
			type || throwError('Argument "type" passed to method Alchemist.create() must not be null.');
			
			/**
			 * Get the merged recipe for the type
			 */
			recipe = getRecipeForClassOrInstance(type, getRecipeFlyweight(), recipe);
			
			/**
			 * Instantiate tye type based on the recipe
			 */
			const instance:* = _creator.create(type, this, recipe);
			
			/**
			 * Remember the current instance being processed.
			 * This is to prevent infinite loops when objects are found to have
			 * symbiotic or circular relationships at injection or activation time.
			 */
			_instancesInProcessById[id] = instance;
			
			/**
			 * Execute activation lifecycle phase
			 */
			lifecycle.activate(instance, recipe, this);
			
			/**
			 * Forget the current instance is being processed after the activation phase has passed
			 */
			delete _instancesInProcessById[id];
			
			/**
			 * Return the flyweight recipe used in recipe computation for reuse
			 */
			returnRecipeFlyweight();
			
			/**
			 * Return the newly instantiated and injected instance
			 */
			return instance;
		}
		
		public function inject(instance:Object):Object
		{
			
			/**
			 * A null instance here usually means there is an issue in your (or my) code
			 */
			instance || throwError('Argument "instance" passed to method Alchemist.inject() must not be null.');
			
			/**
			 * Get the merged recipe for the type
			 */
			const recipe:Dictionary = getRecipeForClassOrInstance(instance, getRecipeFlyweight(), _recipesByInstance[instance]);
			
			/**
			 * Determine the type of the instance through reflection
			 */
			const type:Class = _reflector.getTypeDefinition(instance);
			
			/**
			 * Execute activation lifecycle phase
			 */
			lifecycle.activate(instance, recipe, this);
			
			/**
			 * Return the flyweight recipe used in recipe computation for reuse
			 */
			returnRecipeFlyweight();
			
			/**
			 * Return the injected instance
			 */
			return instance;
		}
		
		public function destroy(instance:Object):Object
		{
			
			/**
			 * A null instance here usually means there is an issue in your (or my) code
			 */
			instance || throwError('Argument "instance" passed to method Alchemist.destroy() must not be null.');
			
			/**
			 * Execute the provider's destroy hook
			 */
			instance in _providersByInstance && _providersByInstance[instance].destroy(instance);
			
			/**
			 * Get the merged recipe for the type
			 */
			const recipe:Dictionary = getRecipeForClassOrInstance(instance, getRecipeFlyweight(), _recipesByInstance[instance]);
			
			/**
			 * Determine the type of the instance through reflection
			 */
			const type:Class = _reflector.getTypeDefinition(instance);
			
			/**
			 * Execute deactivation lifecycle phase
			 */
			lifecycle.deactivate(instance, recipe, this);
			
			/**
			 * Return the flyweight recipe used in recipe computation for reuse
			 */
			returnRecipeFlyweight();
			
			/**
			 * Return the destroyed instance
			 */
			return instance;
		}
		
		/**
		 * Recursively looks up any provider mapped to the id through this alchemist and its ancestor chain.
		 * @param	id The custom name or qualified class name used to map the provider
		 */
		public function getMapping(id:String):*
		{
			if (id in _mappings)
				return _mappings[id];
				
			if (_parent)
				return _parent.getMapping(id);
			
			return Unmapped;
		}
		
		/**
		 * Recursively looks up any recipe mapped to the id through this alchemist and its ancestor chain.
		 * @param	id The custom name or qualified class name used to map the recipe
		 */
		public function getRecipe(id:String):Dictionary
		{
			if (id in _recipes)
				return _recipes[id];
				
			if (_parent)
				return _parent.getRecipe(id);
				
			return null;
		}
		
		/**
		 * @private
		 */
		private function getRecipeForClassOrInstance(classOrInstance:Object, recipeFlyweight:Dictionary, runtimeRecipe:Dictionary = null):Dictionary 
		{
			return getRecipeForClassName(
				_reflector.getTypeName(classOrInstance),
				recipeFlyweight,
				runtimeRecipe
			);
		}
		
		/**
		 * @private
		 */
		private function getRecipeForClassName(qualifiedClassName:String, recipeFlyweight:Dictionary, runtimeRecipe:Dictionary = null):Dictionary
		{
			return getMergedRecipe(
				recipeFlyweight,
				_recipeFactory.getRecipeForClassNamed(qualifiedClassName),
				getRecipe(qualifiedClassName),
				runtimeRecipe
			);
		}
		
		/**
		 * @private
		 */
		private function getMergedRecipe(recipeFlyweight:Dictionary, staticTypeRecipe:Dictionary, runtimeTypeRecipe:Dictionary, runtimeInstanceRecipe:Dictionary):Dictionary
		{
			/*
			 * Because of the recursive nature of the conjure/inject algorithm
			 * a flyweight *pool* must be used to compensate for
			 * the function requiring a new recipe every recursive call.
			 */
			const recipe:Dictionary = recipeFlyweight ? ObjectUtil.clean(recipeFlyweight) as Dictionary : new Dictionary;
			staticTypeRecipe && lifecycle.inherit(recipe, staticTypeRecipe);
			runtimeTypeRecipe && lifecycle.inherit(recipe, runtimeTypeRecipe);
			runtimeInstanceRecipe && lifecycle.inherit(recipe, runtimeInstanceRecipe);
			return recipe;
		}
		
		/**
		 * @private
		 */
		private function normalizeId(id:*):String
		{
			var validId:String;
			
			if (id is String)
			{
				validId = id as String;
			}
			else if (id is Class)
			{
				validId = _reflector.getTypeName(id);
			}
			else
			{
				throwError('Argument "id" must be of type "String" or "Class" not ' + _reflector.getTypeName(id));
			}
			if (_reflector.isPrimitiveType(validId))
			{
				throwError('Argument "id" must not be any of these primitive types: (Function, Object, Array, Boolean, Number, String, int, uint)');
			}
			return validId;
		}
		
		/**
		 * @private
		 */
		private function getRecipeFlyweight():Dictionary 
		{
			return _recipeFlyweights[_recipeFlyweightsIndex++] ||= new Dictionary;
		}
		
		/**
		 * @private
		 */
		private function returnRecipeFlyweight():void
		{
			_recipeFlyweightsIndex--;
		}
		
		/**
		 * @private
		 */
		private function throwError(message:String, ...substitutions):void
		{
			throw new AlchemyError(message, substitutions);
		}
		
	}

}


/**
 * A unique class must be used to represent the absence of a provision|provider
 * This is to avoid reserving real values (mainly null or undefined) that the client may want to use
 */
internal class NotFound{}