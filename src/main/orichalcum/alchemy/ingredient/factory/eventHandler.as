package orichalcum.alchemy.ingredient.factory 
{
	import orichalcum.alchemy.ingredient.EventHandler;

	public function eventHandler(options:Object):EventHandler
	{
		return new EventHandler(options);
	}

}