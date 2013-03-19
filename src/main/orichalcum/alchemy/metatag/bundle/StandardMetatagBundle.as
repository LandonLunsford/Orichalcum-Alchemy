package orichalcum.alchemy.metatag.bundle 
{
	import orichalcum.alchemy.metatag.EventHandlerMetatag;
	import orichalcum.alchemy.metatag.IEventHandlerMetatag;
	import orichalcum.alchemy.metatag.IInjectionMetatag;
	import orichalcum.alchemy.metatag.InjectionMetatag;
	import orichalcum.alchemy.metatag.IPostConstructMetatag;
	import orichalcum.alchemy.metatag.IPreDestroyMetatag;
	import orichalcum.alchemy.metatag.PostConstructMetatag;
	import orichalcum.alchemy.metatag.PreDestroyMetatag;

	public class StandardMetatagBundle implements IMetatagBundle
	{
		private var _injectionMetatag:IInjectionMetatag;
		private var _postConstructMetatag:IPostConstructMetatag;
		private var _preDestroyMetatag:IPreDestroyMetatag;
		private var _eventHandlerMetatag:IEventHandlerMetatag;
		
		public function StandardMetatagBundle() 
		{
			_injectionMetatag = new InjectionMetatag('Inject');
			_postConstructMetatag = new PostConstructMetatag('PostConstruct');
			_preDestroyMetatag = new PreDestroyMetatag('PreDestroy');
			_eventHandlerMetatag = new EventHandlerMetatag('EventHandler','event','target','parameters','priority','useCapture','stopPropagation','stopImmediatePropagation');
		}
		
		/* INTERFACE orichalcum.alchemy.metatag.bundle.IMetatagBundle */
		
		public function get injectionMetatag():IInjectionMetatag 
		{
			return _injectionMetatag;
		}
		
		public function set injectionMetatag(value:IInjectionMetatag):void 
		{
			_injectionMetatag = value;
		}
		
		public function get postConstructMetatag():IPostConstructMetatag 
		{
			return _postConstructMetatag;
		}
		
		public function set postConstructMetatag(value:IPostConstructMetatag):void 
		{
			_postConstructMetatag = value;
		}
		
		public function get preDestroyMetatag():IPreDestroyMetatag 
		{
			return _preDestroyMetatag;
		}
		
		public function set preDestroyMetatag(value:IPreDestroyMetatag):void 
		{
			_preDestroyMetatag = value;
		}
		
		public function get eventHandlerMetatag():IEventHandlerMetatag 
		{
			return _eventHandlerMetatag;
		}
		
		public function set eventHandlerMetatag(value:IEventHandlerMetatag):void 
		{
			_eventHandlerMetatag = value;
		}
		
	}

}
