package orichalcum.alchemy.ingredient.factory 
{
	import orichalcum.alchemy.ingredient.Properties;

	public function properties(nameValuePairs:Object):Properties
	{
		return new Properties(nameValuePairs);
	}

}