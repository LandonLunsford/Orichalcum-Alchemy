package orichalcum.alchemy.recipe.ingredient.factory 
{
	import orichalcum.alchemy.recipe.ingredient.PreDestroy;

	public function preDestroy(name:String):PreDestroy
	{
		return new PreDestroy(name);
	}

}