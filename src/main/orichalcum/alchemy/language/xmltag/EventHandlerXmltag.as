package orichalcum.alchemy.language.xmltag 
{

	public class EventHandlerXmltag
	{
		private var _name:String;
		private var _priority:String;
		private var _useCapture:String;
		private var _stopPropagation:String;
		private var _stopImmediatePropagation:String;
		
		public function EventHandlerXmltag(name:String = 'event-handler', priority:String = 'priority', useCapture:String = 'useCapture', stopPropagation:String = 'stopPropagation', stopImmediatePropagation:String = 'stopImmediatePropagation') 
		{
			_name = name;
			_priority = priority;
			_useCapture = useCapture;
			_stopPropagation = stopPropagation;
			_stopImmediatePropagation = stopImmediatePropagation;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get priority():String 
		{
			return _priority;
		}
		
		public function set priority(value:String):void 
		{
			_priority = value;
		}
		
		public function get useCapture():String 
		{
			return _useCapture;
		}
		
		public function set useCapture(value:String):void 
		{
			_useCapture = value;
		}
		
		public function get stopPropagation():String 
		{
			return _stopPropagation;
		}
		
		public function set stopPropagation(value:String):void 
		{
			_stopPropagation = value;
		}
		
		public function get stopImmediatePropagation():String 
		{
			return _stopImmediatePropagation;
		}
		
		public function set stopImmediatePropagation(value:String):void 
		{
			_stopImmediatePropagation = value;
		}
		
	}

}