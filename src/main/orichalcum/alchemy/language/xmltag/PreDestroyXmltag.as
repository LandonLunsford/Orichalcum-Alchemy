package orichalcum.alchemy.language.xmltag 
{
	
	public class PreDestroyXmltag implements IPreDestroyXmltag
	{
		private var _name:String;
		private var _argument:String;
		
		public function PreDestroyXmltag(name:String = 'pre-destroy', argument:String = 'name') 
		{
			_name = name;
			_argument = argument;
		}
		
		/* INTERFACE orichalcum.alchemy.language.xmltag.IPreDestroyXmltag */
		
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