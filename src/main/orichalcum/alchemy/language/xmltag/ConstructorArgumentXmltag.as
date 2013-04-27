package orichalcum.alchemy.language.xmltag 
{

	public class ConstructorArgumentXmltag 
	{
		private var _name:String;
		private var _argument:String;
		
		public function ConstructorArgumentXmltag(name:String = 'constructor-argument', argument:String = 'value') 
		{
			_name = name;
			_argument = argument;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get argument():String 
		{
			return _argument;
		}
		
		public function set argument(value:String):void 
		{
			_argument = value;
		}
		
	}

}