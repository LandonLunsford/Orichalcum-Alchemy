package 
{
	import flash.display.Sprite;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;
	import orichalcum.alchemy.alchemist.AlchemistTest;
	import orichalcum.alchemy.alchemist.ConstructorArgumentInjectionTest;
	import orichalcum.alchemy.alchemist.FactoryMappingTest;
	import orichalcum.alchemy.alchemist.MultitonMappingTest;
	import orichalcum.alchemy.alchemist.PostConstructTest;
	import orichalcum.alchemy.alchemist.PreDestroyTest;
	import orichalcum.alchemy.alchemist.PrototypeMappingTest;
	import orichalcum.alchemy.alchemist.ProviderMappingTest;
	import orichalcum.alchemy.alchemist.ReferenceMappingTest;
	import orichalcum.alchemy.alchemist.SetterInjectionTest;
	import orichalcum.alchemy.alchemist.SingletonMappingTest;
	import orichalcum.alchemy.alchemist.ValueMappingTest;
	import orichalcum.alchemy.alchemist.VariableInjectionTest;
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
			core.run(
				AlchemistTest
				,RecipeFactoryTest
				,EmptyRecipeTest
				,FullRecipeTest
				,CompoundRecipeTest
				,ValueMappingTest
				,ReferenceMappingTest
				,SingletonMappingTest
				,PrototypeMappingTest
				,MultitonMappingTest
				,FactoryMappingTest
				,ProviderMappingTest
				,ConstructorArgumentInjectionTest
				,VariableInjectionTest
				,SetterInjectionTest
				,PostConstructTest
				,PreDestroyTest
			);
		}
		
	}

}
