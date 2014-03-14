package orichalcum.alchemy.recipe.ingredient.factory 
{
	import orichalcum.alchemy.recipe.ingredient.EventHandler;

	public function eventHandler(options:Object):EventHandler
	{
		return new EventHandler(options);
	}

}