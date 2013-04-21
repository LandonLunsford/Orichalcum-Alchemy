package orichalcum.alchemy.language.xmltag 
{
	
	public class PropertyXmltag implements IPropertyXmltag
	{
		private var _name:String;
		
		public function PropertyXmltag(name:String = 'property') 
		{
			_name = name;
		}
		
		/* INTERFACE orichalcum.alchemy.language.xmltag.IPropertyXmltag */
		
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