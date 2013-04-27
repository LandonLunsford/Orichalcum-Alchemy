package orichalcum.alchemy.language 
{
	import orichalcum.alchemy.language.metatag.EventHandlerMetatag;
	import orichalcum.alchemy.language.metatag.IEventHandlerMetatag;
	import orichalcum.alchemy.language.metatag.IInjectionMetatag;
	import orichalcum.alchemy.language.metatag.InjectionMetatag;
	import orichalcum.alchemy.language.metatag.IPostConstructMetatag;
	import orichalcum.alchemy.language.metatag.IPreDestroyMetatag;
	import orichalcum.alchemy.language.metatag.PostConstructMetatag;
	import orichalcum.alchemy.language.metatag.PreDestroyMetatag;
	
	public class MetatagLanguage implements IMetatagLanguage
	{
		private var _injectionMetatag:IInjectionMetatag;
		private var _postConstructMetatag:IPostConstructMetatag;
		private var _preDestroyMetatag:IPreDestroyMetatag;
		private var _eventHandlerMetatag:IEventHandlerMetatag;
		
		public function MetatagLanguage() 
		{
			_injectionMetatag = new InjectionMetatag;
			_postConstructMetatag = new PostConstructMetatag;
			_preDestroyMetatag = new PreDestroyMetatag;
			_eventHandlerMetatag = new EventHandlerMetatag;
		}
		
		/* INTERFACE orichalcum.alchemy.language.metatag.IMetatagLanguage */
		
		public function get eventHandlerMetatag():IEventHandlerMetatag 
		{
			return _eventHandlerMetatag;
		}
		
		public function get injectionMetatag():IInjectionMetatag 
		{
			return _injectionMetatag;
		}
		
		public function get postConstructMetatag():IPostConstructMetatag 
		{
			return _postConstructMetatag;
		}
		
		public function get preDestroyMetatag():IPreDestroyMetatag 
		{
			return _preDestroyMetatag;
		}
		
	}

}