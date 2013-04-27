package orichalcum.alchemy.language 
{
	import orichalcum.alchemy.language.xmltag.ConstructorArgumentXmltag;
	import orichalcum.alchemy.language.xmltag.EventHandlerXmltag;
	import orichalcum.alchemy.language.xmltag.IConstructorArgumentXmltag;
	import orichalcum.alchemy.language.xmltag.IEventHandlerXmltag;
	import orichalcum.alchemy.language.xmltag.IMapXmltag;
	import orichalcum.alchemy.language.xmltag.IPostConstructXmltag;
	import orichalcum.alchemy.language.xmltag.IPreDestroyXmltag;
	import orichalcum.alchemy.language.xmltag.IPropertyXmltag;
	import orichalcum.alchemy.language.xmltag.MapXmltag;
	import orichalcum.alchemy.language.xmltag.PostConstructXmltag;
	import orichalcum.alchemy.language.xmltag.PreDestroyXmltag;
	import orichalcum.alchemy.language.xmltag.PropertyXmltag;
	
	public class XmltagLanguage implements IXmltagLanguage
	{
		private var _mapXmltag:IMapXmltag;
		private var _constructorArgumentXmltag:IConstructorArgumentXmltag;
		private var _propertyXmltag:IPropertyXmltag;
		private var _eventHandlerXmltag:IEventHandlerXmltag;
		private var _postConstructXmltag:IPostConstructXmltag;
		private var _preDestroyXmltag:IPreDestroyXmltag;
		
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
		
		public function get mapXmltag():IMapXmltag 
		{
			return _mapXmltag;
		}
		
		public function get constructorArgumentXmltag():IConstructorArgumentXmltag 
		{
			return _constructorArgumentXmltag;
		}
		
		public function get propertyXmltag():IPropertyXmltag 
		{
			return _propertyXmltag;
		}
		
		public function get eventHandlerXmltag():IEventHandlerXmltag 
		{
			return _eventHandlerXmltag;
		}
		
		public function get postConstructXmltag():IPostConstructXmltag 
		{
			return _postConstructXmltag;
		}
		
		public function get preDestroyXmltag():IPreDestroyXmltag 
		{
			return _preDestroyXmltag;
		}
		
	}

}