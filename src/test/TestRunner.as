package 
{
	import flash.display.Sprite;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;
	import orichalcum.alchemy.alchemist.AlchemistTest;
	import orichalcum.alchemy.recipe.CompoundRecipeTest;
	import orichalcum.alchemy.recipe.EmptyRecipeTest;
	import orichalcum.alchemy.recipe.factory.RecipeFactoryTest;
	import orichalcum.alchemy.recipe.FullRecipeTest;

	public class TestRunner extends Sprite
	{
		public function TestRunner()
		{
			const core:FlexUnitCore = new FlexUnitCore;
			core.addListener(new TraceListener);
			//core.run(AlchemistTest);
			core.run(
				AlchemistTest
				,RecipeFactoryTest
				,EmptyRecipeTest
				,FullRecipeTest
				,CompoundRecipeTest
			);
		}
		
	}

}