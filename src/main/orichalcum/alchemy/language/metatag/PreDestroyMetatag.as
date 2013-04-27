package orichalcum.alchemy.language.metatag 
{

	public class PreDestroyMetatag
	{
		private var _name:String;
		
		public function PreDestroyMetatag(name:String = 'PreDestroy') 
		{
			_name = name;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
	}

}
