package orichalcum.alchemy.provider 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.Recipe;

	public interface IProvider 
	{
		function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):*;
	}

}