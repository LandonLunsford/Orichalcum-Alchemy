package orichalcum.alchemy.recipe.ingredient.factory 
{
	import orichalcum.alchemy.recipe.ingredient.Property;

	public function property(name:String, value:*):Property
	{
		return new Property(name, value);
	}

}