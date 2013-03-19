package orichalcum.alchemy.recipe 
{
	import org.flexunit.asserts.assertFalse;

	public class EmptyRecipeTest 
	{
		private var _emptyRecipe:Recipe;
		
		[Before]
		public function setup():void
		{
			_emptyRecipe = new Recipe;
		}
		
		[After]
		public function teardown():void
		{
			_emptyRecipe = null;
		}
		
		[Test]
		public function testHasConstructorArguments():void
		{
			assertFalse(_emptyRecipe.hasConstructorArguments);
		}
		
		[Test]
		public function testHasProperties():void
		{
			assertFalse(_emptyRecipe.hasProperties);
		}
		
		[Test]
		public function testHasBindings():void
		{
			assertFalse(_emptyRecipe.hasBindings);
		}
		
		[Test]
		public function testHasComposer():void
		{
			assertFalse(_emptyRecipe.hasComposer);
		}
		
		[Test]
		public function testHasDisposer():void
		{
			assertFalse(_emptyRecipe.hasDisposer);
		}
		
		[Test]
		public function testCloneHas():void
		{
			const clone:Recipe = _emptyRecipe.clone();
			assertFalse(clone.hasConstructorArguments);
			assertFalse(clone.hasProperties);
			assertFalse(clone.hasBindings);
			assertFalse(clone.hasComposer);
			assertFalse(clone.hasDisposer);
		}
		
		[Test]
		public function testExtensionHas():void
		{
			const extension:Recipe = _emptyRecipe.extend(_emptyRecipe.clone());
			assertFalse(extension.hasConstructorArguments);
			assertFalse(extension.hasProperties);
			assertFalse(extension.hasBindings);
			assertFalse(extension.hasComposer);
			assertFalse(extension.hasDisposer);
		}
		
		[Test]
		public function testEmptyHas():void
		{
			const empty:Recipe = _emptyRecipe.empty();
			assertFalse(empty.hasConstructorArguments);
			assertFalse(empty.hasProperties);
			assertFalse(empty.hasBindings);
			assertFalse(empty.hasComposer);
			assertFalse(empty.hasDisposer);
		}

	}

}
