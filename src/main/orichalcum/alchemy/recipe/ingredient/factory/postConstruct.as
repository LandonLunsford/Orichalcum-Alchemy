package orichalcum.alchemy.recipe.ingredient.factory 
{
	import orichalcum.alchemy.recipe.ingredient.PostConstruct;

	public function postConstruct(name:String):PostConstruct
	{
		return new PostConstruct(name);
	}

}