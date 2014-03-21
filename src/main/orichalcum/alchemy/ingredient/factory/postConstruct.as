package orichalcum.alchemy.ingredient.factory 
{
	import orichalcum.alchemy.ingredient.PostConstruct;

	public function postConstruct(name:String):PostConstruct
	{
		return new PostConstruct(name);
	}

}