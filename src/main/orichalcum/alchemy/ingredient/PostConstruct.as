package orichalcum.alchemy.ingredient 
{

	public class PostConstruct 
	{
		private var _name:String;
		
		public function PostConstruct(name:String) 
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