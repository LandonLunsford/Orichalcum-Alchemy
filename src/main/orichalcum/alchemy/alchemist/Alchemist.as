package orichalcum.alchemy.alchemist 
{
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.configuration.xml.mapper.XmlConfigurationMapper;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.filter.IFilter;
	import orichalcum.alchemy.language.bundle.ILanguageBundle;
	import orichalcum.alchemy.language.bundle.LanguageBundle;
	import orichalcum.alchemy.process.chain.IProcessChain;
	import orichalcum.alchemy.process.chain.ProcessChain;
	import orichalcum.alchemy.process.FriendActivator;
	import orichalcum.alchemy.process.FriendDeactivator;
	import orichalcum.alchemy.process.IAlchemyProcess;
	import orichalcum.alchemy.process.InstanceBinder;
	import orichalcum.alchemy.process.InstanceComposer;
	import orichalcum.alchemy.process.InstanceCreator;
	import orichalcum.alchemy.process.InstanceDestroyer;
	import orichalcum.alchemy.process.InstanceInjector;
	import orichalcum.alchemy.process.InstanceUnbinder;
	import orichalcum.alchemy.process.InstanceUnjector;
	import orichalcum.alchemy.mapper.AlchemyMapper;
	import orichalcum.alchemy.mapper.IAlchemyMapper;
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.recipe.factory.RecipeFactory;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.reflection.IReflector;
	import orichalcum.reflection.Reflector;
	
	public class Alchemist extends EventDispatcher implements IDisposable, IAlchemist
	{
		/**
		 * Reflection utility
		 * @private
		 */
		static private var _reflector:IReflector = Reflector.getInstance(ApplicationDomain.currentDomain);
		
		/**
		 * Parsing rules
		 * @private
		 */
		static private var _languageBundle:ILanguageBundle = new LanguageBundle;
		
		/**
		 * Generates recipes based on class metatags
		 * @private
		 */
		static private var _recipeFactory:RecipeFactory = new RecipeFactory(_reflector, _languageBundle);
		
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
		private var _friendsByInstance:Dictionary = new Dictionary;
		
		/**
		 * Creational lifecylce processes
		 * @private
		 */
		private var _creator:IAlchemyProcess = new InstanceCreator(this as IEvaluator);
		
		/**
		 * Creational lifecylce processes
		 * @private
		 */
		private var _createFilters:IProcessChain = new ProcessChain(
			//new InstanceCreator(this as IEvaluator),
			new InstanceInjector(this as IEvaluator),
			new InstanceBinder,
			new InstanceComposer,
			new FriendActivator(this as IAlchemist, _friendsByInstance)
		);
		
		/**
		 * Injection lifecycle processes
		 * @private
		 */
		private var _injectionFilters:IProcessChain = new ProcessChain(
			new InstanceInjector(this as IEvaluator),
			new InstanceBinder
		);
		
		/**
		 * Lifecycle processes for destruction
		 * @private
		 */
		private var _destroyFilters:IProcessChain = new ProcessChain(
			new FriendDeactivator(this as IAlchemist, _friendsByInstance),
			new InstanceUnbinder,
			new InstanceDestroyer,
			new InstanceUnjector
		);
		
		/**
		 * The backward reference to the source of the this Alchemist
		 * Finding fallback providers and recipes in the parent alchemist
		 * thisAlchemist = parentAlchemist.extend()
		 * @private
		 */
		private var _parent:Alchemist;
		
		/**
		 * @private used to prevent infinite loops for circular dependencies
		 */
		private var _instancesInProcessById:Dictionary = new Dictionary;
		
		/**
		 * Experimental.
		 * Allows hooking into each provide() and destroy() call
		 */
		public var filters:Vector.<IFilter> = new Vector.<IFilter>;
		
		
		/**
		 * @param list of XML mapping configurations
		 */
		public function Alchemist(...mappings)
		{
			mappings && mapAll(mappings);
			map(getQualifiedClassName(this)).to(this);
		}
		
		static public function get languageBundle():ILanguageBundle
		{
			return _languageBundle;
		}
		
		static public function set languageBundle(value:ILanguageBundle):void
		{
			_languageBundle = value;
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
		}
		
		/* INTERFACE orichalcum.alchemy.alchemist.IAlchemist */

		public function map(id:*):IAlchemyMapper
		{
			return new AlchemyMapper(_reflector, getValidId(id), _providers, _recipes);
		}
		
		public function conjure(id:*, recipe:Recipe = null):*
		{
			const validId:String = getValidId(id);
			
			if (_instancesInProcessById[validId])
				return _instancesInProcessById[validId];
			
			const provider:* = getProvider(validId);
			var provision:*;
			
			if (provider === NotFound)
			{
				_reflector.isType(validId) || throwError('Alchemist has no provider mapped to "{0}"', validId);
				provision = conjureUnmappedType(validId);
			}
			else
			{
				provision = evaluateWithRecipe(validId, provider, recipe ||= getRecipe(validId));
				provider && (_providersByInstance[provision] = provider);
			}
			
			recipe && (_recipesByInstance[provision] = recipe);
			
			_applyProvideFilters(provision);
			
			return provision;	
		}
		
		public function create(type:Class, recipe:Recipe = null, id:* = null):Object
		{
			type || throwError('Argument "type" passed to method Alchemist.create() must not be null.');
			
			//if (_instancesInProcessById[id])
			//{
				//trace('Infinite loop!')
				//return null;
			//}
			
			const recipeFlyweight:Recipe = getRecipeForClassOrInstance(type, getRecipeFlyweight(), recipe);
			const instance:* = _creator.process(null, null, type, recipeFlyweight);
			
			_instancesInProcessById[id] = instance;
			_createFilters.process(instance, null, type, recipeFlyweight);
			delete _instancesInProcessById[id];
			
			returnRecipeFlyweight();
			
			return instance;
		}
		
		public function inject(instance:Object):Object
		{
			instance || throwError('Argument "instance" passed to method Alchemist.inject() must not be null.');
			
			const type:Class = _reflector.getType(_reflector.getTypeName(instance));
			const recipe:Recipe = getRecipeForClassOrInstance(instance, getRecipeFlyweight(), _recipesByInstance[instance]);
			_injectionFilters.process(instance, null, type, recipe);
			returnRecipeFlyweight();
			return instance;
		}
		
		public function destroy(instance:Object):Object
		{
			instance || throwError('Argument "instance" passed to method Alchemist.destroy() must not be null.');
			
			_applyDestroyFilters(instance);
			_providersByInstance[instance] && (_providersByInstance[instance] as IProvider).destroy(instance);
			
			const type:Class = _reflector.getType(_reflector.getTypeName(instance));
			const recipe:Recipe = getRecipeForClassOrInstance(instance, getRecipeFlyweight(), _recipesByInstance[instance]);
			_destroyFilters.process(instance, null, type, recipe);
			returnRecipeFlyweight();
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
			return evaluateWithRecipe(null, providerReferenceOrValue, null);
		}
		
		/* PRIVATE PARTS */
		
		/**
		 * Recursively looks up any provider mapped to the id through this alchemist and its ancestor chain.
		 * @param	id The custom name or qualified class name used to map the provider
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
		 * Recursively looks up any recipe mapped to the id through this alchemist and its ancestor chain.
		 * @param	id The custom name or qualified class name used to map the recipe
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
			 * Because of recursive nature of the algorithm a
			 * flyweight *pool* must be used to compensate for
			 * the function requiring a new recipe every recursive call.
			 */
			
			const recipe:Recipe = recipeFlyweight ? recipeFlyweight.empty() : new Recipe;
			staticTypeRecipe && recipe.extend(staticTypeRecipe);
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
			return create(_reflector.getType(qualifiedClassName), getRecipe(qualifiedClassName), qualifiedClassName);
		}
		
		/**
		 * Evaluating the contents of the provider map at "conjure-time" not only provides for a better user API
		 * but also minimizes the libraries data footprint by avoiding excessive wrapping of values/references with providers
		 * @private
		 */
		private function evaluateWithRecipe(id:*, providerReferenceOrValue:*, recipe:Recipe = null):*
		{
			if (providerReferenceOrValue is IProvider)
				return (providerReferenceOrValue as IProvider).provide(id, this, recipe);
				
			if (providerReferenceOrValue is String && _languageBundle.expressionLanguage.expressionQualifier.test(providerReferenceOrValue))
				return conjure((providerReferenceOrValue as String).replace(_languageBundle.expressionLanguage.expressionRemovals, ''));
			
			return providerReferenceOrValue;
		}
		
		/**
		 * @private
		 */
		private function getValidId(id:*):String
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
		
		/**
		 * @private
		 */
		private function mapAll(mappings:Array):void 
		{
			(new XmlConfigurationMapper(_reflector, _languageBundle)).map(this, mappings);
		}
		
		/**
		 * @private
		 */
		private function _applyProvideFilters(instance:*):void 
		{
			for each(var filter:IFilter in filters)
			{
				filter && filter.applies(instance, this) && filter.onProvide(instance, this);
			}
		}
		
		/**
		 * @private
		 */
		private function _applyDestroyFilters(instance:Object):void 
		{
			for each(var filter:IFilter in filters)
			{
				filter && filter.applies(instance, this) && filter.onDestroy(instance, this);
			}
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
