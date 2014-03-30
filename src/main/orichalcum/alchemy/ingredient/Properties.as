package orichalcum.alchemy.ingredient 
{

	public class Properties 
	{
		
		private var _valuesByName:Object;
		
		public function Properties(valuesByName:Object) 
		{
			// Assert.notNull(nameValuePairs, "blah")
			_valuesByName = valuesByName;
		}
		
		public function get valuesByName():Object 
		{
			return _valuesByName;
		}
		
	}

}