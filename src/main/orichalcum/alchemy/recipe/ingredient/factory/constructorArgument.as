package orichalcum.alchemy.recipe.ingredient.factory 
{
	import orichalcum.alchemy.recipe.ingredient.ConstructorArgument;

	public function constructorArgument(value:*, index:int = -1):ConstructorArgument
	{
		return new ConstructorArgument(value, index);
	}

}