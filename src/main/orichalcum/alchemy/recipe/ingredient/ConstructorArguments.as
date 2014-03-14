package orichalcum.alchemy.recipe.ingredient 
{

	public class ConstructorArguments 
	{
		
		private var _values:Array;
		
		public function ConstructorArguments(values:Array) 
		{
			// Assert.notNull(values, "blah")
			_values = values;
		}
		
		public function get values():Object 
		{
			return _values;
		}
		
	}

}