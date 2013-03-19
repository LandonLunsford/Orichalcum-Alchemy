package orichalcum.alchemy.recipe 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.isFalse;

	public class EmptyRecipeTest 
	{
		private var _emptyRecipe:Recipe;
		
		[Before]
		public function setup():void
		{
			_emptyRecipe = new Recipe;
		}
		
		[Test]
		public function testHasConstructorArguments():void
		{
			assertThat(_emptyRecipe.hasConstructorArguments, isFalse());
		}
		
		[Test]
		public function testHasProperties():void
		{
			assertThat(_emptyRecipe.hasProperties, isFalse());
		}
		
		[Test]
		public function testHasBindings():void
		{
			assertThat(_emptyRecipe.hasBindings, isFalse());
		}
		
		[Test]
		public function testHasComposer():void
		{
			assertThat(_emptyRecipe.hasComposer, isFalse());
		}
		
		[Test]
		public function testHasDisposer():void
		{
			assertThat(_emptyRecipe.hasDisposer, isFalse());
		}
		
		[Test]
		public function testCloneHas():void
		{
			const clone:Recipe = _emptyRecipe.clone();
			assertThat(clone.hasConstructorArguments, isFalse());
			assertThat(clone.hasProperties, isFalse());
			assertThat(clone.hasBindings, isFalse());
			assertThat(clone.hasComposer, isFalse());
			assertThat(clone.hasDisposer, isFalse());
		}
		
		[Test]
		public function testExtensionHas():void
		{
			const extension:Recipe = _emptyRecipe.extend(_emptyRecipe.clone());
			assertThat(extension.hasConstructorArguments, isFalse());
			assertThat(extension.hasProperties, isFalse());
			assertThat(extension.hasBindings, isFalse());
			assertThat(extension.hasComposer, isFalse());
			assertThat(extension.hasDisposer, isFalse());
		}
		
		[Test]
		public function testEmptyHas():void
		{
			const empty:Recipe = _emptyRecipe.empty();
			assertThat(empty.hasConstructorArguments, isFalse());
			assertThat(empty.hasProperties, isFalse());
			assertThat(empty.hasBindings, isFalse());
			assertThat(empty.hasComposer, isFalse());
			assertThat(empty.hasDisposer, isFalse());
		}
	}

}
