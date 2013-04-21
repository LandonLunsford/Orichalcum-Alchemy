package orichalcum.alchemy.language 
{
	import orichalcum.alchemy.language.xmltag.IConstructorArgumentXmltag;
	import orichalcum.alchemy.language.xmltag.IEventHandlerXmltag;
	import orichalcum.alchemy.language.xmltag.IMapXmltag;
	import orichalcum.alchemy.language.xmltag.IPostConstructXmltag;
	import orichalcum.alchemy.language.xmltag.IPreDestroyXmltag;
	import orichalcum.alchemy.language.xmltag.IPropertyXmltag;

	public interface IXmltagLanguage 
	{
		function get mapXmltag():IMapXmltag;
		function get constructorArgumentXmltag():IConstructorArgumentXmltag;
		function get propertyXmltag():IPropertyXmltag;
		function get eventHandlerXmltag():IEventHandlerXmltag;
		function get postConstructXmltag():IPostConstructXmltag;
		function get preDestroyXmltag():IPreDestroyXmltag;
	}

}