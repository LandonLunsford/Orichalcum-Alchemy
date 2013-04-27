package orichalcum.alchemy.language 
{
	import orichalcum.alchemy.language.metatag.EventHandlerMetatag;
	import orichalcum.alchemy.language.metatag.InjectionMetatag;
	import orichalcum.alchemy.language.metatag.PostConstructMetatag;
	import orichalcum.alchemy.language.metatag.PreDestroyMetatag;
	
	public class MetatagLanguage 
	{
		private var _injectionMetatag:InjectionMetatag;
		private var _postConstructMetatag:PostConstructMetatag;
		private var _preDestroyMetatag:PreDestroyMetatag;
		private var _eventHandlerMetatag:EventHandlerMetatag;
		
		public function MetatagLanguage() 
		{
			_injectionMetatag = new InjectionMetatag;
			_postConstructMetatag = new PostConstructMetatag;
			_preDestroyMetatag = new PreDestroyMetatag;
			_eventHandlerMetatag = new EventHandlerMetatag;
		}
		
		public function get eventHandlerMetatag():EventHandlerMetatag 
		{
			return _eventHandlerMetatag;
		}
		
		public function get injectionMetatag():InjectionMetatag 
		{
			return _injectionMetatag;
		}
		
		public function get postConstructMetatag():PostConstructMetatag 
		{
			return _postConstructMetatag;
		}
		
		public function get preDestroyMetatag():PreDestroyMetatag 
		{
			return _preDestroyMetatag;
		}
		
	}

}