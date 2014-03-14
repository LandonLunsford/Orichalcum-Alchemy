package orichalcum.alchemy.recipe.ingredient.factory 
{
	import orichalcum.alchemy.recipe.ingredient.SignalHandler;

	public function signalHandler(options:Object):SignalHandler
	{
		return new SignalHandler(options);
	}

}