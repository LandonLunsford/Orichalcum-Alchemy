package orichalcum.alchemy.language.metatag 
{

	public class InjectionMetatag
	{
		private var _name:String;
		
		public function InjectionMetatag(name:String = 'Inject') 
		{
			_name = name;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
	}

}