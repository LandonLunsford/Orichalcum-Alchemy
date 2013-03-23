package orichalcum.alchemy.recipe 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.object.isFalse;
	import orichalcum.alchemy.handler.EventHandler;

	public class FullRecipeTest 
	{
		private var _fullRecipe:Recipe;
		
		[Before]
		public function setup():void
		{
			_fullRecipe = new Recipe;
			_fullRecipe.constructorArguments = [0, 1, 2];
			_fullRecipe.properties = { a:'a', b:'b', c:'c' };
			_fullRecipe.eventHandlers = [new EventHandler('a')];
			_fullRecipe.postConstruct = 'init';
			_fullRecipe.preDestroy = 'dispose';
		}
		
		[Test]
		public function testHasConstructorArguments():void
		{
			assertThat(_fullRecipe.hasConstructorArguments);
		}
		
		[Test]
		public function testHasProperties():void
		{
			assertThat(_fullRecipe.hasProperties);
		}
		
		[Test]
		public function testHasBindings():void
		{
			assertThat(_fullRecipe.hasEventHandlers);
		}
		
		[Test]
		public function testHasComposer():void
		{
			assertThat(_fullRecipe.hasComposer);
		}
		
		[Test]
		public function testHasDisposer():void
		{
			assertThat(_fullRecipe.hasDisposer);
		}
		
		[Test]
		public function testCloneHas():void
		{
			const clone:Recipe = _fullRecipe.clone();
			assertThat(clone.hasConstructorArguments);
			assertThat(clone.hasProperties);
			assertThat(clone.hasEventHandlers);
			assertThat(clone.hasComposer);
			assertThat(clone.hasDisposer);
		}
		
		[Test]
		public function testExtensionHas():void
		{
			const extension:Recipe = _fullRecipe.extend(_fullRecipe.clone());
			assertThat(extension.hasConstructorArguments);
			assertThat(extension.hasProperties);
			assertThat(extension.hasEventHandlers);
			assertThat(extension.hasComposer);
			assertThat(extension.hasDisposer);
		}
		
		[Test]
		public function testEmptyHas():void
		{
			const empty:Recipe = _fullRecipe.empty();
			assertThat(empty.hasConstructorArguments, isFalse());
			assertThat(empty.hasProperties, isFalse());
			assertThat(empty.hasEventHandlers, isFalse());
			assertThat(empty.hasComposer, isFalse());
			assertThat(empty.hasDisposer, isFalse());
		}
		
		[Test]
		public function testClone():void
		{
			const clone:Recipe = _fullRecipe.clone();
			assertThat(clone.constructorArguments, equalTo(_fullRecipe.constructorArguments));
			assertThat(clone.properties, hasProperties(_fullRecipe.properties));
			assertThat(clone.eventHandlers, equalTo(_fullRecipe.eventHandlers));
			assertThat(clone.postConstruct, equalTo(_fullRecipe.postConstruct));
			assertThat(clone.preDestroy, equalTo(_fullRecipe.preDestroy));
		}
		
		[Test]
		public function testExtendEmpty():void
		{
			var extension:Recipe = _fullRecipe.extend(new Recipe);
			assertThat(extension.constructorArguments, equalTo(_fullRecipe.constructorArguments));
			assertThat(extension.properties, hasProperties(_fullRecipe.properties));
			assertThat(extension.eventHandlers, equalTo(_fullRecipe.eventHandlers));
			assertThat(extension.postConstruct, equalTo(_fullRecipe.postConstruct));
			assertThat(extension.preDestroy, equalTo(_fullRecipe.preDestroy));
		}
		
		[Test]
		public function testExtendFull():void
		{
			var extension:Recipe = (new Recipe).extend(_fullRecipe);
			assertThat(extension.constructorArguments, equalTo(_fullRecipe.constructorArguments));
			assertThat(extension.properties, hasProperties(_fullRecipe.properties));
			assertThat(extension.eventHandlers, equalTo(_fullRecipe.eventHandlers));
			assertThat(extension.postConstruct, equalTo(_fullRecipe.postConstruct));
			assertThat(extension.preDestroy, equalTo(_fullRecipe.preDestroy));
		}

	}

}
