package orichalcum.alchemy.recipe.ingredient.factory 
{
	import orichalcum.alchemy.recipe.ingredient.Symbiot;

	public function symbiot(id:*):Symbiot
	{
		return new Symbiot(id);
	}

}