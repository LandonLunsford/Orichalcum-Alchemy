package orichalcum.alchemy.ingredient.factory 
{
	import orichalcum.alchemy.ingredient.ConstructorArguments;

	public function constructorArguments(...values):ConstructorArguments
	{
		return new ConstructorArguments(values);
	}

}