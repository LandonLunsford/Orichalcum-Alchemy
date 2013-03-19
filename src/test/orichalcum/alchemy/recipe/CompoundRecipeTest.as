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
		private var _expectedCompoundRecipe:Recipe;
		
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
			
			_expectedCompoundRecipe = new Recipe;
			_expectedCompoundRecipe.constructorArguments = [
				_halfRecipe.constructorArguments[0]
				,_halfRecipe.constructorArguments[1]
				,_fullRecipe.constructorArguments[2]
				,_fullRecipe.constructorArguments[3]
			];
			_expectedCompoundRecipe.properties = { a:'A', b:'b' };
			_expectedCompoundRecipe.bindings = _fullRecipe.bindings.concat(_halfRecipe.bindings);
			_expectedCompoundRecipe.composer = _halfRecipe.composer;
			_expectedCompoundRecipe.disposer = _halfRecipe.disposer;
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
			assertThat(extension.constructorArguments, equalTo(_expectedCompoundRecipe.constructorArguments));
			assertThat(extension.properties, hasProperties(_expectedCompoundRecipe.properties));
			assertThat(extension.bindings, equalTo(_expectedCompoundRecipe.bindings));
			assertThat(extension.composer, equalTo(_expectedCompoundRecipe.composer));
			assertThat(extension.disposer, equalTo(_expectedCompoundRecipe.disposer));
		}
		
	}

}