package orichalcum.alchemy.language.metatag 
{

	public class PostConstructMetatag 
	{
		private var _name:String;
		
		public function PostConstructMetatag(name:String = 'PostConstruct') 
		{
			_name = name;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
	}

}
