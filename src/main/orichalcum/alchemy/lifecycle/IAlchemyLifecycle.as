package orichalcum.alchemy.lifecycle 
{
	import orichalcum.alchemy.recipe.ingredient.processor.IIngredientProcessor;
	
	public interface IAlchemyLifecycle extends IIngredientProcessor
	{
		function get processors():Array;
		function set processors(value:Array):void;
	}

}