package orichalcum.alchemy.language.xmltag 
{
	
	public class PropertyXmltag 
	{
		private var _name:String;
		
		public function PropertyXmltag(name:String = 'property') 
		{
			_name = name;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
	}

}