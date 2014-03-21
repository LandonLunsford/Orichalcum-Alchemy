package orichalcum.alchemy.ingredient.factory 
{
	import orichalcum.alchemy.ingredient.ConstructorArgument;

	public function constructorArgument(value:*, index:int = -1):ConstructorArgument
	{
		return new ConstructorArgument(value, index);
	}

}