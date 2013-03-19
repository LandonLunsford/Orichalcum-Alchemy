package orichalcum.alchemy.metatag.bundle 
{
	import orichalcum.alchemy.metatag.IEventHandlerMetatag;
	import orichalcum.alchemy.metatag.IInjectionMetatag;
	import orichalcum.alchemy.metatag.IPostConstructMetatag;
	import orichalcum.alchemy.metatag.IPreDestroyMetatag;

	public interface IMetatagBundle
	{
		function get eventHandlerMetatag():IEventHandlerMetatag;
		function set eventHandlerMetatag(value:IEventHandlerMetatag):void;
		
		function get injectionMetatag():IInjectionMetatag;
		function set injectionMetatag(value:IInjectionMetatag):void;
		
		function get postConstructMetatag():IPostConstructMetatag;
		function set postConstructMetatag(value:IPostConstructMetatag):void;
		
		function get preDestroyMetatag():IPreDestroyMetatag;
		function set preDestroyMetatag(value:IPreDestroyMetatag):void;
	}

}
