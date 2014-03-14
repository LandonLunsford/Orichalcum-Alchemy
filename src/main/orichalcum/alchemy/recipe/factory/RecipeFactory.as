package orichalcum.alchemy.recipe.factory 
{
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.recipe.ingredient.processor.IIngredientProcessor;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.reflection.IReflector;


	public class RecipeFactory implements IDisposable
	{
		//static private const MULTIPLE_METATAGS_ERROR_MESSAGE:String = 'Multiple "[{0}]" metatags defined in class "{2}".';
		//static private const MULTIPLE_METATAGS_FOR_MEMBER_ERROR_MESSAGE:String = 'Multiple "[{0}]" metatags defined for member "{1}" of class "{2}".';
		//static private const MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE:String = 'Multiple "{0}" attributes found on "[{1}]" metatag for member "{2}" in class "{3}".';
		//static private const NO_REQUIRED_METATAG_ATTRIBUTE_ERROR_MESSAGE:String = 'Required attribute "{0}" not found on "[{1}]" metatag for "{2}" in class "{3}".';
		
		private var _typeRecipes:Dictionary;
		private var _alchemist:IAlchemist;
		
		public function get reflector():IReflector 
		{
			return _alchemist.reflector;
		}
		
		public function RecipeFactory(reflector:IReflector, _alchemist:IAlchemist)
		{
			_typeRecipes = new Dictionary;
			
			/**
			 * Defensively priming cache with basic types
			 */
			const nullRecipe:Dictionary = new Dictionary;
			const basicTypes:Array = [Object, Array, Function, Class, Number, String, int, uint, Boolean];
			for each(var type:Class in basicTypes)
			{
				_typeRecipes[reflector.getTypeName(type)] = nullRecipe;
			}
		}
		
		/* INTERFACE orichalcum.lifecycle.IDisposable */
		
		public function dispose():void 
		{
			for (var recipeName:String in _typeRecipes)
			{
				if (_typeRecipes[recipeName] is IDisposable)
				{
					(_typeRecipes[recipeName] as IDisposable).dispose();
				}
				delete _typeRecipes[recipeName];
			}
			_typeRecipes = null;
		}
		
		public function getRecipeForClass(classOrInstance:*):Dictionary
		{
			return getRecipeByClassName(getQualifiedClassName(classOrInstance));
		}
		
		public function getRecipeByClassName(qualifiedClassName:String):Dictionary
		{
			return _typeRecipes[qualifiedClassName] ||= createRecipe(qualifiedClassName);
		}
		
		public function createRecipe(qualifiedClassName:String):Dictionary
		{
			const typeDescription:XML = describeType(reflector.getType(qualifiedClassName));
			const factory:XML = typeDescription.factory[0];
			const superclasses:XMLList = factory.extendsClass.@type;
			
			/* 
			 * Ideally I would like to do this somewhere else
			 * But it is convenient and efficient to catch this error here.
			 */
			if (superclasses.length() == 0)
			{
				throw new AlchemyError('Alchemists cannot create "{0}" because it is an interface and cannot be instantiated.', qualifiedClassName);
			}
			
			const superclassName:String = superclasses[0].toString();
			
			//return
				//? createRecipeFromFactory(qualifiedClassName, factory)
				//: getRecipeByClassName(superclassName).clone().extend(createRecipeFromFactory(qualifiedClassName, factory));
				
			if (reflector.isNativeType(superclassName))
			{
				return createRecipeFromFactory(qualifiedClassName, factory);
			}
			else
			{
				const clone:Dictionary = new Dictionary;
				const superClassRecipe:Dictionary = getRecipeByClassName(superclassName);
				for (var key:* in superClassRecipe)
				{
					clone[key] = superClassRecipe[key];
				}
				
				_inherit(clone, createRecipeFromFactory(qualifiedClassName, typeDescription));
				
				return clone;
			}
				
		}
		
		private function _inherit(destination:Dictionary, source:Recipe):void 
		{
			for each(var processor:IIngredientProcessor in _alchemist.processors)
			{
				processor.inherit(destination, source);
			}
		}
		
		public function createRecipeFromFactory(typeName:String, typeDescription:XML):Dictionary
		{
			const recipe:Dictionary = new Dictionary;
			for each(var processor:IIngredientProcessor in _alchemist.processors)
			{
				processor.create(typeName, typeDescription, recipe);
			}
			return recipe;
		}
		
	}

}
