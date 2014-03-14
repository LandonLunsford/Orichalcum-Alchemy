package orichalcum.alchemy.recipe.ingredient 
{

	public class Property 
	{
		
		private var _name:String;
		private var _value:*;
		
		public function Property(name:String, value:*) 
		{
			
			// Assert.notNull(name, "blah")
			_name = name;
			_value = value;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get value():* 
		{
			return _value;
		}
		
	}

}