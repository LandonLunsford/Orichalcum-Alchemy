package orichalcum.alchemy.recipe.ingredient 
{

	public class PostConstruct 
	{
		private var _name:String;
		
		public function PostConstruct(name:String) 
		{
			//Assert.notNull(name, "")
			this.name = name;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
	}

}