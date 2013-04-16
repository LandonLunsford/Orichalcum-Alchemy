package orichalcum.alchemy.configuration.xml.tag
{

	public class ConstructorArgumentXmltag
	{
		private var _name:String;
		private var _valueAttributeName:String;
		
		public function ConstructorArgumentXmltag(name:String, valueAttributeName:String)
		{
			_name = name;
			_valueAttributeName = valueAttributeName;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get valueAttributeName():String
		{
			return _valueAttributeName;
		}
		
	}

}
