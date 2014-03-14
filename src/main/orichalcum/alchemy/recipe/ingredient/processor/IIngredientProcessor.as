package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.display.ActionScriptVersion;
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	
	public interface IIngredientProcessor 
	{
		
		function create(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void;
		
		function add(recipe:Dictionary, ingredient:Object):void;
		
		function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void;
		
		function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		
		function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
	}

}