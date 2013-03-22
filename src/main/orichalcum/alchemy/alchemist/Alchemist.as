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
	import orichalcum.alchemy.provider.factory.type;
	import orichalcum.alchemy.provider.factory.value;
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.recipe.factory.RecipeFactory;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.reflection.IReflector;
	import orichalcum.reflection.Reflector;
	

	internal class Alchemist implements IDisposable, IAlchemist
	{
		private var _parent:Alchemist;
		private var _reflector:IReflector;
		private var _providers:Dictionary;
		private var _recipes:Dictionary;
		private var _recipeFactory:RecipeFactory;
		private var _instanceFactory:InstanceFactory;
		private var _compoundRecipe:Recipe;
		private var _notFound:NotFound;
		private var _expressionQualifier:RegExp;
		private var _expressionRemovals:RegExp;

		/**
		 * This will be used to remove "recipe" arg from many user-facing methods
		 * Additionally it is required to facilitate disposer/binding of run-time configured objects
		 * Note unless I store the compound recipes (faulty) I must re-compute them at "destroy" time
		 */
		private var _recipesByInstance:Dictionary;
		
		public function Alchemist() 
		{
			_reflector = Reflector.getInstance(ApplicationDomain.currentDomain);
			_providers = new Dictionary;
			_recipes = new Dictionary;
			_recipesByInstance = new Dictionary;
			_recipeFactory = new RecipeFactory(_reflector, new StandardMetatagBundle);
			_instanceFactory = new InstanceFactory(this);
			_compoundRecipe = new Recipe;
			_notFound = new NotFound;
			_expressionQualifier = /^{.*}$/;
			_expressionRemovals = /{|}|\s/gm;
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

		public function map(id:*):IMapper
		{
			return _map(qualify(id));
		}
		
		private function _map(id:String):IMapper 
		{
			return new Mapper(_reflector, id, _providers, _recipes);
		}
		
		public function conjure(id:*, recipe:Recipe = null):*
		{
			return _conjure(qualify(id), recipe);
		}
		
		/**
		 * For better API do an evaluation here on provider
		 * let _providers hold providerOrReferenceOrValue
		 * This will allow for smaller data footprint because I wont need to wrap values/references in providers
		 * 
		 */
		private function _conjure(id:String, recipe:Recipe = null):* 
		{
			const provider:* = getProvider(id);
			
			if (provider === _notFound)
			{
				if (_reflector.isType(id))
					return conjureUnmappedType(id);
				
				throw new AlchemyError('Alchemist has no provider for id "{0}"', id);
			}
			
			var provision:* = evaluateWithRecipe(provider, recipe ||= getRecipe(id));
			recipe && (_recipesByInstance[provision] = recipe);
			return provision;	
		}
		
		public function create(type:Class, recipe:Recipe = null):Object
		{
			/**
			 * The fallback "getRecipe" for the class recipe should be moved into every get recipe for class/instance
			 */
			//return _instanceFactory.create(type, getRecipeForClassOrInstance(type, recipe || getRecipe(getQualifiedClassName(type))));
			return _instanceFactory.create(type, getRecipeForClassOrInstance(type, recipe));
		}
		
		public function inject(instance:Object):Object
		{
			return _instanceFactory.inject(instance, getRecipeForClassOrInstance(instance, _recipesByInstance[instance]));
		}
		
		public function destroy(instance:Object):Object
		{
			return _instanceFactory.destroy(instance, getRecipeForClassOrInstance(instance, _recipesByInstance[instance]));
		}
		
		public function extend():IAlchemist
		{
			const child:Alchemist = new Alchemist;
			child._parent = this;
			return child;
		}
		
		public function get metatagBundle():IMetatagBundle
		{
			return _recipeFactory.metatagBundle;
		}
		
		public function set metatagBundle(value:IMetatagBundle):void 
		{
			_recipeFactory.metatagBundle = value;
		}
		
		public function get expressionQualifier():RegExp
		{
			return _expressionQualifier;
		}
		
		public function set expressionQualifier(value:RegExp):void
		{
			_expressionQualifier = value;
		}
		
		public function get expressionRemovals():RegExp 
		{
			return _expressionRemovals;
		}
		
		public function set expressionRemovals(value:RegExp):void 
		{
			_expressionRemovals = value;
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
			
			return _notFound;
		}
		
		private function getRecipe(id:String):Recipe
		{
			return _recipes[id] || (_parent && _parent.getRecipe(id));
		}
		
		/**
		 * It may be helpful to expose this ustility.
		 */
		private function getRecipeForClassOrInstance(classOrInstance:Object, runtimeConfiguredRecipe:Recipe = null):Recipe 
		{
			return getRecipeForClassName(getQualifiedClassName(classOrInstance), runtimeConfiguredRecipe);
		}
		
		private function getRecipeForClassName(qualifiedClassName:String, runtimeConfiguredRecipe:Recipe = null):Recipe
		{
			/**
			 * This works because I keep the runtime-configured and metadata-configured time recipes independent
			 */
			
			//_compoundRecipe.empty().extend(_recipeFactory.getRecipeByClassName(qualifiedClassName));
			//
			//const runtimeConfiguredTypeRecipe:Recipe = getRecipe(qualifiedClassName);
			//
			//runtimeConfiguredTypeRecipe && _compoundRecipe.extend(runtimeConfiguredTypeRecipe);
			//runtimeConfiguredRecipe && _compoundRecipe.extend(runtimeConfiguredRecipe);
			//
			//return _compoundRecipe;
			
			if (runtimeConfiguredRecipe)
				return _compoundRecipe.empty().extend(_recipeFactory.getRecipeByClassName(qualifiedClassName)).extend(runtimeConfiguredRecipe);
			return _recipeFactory.getRecipeByClassName(qualifiedClassName);
		}
		
		private function conjureUnmappedType(qualifiedClassName:String):* 
		{
			//throw new ArgumentError('UNMAPPED CLASSES ARENT GETTING THE CLASS MAPPED RECIPES...');
			/*
			 * 
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
		
		private function evaluateWithRecipe(providerReferenceOrValue:*, recipe:Recipe = null):*
		{
			if (providerReferenceOrValue is IProvider)
				return (providerReferenceOrValue as IProvider).provide(this, recipe);
				
			if (providerReferenceOrValue is String && _expressionQualifier.test(providerReferenceOrValue))
				return conjure((providerReferenceOrValue as String).replace(_expressionRemovals, ''));
			
			return providerReferenceOrValue;
		}
		
		private function qualify(id:*):String
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
		
	}

}

internal class NotFound{}
