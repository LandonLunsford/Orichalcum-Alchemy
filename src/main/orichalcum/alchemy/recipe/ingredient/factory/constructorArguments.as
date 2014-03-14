package orichalcum.alchemy.recipe.ingredient.factory 
{
	import orichalcum.alchemy.recipe.ingredient.ConstructorArguments;

	public function constructorArguments(...values):ConstructorArguments
	{
		return new ConstructorArguments(values);
	}

}