package orichalcum.alchemy.recipe.ingredient 
{

	public class PreDestroy 
	{
		private var _name:String;
		
		public function PreDestroy(name:String) 
		{
			//Assert.notNull(name, "")
			_name = name;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
	}

}