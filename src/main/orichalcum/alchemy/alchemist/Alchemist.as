package orichalcum.alchemy.alchemist 
{
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
	
	
	internal class Alchemist implements IDisposable, IAlchemist
	{
		
		/**
		 * @private
		 */
		static private var _expressionQualifier:RegExp = /^{.*}$/;
		
		/**
		 * @private
		 */
		static private var _expressionRemovals:RegExp = /{|}|\s/gm;
		
		/**
		 * @private
		 */
		private var _reflector:IReflector = Reflector.getInstance(ApplicationDomain.currentDomain);
		
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
		 * Generates recipes based on class metatags
		 * @private
		 */
		private var _recipeFactory:RecipeFactory = new RecipeFactory(_reflector, new StandardMetatagBundle);
		
		/**
		 * Creates, injects, binds, unbinds, unjects and destroys instances
		 * @private
		 */
		private var _instanceFactory:InstanceFactory = new InstanceFactory(this);
		
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
		
		/**
		 * @inheritDoc
		 */
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
			_instanceFactory is IDisposable && (_instanceFactory as IDisposable).dispose();
			_parent = null;
			_reflector = null;
			_providers = null;
			_recipes = null;
			_recipeFactory = null;
			_instanceFactory = null;
			_expressionQualifier = null;
			_expressionRemovals = null;
		}
		
		/* INTERFACE orichalcum.alchemy.alchemist.IAlchemist */

		/**
		 * @inheritDoc
		 */
		public function map(id:*):IMapper
		{
			return new Mapper(_reflector, getValidId(id), _providers, _recipes);
		}
		
		/**
		 * @inheritDoc
		 */
		public function conjure(id:*, recipe:Recipe = null):*
		{
			id = getValidId(id);
			
			const provider:* = getProvider(id);
			
			if (provider === NotFound)
			{
				if (_reflector.isType(id))
					return conjureUnmappedType(id);
				
				throw new AlchemyError('Alchemist has no provider for id "{0}"', id);
			}
			
			var provision:* = evaluateWithRecipe(provider, recipe ||= getRecipe(id));
			recipe && (_recipesByInstance[provision] = recipe);
			
			/**
			 * Add the following code to implement instance pooling.
			 * 
			 * provider is IPooledInstanceProvider && (_pooledProvidersByInstance ||= new Dictionary)[provision] = provider;
			 */
			
			return provision;	
		}
		
		/**
		 * This method is to bypass mapped providers
		 */
		public function create(type:Class, recipe:Recipe = null):Object
		{
			const instance:* = _instanceFactory.create(type, getRecipeForClassOrInstance(type, getRecipeFlyweight(), recipe));
			returnRecipeFlyweight();
			return instance;
		}
		
		/**
		 * This method is to apply injection, but leave creation up to the client
		 */
		public function inject(instance:Object):Object
		{
			const instance:* = _instanceFactory.inject(instance, getRecipeForClassOrInstance(instance, getRecipeFlyweight(), _recipesByInstance[instance]));
			returnRecipeFlyweight();
			return instance;
		}
		
		public function destroy(instance:Object):Object
		{
			const instance:* = _instanceFactory.destroy(instance, getRecipeForClassOrInstance(instance, getRecipeFlyweight(), _recipesByInstance[instance]));
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
		
		/* PRIVATE PARTS */
		
		/**
		 * Evaluation-friendly implementation
		 * Must return unique object to avoid reserving any value
		 */
		private function getProvider(id:String):*
		{
			if (id in _providers)
				return _providers[id];
				
			if (_parent)
				return _parent.getProvider(id);
			
			return NotFound;
		}
		
		private function getRecipe(id:String):Recipe
		{
			if (id in _recipes)
				return _recipes[id];
				
			if (_parent)
				return _parent.getRecipe(id);
				
			return null;
		}
		
		private function getRecipeForClassOrInstance(classOrInstance:Object, recipeFlyweight:Recipe, runtimeConfiguredRecipe:Recipe = null):Recipe 
		{
			return getRecipeForClassName(getQualifiedClassName(classOrInstance), recipeFlyweight, runtimeConfiguredRecipe);
		}
		
		private function getRecipeForClassName(qualifiedClassName:String, recipeFlyweight:Recipe, runtimeConfiguredRecipe:Recipe = null):Recipe
		{
			return getMergedRecipe(recipeFlyweight, _recipeFactory.getRecipeByClassName(qualifiedClassName), getRecipe(qualifiedClassName), runtimeConfiguredRecipe);
		}
		
		private function getMergedRecipe(recipeFlyweight:Recipe, staticTypeRecipe:Recipe, runtimeTypeRecipe:Recipe, runtimeInstanceRecipe:Recipe):Recipe
		{
			/**
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
		
		public function evaluate(providerReferenceOrValue:*):*
		{
			return evaluateWithRecipe(providerReferenceOrValue, null);
		}
		
		/**
		 * Evaluating the contents of the provider map at "conjure-time" not only provides for a better user API
		 * but also minimizes the libraries data footprint by avoiding excessive wrapping of values/references with providers
		 */
		private function evaluateWithRecipe(providerReferenceOrValue:*, recipe:Recipe = null):*
		{
			if (providerReferenceOrValue is IProvider)
				return (providerReferenceOrValue as IProvider).provide(this, recipe);
				
			if (providerReferenceOrValue is String && _expressionQualifier.test(providerReferenceOrValue))
				return conjure((providerReferenceOrValue as String).replace(_expressionRemovals, ''));
			
			return providerReferenceOrValue;
		}
		
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
		 * @deprecated
		 */
		private function provides(id:*):Boolean 
		{
			return providesDirectly(id) || (_parent && _parent.provides(id));
		}
		
		/**
		 * @deprecated
		 */
		private function providesDirectly(id:*):Boolean 
		{
			return _providers[id] != undefined;
		}
		
		/**
		 * @deprecated
		 */
		private function cooks(id:*):Boolean
		{
			return cooksDirectly(id) || (_parent && _parent.cooks(id));
		}
		
		/**
		 * @deprecated
		 */
		private function cooksDirectly(id:*):Boolean 
		{
			return _recipes[id] != undefined;
		}
		
		private function getRecipeFlyweight():Recipe 
		{
			return _recipeFlyweights[_recipeFlyweightsIndex++] ||= new Recipe;
		}
		
		private function returnRecipeFlyweight():void
		{
			_recipeFlyweightsIndex--;
		}

	}

}

/**
 * A unique class must be used to represent the absence of a provision|provider
 * This is to avoid reserving real values (mainly null or undefined) that the client may want to use
 */
internal class NotFound{}
