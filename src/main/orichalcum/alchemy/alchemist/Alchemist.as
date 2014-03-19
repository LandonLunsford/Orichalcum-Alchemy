package orichalcum.alchemy.alchemist 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.lifecycle.IAlchemyLifecycle;
	import orichalcum.alchemy.mapper.AlchemyMapper;
	import orichalcum.alchemy.mapper.IAlchemyMapper;
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.recipe.ingredient.processor.ConstructorArgumentProcessor;
	import orichalcum.alchemy.recipe.ingredient.processor.EventHandlerProcessor;
	import orichalcum.alchemy.recipe.ingredient.processor.IIngredientProcessor;
	import orichalcum.alchemy.recipe.ingredient.processor.MultiprocessProcessor;
	import orichalcum.alchemy.recipe.ingredient.processor.PostConstructProcessor;
	import orichalcum.alchemy.recipe.ingredient.processor.PreDestroyProcessor;
	import orichalcum.alchemy.recipe.ingredient.processor.PropertyProcessor;
	import orichalcum.alchemy.recipe.ingredient.processor.SignalHandlerProcessor;
	import orichalcum.alchemy.recipe.ingredient.processor.SymbiotProcessor;
	import orichalcum.alchemy.resolver.ExpressionResolver;
	import orichalcum.alchemy.resolver.IDependencyResolver;
	import orichalcum.alchemy.resolver.ProviderlessTypeResolver;
	import orichalcum.alchemy.resolver.ProviderlessValueResolver;
	import orichalcum.alchemy.resolver.ProviderResolver;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.reflection.IReflector;
	import orichalcum.reflection.Reflector;
	
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
		 * Contains all mapped providers
		 * 
		 * @warning Nasty truth is this contains the following
		 * 1. IProvider
		 * 2. "{expression}"
		 * 3. Instances directly
		 * 
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
		//private const DEFAULT_PARENT:AlchemistBase = new AlchemistBase;
		//private var _parent:Alchemist = DEFAULT_PARENT;
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
		
		
		
		/**
		 * @param list of XML mapping configurations
		 */
		public function Alchemist(...mappings)
		{
			_recipeFactory = new RecipeFactory(this);
			
			mappings && mapAll(mappings);
			map(getQualifiedClassName(this)).to(this);
		}
		
		public function dispose():void
		{
			for (var providerName:String in _mappings)
			{
				_mappings[providerName] is IDisposable && (_mappings[providerName] as IDisposable).dispose();
				delete _mappings[providerName];
			}
			for (var recipeName:String in _recipes)
			{
				_recipes[recipeName] is IDisposable && (_recipes[recipeName] as IDisposable).dispose();
				delete _recipes[recipeName];
			}
			_recipeFactory is IDisposable && (_recipeFactory as IDisposable).dispose();
			_parent = null;
			_mappings = null;
			_recipes = null;
		}
		
		public function map(id:*):IAlchemyMapper
		{
			return new AlchemyMapper(this, normalizeId(id), _mappings, _recipes);
		}
		
		public function unmap(id:*):void
		{
			delete _mappings[id];
			delete _recipes[id];
		}
		
		public function conjure(id:*, recipe:Dictionary = null):*
		{
			const validId:String = normalizeId(id);
			
			/*
			 *	Allows support for symbiots with cyclical property injections
			 */
			if (_instancesInProcessById[validId])
				return _instancesInProcessById[validId];
			
			const mapping:* = getMapping(validId);
			const instance:* = resolve(validId, mapping, recipe ||= getRecipe(validId));
			
			if (mapping is IProvider)
				_providersByInstance[instance] = mapping;
			
			if (recipe)
				_recipesByInstance[instance] = recipe;
			
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
				{
					return resolver.resolve(id, mapping, recipe, this);
				}
			}
			
			throwError('Alchemist cannot resolve mapping "{}" id "{}".', mapping, id);
		}
		
		public function create(type:Class, recipe:Dictionary = null, id:* = null):Object
		{
			type || throwError('Argument "type" passed to method Alchemist.create() must not be null.');
			
			const recipeFlyweight:Dictionary = getRecipeForClassOrInstance(type, getRecipeFlyweight(), recipe);
			const instance:* = _creator.create(type, this, recipeFlyweight);
			_instancesInProcessById[id] = instance;
			lifecycle.activate(instance, recipeFlyweight, this);
			delete _instancesInProcessById[id];
			returnRecipeFlyweight();
			return instance;
		}
		
		public function inject(instance:Object):Object
		{
			instance || throwError('Argument "instance" passed to method Alchemist.inject() must not be null.');
			
			const type:Class = _reflector.getType(_reflector.getTypeName(instance));
			const recipe:Dictionary = getRecipeForClassOrInstance(instance, getRecipeFlyweight(), _recipesByInstance[instance]);
			lifecycle.activate(instance, recipe, this);
			returnRecipeFlyweight();
			return instance;
		}
		
		public function destroy(instance:Object):Object
		{
			instance || throwError('Argument "instance" passed to method Alchemist.destroy() must not be null.');
			
			_providersByInstance[instance] && _providersByInstance[instance].destroy(instance);
			
			const type:Class = _reflector.getType(_reflector.getTypeName(instance));
			const recipe:Dictionary = getRecipeForClassOrInstance(instance, getRecipeFlyweight(), _recipesByInstance[instance]);
			lifecycle.deactivate(instance, recipe, this);
			returnRecipeFlyweight();
			return instance;
		}
		
		public function extend():IAlchemist
		{
			const child:Alchemist = new Alchemist;
			child._parent = this;
			return child;
		}
		
		/* PRIVATE PARTS */
		
		/**
		 * Recursively looks up any provider mapped to the id through this alchemist and its ancestor chain.
		 * @param	id The custom name or qualified class name used to map the provider
		 */
		public function getMapping(id:String):* // @warning ugly
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
		private function getRecipeForClassOrInstance(classOrInstance:Object, recipeFlyweight:Dictionary, runtimeConfiguredRecipe:Dictionary = null):Dictionary 
		{
			return getRecipeForClassName(getQualifiedClassName(classOrInstance), recipeFlyweight, runtimeConfiguredRecipe);
		}
		
		/**
		 * @private
		 */
		private function getRecipeForClassName(qualifiedClassName:String, recipeFlyweight:Dictionary, runtimeConfiguredRecipe:Dictionary = null):Dictionary
		{
			return getMergedRecipe(recipeFlyweight, _recipeFactory.getRecipeForClassNamed(qualifiedClassName), getRecipe(qualifiedClassName), runtimeConfiguredRecipe);
		}
		
		/**
		 * @private
		 */
		private function getMergedRecipe(recipeFlyweight:Dictionary, staticTypeRecipe:Dictionary, runtimeTypeRecipe:Dictionary, runtimeInstanceRecipe:Dictionary):Dictionary
		{
			/*
			 * Because of recursive nature of the algorithm a
			 * flyweight *pool* must be used to compensate for
			 * the function requiring a new recipe every recursive call.
			 */
			//const recipe:Recipe = recipeFlyweight ? recipeFlyweight.empty() : new Recipe;
			if (recipeFlyweight)
			{
				for (var key:* in recipeFlyweight)
				{
					delete recipeFlyweight[key];
				}
			}
			
			const recipe:Dictionary = recipeFlyweight ? recipeFlyweight : new Dictionary;
			staticTypeRecipe && lifecycle.inherit(recipe, staticTypeRecipe);
			runtimeTypeRecipe && lifecycle.inherit(recipe, runtimeTypeRecipe);
			runtimeInstanceRecipe && lifecycle.inherit(recipe, runtimeInstanceRecipe);
			return recipe;
		}
		
		/**
		 * @private
		 */
		private function conjureUnmappedType(qualifiedClassName:String, recipe:Dictionary):* 
		{
			/*
			 * I really dont want to map here because the user doesnt explicitely map it,
			 * and if they overwrite they will be warned
			 * what I want is to just create the instance with the factory cached recipe (not an extension)
			 * because there will be no modification
			 */
			return create(_reflector.getType(qualifiedClassName), recipe, qualifiedClassName);
		}
		
		/**
		 * @private
		 */
		private function normalizeId(id:*):String
		{
			id || throwError('Argument "id" must not be null.');
			
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
		private function mapAll(mappings:Array):void 
		{
			//(new XmlConfigurationMapper(_reflector, _languageBundle)).map(this, mappings);
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