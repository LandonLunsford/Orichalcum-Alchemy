package orichalcum.alchemy.language 
{
	import orichalcum.alchemy.language.xmltag.ConstructorArgumentXmltag;
	import orichalcum.alchemy.language.xmltag.EventHandlerXmltag;
	import orichalcum.alchemy.language.xmltag.MapXmltag;
	import orichalcum.alchemy.language.xmltag.PostConstructXmltag;
	import orichalcum.alchemy.language.xmltag.PreDestroyXmltag;
	import orichalcum.alchemy.language.xmltag.PropertyXmltag;
	
	public class XmltagLanguage
	{
		private var _mapXmltag:MapXmltag;
		private var _constructorArgumentXmltag:ConstructorArgumentXmltag;
		private var _propertyXmltag:PropertyXmltag;
		private var _eventHandlerXmltag:EventHandlerXmltag;
		private var _postConstructXmltag:PostConstructXmltag;
		private var _preDestroyXmltag:PreDestroyXmltag;
		
		public function XmltagLanguage() 
		{
			_mapXmltag = new MapXmltag;
			_constructorArgumentXmltag = new ConstructorArgumentXmltag;
			_propertyXmltag = new PropertyXmltag;
			_eventHandlerXmltag = new EventHandlerXmltag;
			_postConstructXmltag = new PostConstructXmltag;
			_preDestroyXmltag = new PreDestroyXmltag;
		}
		
		/* INTERFACE orichalcum.alchemy.language.IXmltagLanguage */
		
		public function get mapXmltag():MapXmltag 
		{
			return _mapXmltag;
		}
		
		public function get constructorArgumentXmltag():ConstructorArgumentXmltag 
		{
			return _constructorArgumentXmltag;
		}
		
		public function get propertyXmltag():PropertyXmltag 
		{
			return _propertyXmltag;
		}
		
		public function get eventHandlerXmltag():EventHandlerXmltag 
		{
			return _eventHandlerXmltag;
		}
		
		public function get postConstructXmltag():PostConstructXmltag 
		{
			return _postConstructXmltag;
		}
		
		public function get preDestroyXmltag():PreDestroyXmltag 
		{
			return _preDestroyXmltag;
		}
		
	}

}