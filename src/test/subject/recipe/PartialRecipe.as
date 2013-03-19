package subject.recipe 
{
	import orichalcum.alchemy.binding.Binding;
	import orichalcum.alchemy.recipe.Recipe;

	public class PartialRecipe extends Recipe
	{
		
		public function PartialRecipe() 
		{
			constructorArguments = [3, 4];
			properties = { a:'A', b:'B' };
			bindings = [new Binding('b')];
			composer = 'INIT';
			disposer = 'DISPOSE';
		}
		
	}

}
