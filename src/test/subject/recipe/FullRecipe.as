package subject.recipe 
{
	import orichalcum.alchemy.binding.Binding;
	import orichalcum.alchemy.recipe.Recipe;

	public class FullRecipe extends Recipe
	{
		
		public function FullRecipe() 
		{
			constructorArguments = [0, 1, 2];
			properties = { a:'a', b:'b', c:'c' };
			bindings = [new Binding('a')];
			composer = 'init';
			disposer = 'dispose';
		}
		
	}

}
