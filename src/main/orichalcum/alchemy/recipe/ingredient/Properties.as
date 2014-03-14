package orichalcum.alchemy.recipe.ingredient 
{

	public class Properties 
	{
		
		private var _nameValuePairs:Object;
		
		public function Properties(nameValuePairs:Object) 
		{
			
			// Assert.notNull(nameValuePairs, "blah")
			_nameValuePairs = nameValuePairs;
		}
		
		public function get nameValuePairs():Object 
		{
			return _nameValuePairs;
		}
		
		
	}

}