package orichalcum.alchemy.recipe.ingredient.factory 
{
	import orichalcum.alchemy.recipe.ingredient.Properties;

	public function properties(nameValuePairs:Object):Properties
	{
		return new Properties(nameValuePairs);
	}

}