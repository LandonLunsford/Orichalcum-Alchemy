package orichalcum.alchemy.recipe 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import orichalcum.alchemy.handler.EventHandler;

	public class CompoundRecipeTest 
	{
		private var _fullRecipe:Recipe;
		private var _halfRecipe:Recipe;
		private var _fullExtendsHalf:Recipe;
		
		[Before]
		public function setup():void
		{
			_fullRecipe = new Recipe;
			_fullRecipe.constructorArguments = [0, 1, 2, 3];
			_fullRecipe.properties = { a:'a', b:'b' };
			_fullRecipe.eventHandlers = [new EventHandler('a'), new EventHandler('b')];
			_fullRecipe.postConstruct = 'init';
			_fullRecipe.preDestroy = 'dispose';
			
			_halfRecipe = new Recipe;
			_halfRecipe.constructorArguments = [0, 1];
			_halfRecipe.properties = { a:'A' };
			_halfRecipe.eventHandlers = [new EventHandler('a')];
			_halfRecipe.postConstruct = 'INIT';
			_halfRecipe.preDestroy = 'DISPOSE';
			
			_fullExtendsHalf = new Recipe;
			_fullExtendsHalf.constructorArguments = [
				_halfRecipe.constructorArguments[0]
				,_halfRecipe.constructorArguments[1]
				,_fullRecipe.constructorArguments[2]
				,_fullRecipe.constructorArguments[3]
			];
			_fullExtendsHalf.properties = { a:'A', b:'b' };
			_fullExtendsHalf.eventHandlers = _fullRecipe.eventHandlers.concat(_halfRecipe.eventHandlers);
			_fullExtendsHalf.postConstruct = _halfRecipe.postConstruct;
			_fullExtendsHalf.preDestroy = _halfRecipe.preDestroy;
		}
		
		[Test]
		public function testSelfExtension():void
		{
			const extension:Recipe = _fullRecipe.clone().extend(_fullRecipe.clone());
			assertThat(extension.constructorArguments, equalTo(_fullRecipe.constructorArguments));
			assertThat(extension.properties, hasProperties(_fullRecipe.properties));
			assertThat(extension.eventHandlers, equalTo(_fullRecipe.eventHandlers.concat(_fullRecipe.eventHandlers)));
			assertThat(extension.postConstruct, equalTo(_fullRecipe.postConstruct));
			assertThat(extension.preDestroy, equalTo(_fullRecipe.preDestroy));
		}
		
		[Test]
		public function testFullExtendsHalf():void
		{
			const extension:Recipe = _fullRecipe.clone().extend(_halfRecipe.clone());
			assertThat(extension.constructorArguments, equalTo(_fullExtendsHalf.constructorArguments));
			assertThat(extension.properties, hasProperties(_fullExtendsHalf.properties));
			assertThat(extension.eventHandlers, equalTo(_fullExtendsHalf.eventHandlers));
			assertThat(extension.postConstruct, equalTo(_fullExtendsHalf.postConstruct));
			assertThat(extension.preDestroy, equalTo(_fullExtendsHalf.preDestroy));
		}
		
		[Test]
		public function testHalfExtendsFull():void
		{
			const extension:Recipe = _halfRecipe.clone().extend(_fullRecipe.clone());
			assertThat(extension.constructorArguments, equalTo(_fullRecipe.constructorArguments));
			assertThat(extension.properties, hasProperties(_fullRecipe.properties));
			assertThat(extension.eventHandlers, equalTo(_halfRecipe.eventHandlers.concat(_fullRecipe.eventHandlers)));
			assertThat(extension.postConstruct, equalTo(_fullRecipe.postConstruct));
			assertThat(extension.preDestroy, equalTo(_fullRecipe.preDestroy));
		}
	}

}