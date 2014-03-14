package orichalcum.alchemy.recipe.factory 
{
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.recipe.ingredient.processor.IIngredientProcessor;
	import orichalcum.datastructure.Maps;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.reflection.IReflector;


	public class RecipeFactory implements IDisposable
	{
		private var _alchemist:IAlchemist;
		private var _recipesByClassName:Dictionary;
		
		public function get reflector():IReflector 
		{
			return _alchemist.reflector;
		}
		
		public function RecipeFactory(alchemist:IAlchemist)
		{
			_alchemist = alchemist;
			_recipesByClassName = new Dictionary;
			
			/**
			 * Defensively priming cache with basic types
			 */
			const basicTypes:Array = [Object, Array, Function, Class, Number, String, int, uint, Boolean];
			const emptyRecipe:Dictionary = new Dictionary;
			for each(var type:Class in basicTypes)
			{
				_recipesByClassName[reflector.getTypeName(type)] = emptyRecipe;
			}
		}
		
		public function dispose():void 
		{
			_alchemist = null;
			_recipesByClassName = null;
		}
		
		public function getRecipeForClass(classOrInstance:*):Dictionary
		{
			return getRecipeByClassName(reflector.getTypeName(classOrInstance));
		}
		
		public function getRecipeByClassName(qualifiedClassName:String):Dictionary
		{
			return _recipesByClassName[qualifiedClassName] ||= createRecipe(qualifiedClassName);
		}
		
		public function createRecipe(qualifiedClassName:String):Dictionary
		{
			const typeDescription:XML = describeType(reflector.getType(qualifiedClassName));
			const superclasses:XMLList = typeDescription.factory[0].extendsClass.@type;
			
			/* 
			 * Ideally I would like to do this somewhere else
			 * But it is convenient and efficient to catch this error here.
			 */
			if (superclasses.length() == 0)
				throw new AlchemyError('Cannot create "{}" because it is an interface and cannot be instantiated.', qualifiedClassName);
			
			const superclassName:String = superclasses[0].toString();
			
			return reflector.isNativeType(superclassName)
				? createRecipeFromFactory(qualifiedClassName, typeDescription)
				: _inherit(Maps.fromObject(getRecipeByClassName(superclassName)),
					createRecipeFromFactory(qualifiedClassName, typeDescription));
		}
		
		public function createRecipeFromFactory(typeName:String, typeDescription:XML):Dictionary
		{
			const recipe:Dictionary = new Dictionary;
			for each(var processor:IIngredientProcessor in _alchemist.processors)
			{
				processor.introspect(typeName, typeDescription, recipe, _alchemist);
			}
			return recipe;
		}
		
		private function _inherit(destination:Dictionary, source:Dictionary):Dictionary 
		{
			for each(var processor:IIngredientProcessor in _alchemist.processors)
			{
				processor.inherit(destination, source);
			}
			return destination;
		}
		
	}

}
