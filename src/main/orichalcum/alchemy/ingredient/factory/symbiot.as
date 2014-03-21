package orichalcum.alchemy.ingredient.factory 
{
	import orichalcum.alchemy.ingredient.Symbiot;

	public function symbiot(id:*):Symbiot
	{
		return new Symbiot(id);
	}

}