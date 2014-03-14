package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.display.ActionScriptVersion;
	import flash.utils.Dictionary;
	
	public interface IIngredientProcessor 
	{
		
		function create(typeName:String, typeDescription:XML, recipe:Dictionary):void;
		
		function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void;
		
		function activate(instance:*, recipe:Dictionary):void;
		
		function deactivate(instance:*, recipe:Dictionary):void;
	}

}