package orichalcum.alchemy.recipe 
{
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.hamcrest.assertThat;
	import orichalcum.alchemy.binding.Binding;
	import orichalcum.alchemy.recipe.factory.error.RecipeFactoryError;
	import subject.recipe.FullRecipe;

	public class FullRecipeTest 
	{
		private var _fullRecipe:Recipe;
		
		[Before]
		public function setup():void
		{
			_fullRecipe = new FullRecipe;
		}
		
		[After]
		public function teardown():void
		{
			_fullRecipe = null;
		}
		
		[Test]
		public function testHasConstructorArguments():void
		{
			assertTrue(_fullRecipe.hasConstructorArguments);
		}
		
		[Test]
		public function testHasProperties():void
		{
			assertTrue(_fullRecipe.hasProperties);
		}
		
		[Test]
		public function testHasBindings():void
		{
			assertTrue(_fullRecipe.hasBindings);
		}
		
		[Test]
		public function testHasComposer():void
		{
			assertTrue(_fullRecipe.hasComposer);
		}
		
		[Test]
		public function testHasDisposer():void
		{
			assertTrue(_fullRecipe.hasDisposer);
		}
		
		[Test]
		public function testCloneHas():void
		{
			const clone:Recipe = _fullRecipe.clone();
			assertTrue(clone.hasConstructorArguments);
			assertTrue(clone.hasProperties);
			assertTrue(clone.hasBindings);
			assertTrue(clone.hasComposer);
			assertTrue(clone.hasDisposer);
		}
		
		[Test]
		public function testExtensionHas():void
		{
			const extension:Recipe = _fullRecipe.extend(_fullRecipe.clone());
			assertTrue(extension.hasConstructorArguments);
			assertTrue(extension.hasProperties);
			assertTrue(extension.hasBindings);
			assertTrue(extension.hasComposer);
			assertTrue(extension.hasDisposer);
		}
		
		[Test]
		public function testEmptyHas():void
		{
			const empty:Recipe = _fullRecipe.empty();
			assertFalse(empty.hasConstructorArguments);
			assertFalse(empty.hasProperties);
			assertFalse(empty.hasBindings);
			assertFalse(empty.hasComposer);
			assertFalse(empty.hasDisposer);
		}
		
		[Test]
		public function testCloneContent():void
		{
			const clone:Recipe = _fullRecipe.clone();
			fail('tests nothing.');
			// need array equals assert
			//assertThat(_fullRecipe.constructorArguments, clone.constructorArguments);
			// need object equals assert
			//assertFalse(clone.hasProperties);
		}
		
		[Test]
		public function testExtensionContent():void
		{
			const extension:Recipe = _fullRecipe.extend(_fullRecipe.clone());
			fail('tests nothing.');
		}
		
		[Test]
		public function testEmptyContent():void
		{
			const empty:Recipe = _fullRecipe.empty();
			fail('tests nothing.');
		}
		
	}

}
