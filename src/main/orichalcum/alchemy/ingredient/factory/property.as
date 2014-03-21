package orichalcum.alchemy.ingredient.factory 
{
	import orichalcum.alchemy.ingredient.Property;

	public function property(name:String, value:*):Property
	{
		return new Property(name, value);
	}

}