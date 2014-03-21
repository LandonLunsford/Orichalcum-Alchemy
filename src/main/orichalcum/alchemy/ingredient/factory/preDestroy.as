package orichalcum.alchemy.ingredient.factory 
{
	import orichalcum.alchemy.ingredient.PreDestroy;

	public function preDestroy(name:String):PreDestroy
	{
		return new PreDestroy(name);
	}

}