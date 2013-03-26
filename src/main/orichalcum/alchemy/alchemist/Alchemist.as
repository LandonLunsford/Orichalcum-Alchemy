package orichalcum.alchemy.alchemist 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.mapper.IMapper;
	import orichalcum.alchemy.mapper.Mapper;
	import orichalcum.alchemy.metatag.bundle.IMetatagBundle;
	import orichalcum.alchemy.metatag.bundle.StandardMetatagBundle;
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.recipe.factory.RecipeFactory;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.reflection.IReflector;
	import orichalcum.reflection.Reflector;
	
	public class Alchemist implements IDisposable, IAlchemist
	{
		/**
		 * Contains all live mediators so they will not be garbage collected
		 * @private
		 */
		private var _activeMediators:Array = [];
		
		/**
		 * Contains all mapped mediators
		 * @private
		 */
		private var _mediators:Dictionary = new Dictionary;
		
		/**
		 * Used to lookup the appropriate mediator mapped to a specific view instance
		 * @private
		 */
		private var _mediatorsByView:Dictionary = new Dictionary;
		
		/**
		 * @private
		 */
		static private var _reflector:IReflector = Reflector.getInstance(ApplicationDomain.currentDomain);
		
		/**
		 * Generates recipes based on class metatags
		 * @private
		 */
		static private var _recipeFactory:RecipeFactory = new RecipeFactory(_reflector, new StandardMetatagBundle);
		
		/**
		 * Creates, injects, binds, unbinds, unjects and destroys instances
		 * @private
		 */
		static private var _instanceFactory:InstanceFactory = new InstanceFactory;
		
		/**
		 * @private
		 */
		static private var _expressionQualifier:RegExp = /^{.*}$/;
		
		/**
		 * @private
		 */
		static private var _expressionRemovals:RegExp = /{|}|\s/gm;
		
		/**
		 * Used to avoid creating a new recipes every recursive step taken during the conjure|create|inject processes.
		 * The caller of the recursive-compound-recipe-consuming-function must return the recipe flyweight after use.
		 * @private
		 */
		static private var _recipeFlyweights:Array = [];
		
		/**
		 * Used to manage the recipe flyweight pool
		 * @private
		 */
		static private var _recipeFlyweightsIndex:int;
		
		/**
		 * Contains all mapped providers
		 * @private
		 */
		private var _providers:Dictionary = new Dictionary;
		
		/**
		 * Contains all mapped recipes
		 * @private
		 */
		private var _recipes:Dictionary = new Dictionary;
		
		/**
		 * Used to facilitate unbinding and pre-destroy hooks for runtime configured instances
		 * @private
		 */
		private var _recipesByInstance:Dictionary = new Dictionary;
		
		/**
		 * The backward reference to the source of the this Alchemist
		 * Finding fallback providers and recipes in the parent alchemist
		 * thisAlchemist = parentAlchemist.extend()
		 * @private
		 */
		private var _parent:Alchemist;
		
		
		/**
		 * Used to identify strings that represent references to other mappings
		 * @default /^{.*}$/
		 */
		static public function get expressionQualifier():RegExp
		{
			return _expressionQualifier;
		}
		
		static public function set expressionQualifier(value:RegExp):void
		{
			_expressionQualifier = value;
		}
		
		/**
		 * Used to strip the characters used to qualify a reference from the reference string
		 * @default /{|}|\s/gm
		 */
		static public function get expressionRemovals():RegExp 
		{
			return _expressionRemovals;
		}
		
		static public function set expressionRemovals(value:RegExp):void 
		{
			_expressionRemovals = value;
		}
		
		/**
		 * Used to customize the metatags used to qualify injections, post-construct, pre-destroy and event handlers
		 * @default orichalcum.alchemy.metatag.bundle.StandardMetatagBundle
		 */
		static public function get metatagBundle():IMetatagBundle
		{
			return _recipeFactory.metatagBundle;
		}
		
		static public function set metatagBundle(value:IMetatagBundle):void 
		{
			_recipeFactory.metatagBundle = value;
		}
		
		/* INTERFACE orichalcum.lifecycle.IDisposable */
		
		public function dispose():void
		{
			for (var providerName:String in _providers)
			{
				_providers[providerName] is IDisposable && (_providers[providerName] as IDisposable).dispose();
				delete _providers[providerName];
			}
			for (var recipeName:String in _recipes)
			{
				_recipes[recipeName] is IDisposable && (_recipes[recipeName] as IDisposable).dispose();
				delete _recipes[recipeName];
			}
			_recipeFactory is IDisposable && (_recipeFactory as IDisposable).dispose();
			_parent = null;
			_providers = null;
			_recipes = null;
			
			_activeMediators = null;
			_mediators = null;
			_mediatorsByView = null;
		}
		
		/* INTERFACE orichalcum.alchemy.alchemist.IAlchemist */

		public function map(id:*):IMapper
		{
			return new Mapper(_reflector, getValidId(id), _providers, _recipes, _mediators);
		}
		
		public function conjure(id:*, recipe:Recipe = null):*
		{
			id = getValidId(id);
			
			const provider:* = getProvider(id);
			
			if (provider === NotFound)
			{
				if (!_reflector.isType(id))
					throw new AlchemyError('Alchemist has no provider mapped to "{0}"', id);
					
				return conjureUnmappedType(id);
			}
			
			const provision:* = evaluateWithRecipe(provider, recipe ||= getRecipe(id));
			recipe && (_recipesByInstance[provision] = recipe);
			
			/**
			 * This will allow the display object to trigger its mediator when added to stage
			 */
			const mediator:* = getMediator(id);
			if (mediator)
			{
				if (!(provision is DisplayObject))
					throw new AlchemyError('"{0}" must be of type DisplayObject in order to be Mediated.', id);
				
				const view:DisplayObject = provision as DisplayObject;
				view.addEventListener(Event.ADDED_TO_STAGE, activateMediator);
				view.addEventListener(Event.REMOVED_FROM_STAGE, deactivateMediator);
				_mediatorsByView[view] = mediator;
			}
			
			/**
			 * Add the following code to implement pooled instance providers.
			 * 
			 * provider is IPooledInstanceProvider && (_pooledProvidersByInstance ||= new Dictionary)[provision] = provider;
			 */
			
			return provision;	
		}
		
		public function create(type:Class, recipe:Recipe = null):Object
		{
			if (!type) throw new ArgumentError('Argument "type" passed to method Alchemist.create() must not be null.');
			const instance:* = _instanceFactory.create(type, getRecipeForClassOrInstance(type, getRecipeFlyweight(), recipe), this);
			returnRecipeFlyweight();
			return instance;
		}
		
		public function inject(instance:Object):Object
		{
			if (!instance) throw new ArgumentError('Argument "instance" passed to method Alchemist.create() must not be null.');
			_instanceFactory.inject(instance, getRecipeForClassOrInstance(instance, getRecipeFlyweight(), _recipesByInstance[instance]), this);
			returnRecipeFlyweight();
			return instance;
		}
		
		public function destroy(instance:Object):Object
		{
			if (!instance) throw new ArgumentError('Argument "instance" passed to method Alchemist.create() must not be null.');
			_instanceFactory.destroy(instance, getRecipeForClassOrInstance(instance, getRecipeFlyweight(), _recipesByInstance[instance]));
			returnRecipeFlyweight();
			
			/**
			 * Add the following code to implement pooled instance providers.
			 * 
			 * _pooledProvidersByInstance && _pooledProvidersByInstance[provision] && _pooledProvidersByInstance[provision].returnInstance(instance);
			 */
			
			return instance;
		}
		
		public function extend():IAlchemist
		{
			const child:Alchemist = new Alchemist;
			child._parent = this;
			return child;
		}
		
		/* INTERFACE orichalcum.alchemy.evaluator.IEvaluator */
		
		public function evaluate(providerReferenceOrValue:*):*
		{
			return evaluateWithRecipe(providerReferenceOrValue, null);
		}
		
		/* PRIVATE PARTS */
		
		/**
		 * Recursively looks-up the provider for the ID through this alchemist and its ancestor chain
		 * @private
		 */
		private function getProvider(id:String):*
		{
			if (id in _providers)
				return _providers[id];
				
			if (_parent)
				return _parent.getProvider(id);
			
			return NotFound;
		}
		
		/**
		 * Recursively looks-up the recipe for the ID through this alchemist and its ancestor chain
		 * @private
		 */
		private function getRecipe(id:String):Recipe
		{
			if (id in _recipes)
				return _recipes[id];
				
			if (_parent)
				return _parent.getRecipe(id);
				
			return null;
		}
		
		/**
		 * Recursively looks-up the mediator for the ID through this alchemist and its ancestor chain
		 * @private
		 */
		private function getMediator(id:String):*
		{
			if (id in _mediators)
				return _mediators[id];
				
			if (_parent)
				return _parent.getMediator(id);
				
			return null;
		}
		
		/**
		 * @private
		 */
		private function getRecipeForClassOrInstance(classOrInstance:Object, recipeFlyweight:Recipe, runtimeConfiguredRecipe:Recipe = null):Recipe 
		{
			return getRecipeForClassName(getQualifiedClassName(classOrInstance), recipeFlyweight, runtimeConfiguredRecipe);
		}
		
		/**
		 * @private
		 */
		private function getRecipeForClassName(qualifiedClassName:String, recipeFlyweight:Recipe, runtimeConfiguredRecipe:Recipe = null):Recipe
		{
			return getMergedRecipe(recipeFlyweight, _recipeFactory.getRecipeByClassName(qualifiedClassName), getRecipe(qualifiedClassName), runtimeConfiguredRecipe);
		}
		
		/**
		 * @private
		 */
		private function getMergedRecipe(recipeFlyweight:Recipe, staticTypeRecipe:Recipe, runtimeTypeRecipe:Recipe, runtimeInstanceRecipe:Recipe):Recipe
		{
			/*
			 * Flyweight POOL must be used
			 * Because of recursive nature of the algorithm
			 * each recursion clobbers the parent's recipe config
			 * 
			 * Hotfix -- generate a new recipe in this scope
			 * Bestfix -- create recipe flyweight pool for efficiency
			 * 
			 * To implement flyweight pool, pass flyweight to this function
			 * this function should get flyweights with counter that is reset
			 * i.e. var scopedRecipe:Recipe = (_recipePool[i++] ||= new Recipe).empty();
			 * 
			 * Then the "getMergedRecipe()" caller must set "i" to 0 when the recursion has ended
			 */
			
			const recipe:Recipe = recipeFlyweight ? recipeFlyweight.empty() : new Recipe;
			recipe.extend(staticTypeRecipe);
			runtimeTypeRecipe && recipe.extend(runtimeTypeRecipe);
			runtimeInstanceRecipe && recipe.extend(runtimeInstanceRecipe);
			return recipe;
		}
		
		/**
		 * @private
		 */
		private function conjureUnmappedType(qualifiedClassName:String):* 
		{
			/*
			 * I really dont want to map here because the user doesnt explicitely map it,
			 * and if they overwrite they will be warned
			 * what I want is to just create the instance with the factory cached recipe (not an extension)
			 * because there will be no modification
			 */
			return create(_reflector.getType(qualifiedClassName), getRecipe(qualifiedClassName));
		}
		
		/**
		 * Evaluating the contents of the provider map at "conjure-time" not only provides for a better user API
		 * but also minimizes the libraries data footprint by avoiding excessive wrapping of values/references with providers
		 * @private
		 */
		private function evaluateWithRecipe(providerReferenceOrValue:*, recipe:Recipe = null):*
		{
			if (providerReferenceOrValue is IProvider)
				return (providerReferenceOrValue as IProvider).provide(this, recipe);
				
			if (providerReferenceOrValue is String && _expressionQualifier.test(providerReferenceOrValue))
				return conjure((providerReferenceOrValue as String).replace(_expressionRemovals, ''));
			
			return providerReferenceOrValue;
		}
		
		/**
		 * @private
		 */
		private function getValidId(id:*):String
		{
			if (id == null)
				throw new ArgumentError('Argument "id" must not be null.');
			
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
				throw new ArgumentError('Argument "id" must be of type "String" or "Class" not ' + _reflector.getTypeName(validId));
			}
			if (_reflector.isPrimitiveType(id))
			{
				throw new ArgumentError('Argument "id" must not be any of these primitive types: (Function, Object, Array, Boolean, Number, String, int, uint)');
			}
			
			return validId;
		}
		
		/**
		 * @private
		 */
		private function getRecipeFlyweight():Recipe 
		{
			return _recipeFlyweights[_recipeFlyweightsIndex++] ||= new Recipe;
		}
		
		/**
		 * @private
		 */
		private function returnRecipeFlyweight():void
		{
			_recipeFlyweightsIndex--;
		}
		
		private function deactivateMediator(event:Event):void 
		{
			const view:DisplayObject = event.target as DisplayObject;
			view.removeEventListener(Event.REMOVED_FROM_STAGE, deactivateMediator);
			const mediator:* = evaluate(_mediatorsByView[view]);
			_activeMediators.push(mediator);
		}
		
		private function activateMediator(event:Event):void 
		{
			const view:DisplayObject = event.target as DisplayObject;
			view.removeEventListener(Event.ADDED_TO_STAGE, activateMediator);
			const mediator:* = evaluate(_mediatorsByView[view]);
			_activeMediators.splice(_activeMediators.indexOf(mediator), 1);
		}
		
	}

}

/**
 * A unique class must be used to represent the absence of a provision|provider
 * This is to avoid reserving real values (mainly null or undefined) that the client may want to use
 */
internal class NotFound{}
