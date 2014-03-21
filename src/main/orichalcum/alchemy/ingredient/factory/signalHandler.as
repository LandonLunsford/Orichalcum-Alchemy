package orichalcum.alchemy.ingredient.factory 
{
	import orichalcum.alchemy.ingredient.SignalHandler;

	public function signalHandler(signalPath:String, slotPath:String, once:Boolean = false):SignalHandler
	{
		return new SignalHandler(signalPath, slotPath, once);
	}

}
