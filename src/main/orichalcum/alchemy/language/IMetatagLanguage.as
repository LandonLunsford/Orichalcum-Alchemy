package orichalcum.alchemy.language 
{
	import orichalcum.alchemy.language.metatag.IEventHandlerMetatag;
	import orichalcum.alchemy.language.metatag.IInjectionMetatag;
	import orichalcum.alchemy.language.metatag.IPostConstructMetatag;
	import orichalcum.alchemy.language.metatag.IPreDestroyMetatag;
	
	public interface IMetatagLanguage 
	{
		function get eventHandlerMetatag():IEventHandlerMetatag;
		function get injectionMetatag():IInjectionMetatag;
		function get postConstructMetatag():IPostConstructMetatag;
		function get preDestroyMetatag():IPreDestroyMetatag;
	}

}