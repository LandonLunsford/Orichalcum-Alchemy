package orichalcum.alchemy.recipe 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import orichalcum.alchemy.binding.Binding;

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
			_fullRecipe.bindings = [new Binding('a'), new Binding('b')];
			_fullRecipe.composer = 'init';
			_fullRecipe.disposer = 'dispose';
			
			_halfRecipe = new Recipe;
			_halfRecipe.constructorArguments = [0, 1];
			_halfRecipe.properties = { a:'A' };
			_halfRecipe.bindings = [new Binding('a')];
			_halfRecipe.composer = 'INIT';
			_halfRecipe.disposer = 'DISPOSE';
			
			_fullExtendsHalf = new Recipe;
			_fullExtendsHalf.constructorArguments = [
				_halfRecipe.constructorArguments[0]
				,_halfRecipe.constructorArguments[1]
				,_fullRecipe.constructorArguments[2]
				,_fullRecipe.constructorArguments[3]
			];
			_fullExtendsHalf.properties = { a:'A', b:'b' };
			_fullExtendsHalf.bindings = _fullRecipe.bindings.concat(_halfRecipe.bindings);
			_fullExtendsHalf.composer = _halfRecipe.composer;
			_fullExtendsHalf.disposer = _halfRecipe.disposer;
		}
		
		[Test]
		public function testSelfExtension():void
		{
			const extension:Recipe = _fullRecipe.clone().extend(_fullRecipe.clone());
			assertThat(extension.constructorArguments, equalTo(_fullRecipe.constructorArguments));
			assertThat(extension.properties, hasProperties(_fullRecipe.properties));
			assertThat(extension.bindings, equalTo(_fullRecipe.bindings.concat(_fullRecipe.bindings)));
			assertThat(extension.composer, equalTo(_fullRecipe.composer));
			assertThat(extension.disposer, equalTo(_fullRecipe.disposer));
		}
		
		[Test]
		public function testFullExtendsHalf():void
		{
			const extension:Recipe = _fullRecipe.clone().extend(_halfRecipe.clone());
			assertThat(extension.constructorArguments, equalTo(_fullExtendsHalf.constructorArguments));
			assertThat(extension.properties, hasProperties(_fullExtendsHalf.properties));
			assertThat(extension.bindings, equalTo(_fullExtendsHalf.bindings));
			assertThat(extension.composer, equalTo(_fullExtendsHalf.composer));
			assertThat(extension.disposer, equalTo(_fullExtendsHalf.disposer));
		}
		
		[Test]
		public function testHalfExtendsFull():void
		{
			const extension:Recipe = _halfRecipe.clone().extend(_fullRecipe.clone());
			assertThat(extension.constructorArguments, equalTo(_fullRecipe.constructorArguments));
			assertThat(extension.properties, hasProperties(_fullRecipe.properties));
			assertThat(extension.bindings, equalTo(_halfRecipe.bindings.concat(_fullRecipe.bindings)));
			assertThat(extension.composer, equalTo(_fullRecipe.composer));
			assertThat(extension.disposer, equalTo(_fullRecipe.disposer));
		}
	}

}