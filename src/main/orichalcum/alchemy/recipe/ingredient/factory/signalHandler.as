package orichalcum.alchemy.recipe.ingredient.factory 
{
	import orichalcum.alchemy.recipe.ingredient.SignalHandler;

	public function signalHandler(signalPath:String, slotPath:String, once:Boolean = false):SignalHandler
	{
		return new SignalHandler(signalPath, slotPath, once);
	}

}
