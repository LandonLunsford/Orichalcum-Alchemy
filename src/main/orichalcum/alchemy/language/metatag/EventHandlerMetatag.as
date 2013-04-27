package orichalcum.alchemy.language.metatag 
{
	
	public class EventHandlerMetatag implements IEventHandlerMetatag
	{
		private var _name:String;
		private var _eventKey:String;
		private var _targetKey:String;
		private var _parametersKey:String;
		private var _priorityKey:String;
		private var _useCaptureKey:String;
		private var _stopPropagationKey:String;
		private var _stopImmediatePropagationKey:String;
		
		public function EventHandlerMetatag(
			name:String = 'EventHandler'
			,eventKey:String = 'event'
			,targetKey:String = 'target'
			,parametersKey:String = 'parameters'
			,priorityKey:String = 'priority'
			,useCaptureKey:String = 'useCapture'
			,stopPropagationKey:String = 'stopPropagation'
			,stopImmediatePropagationKey:String = 'stopImmediatePropagation')
		{
			_name = name;
			_eventKey = eventKey;
			_targetKey = targetKey;
			_parametersKey = parametersKey;
			_priorityKey = priorityKey;
			_useCaptureKey = useCaptureKey;
			_stopPropagationKey = stopPropagationKey;
			_stopImmediatePropagationKey = stopImmediatePropagationKey;
		}
		
		/* INTERFACE orichalcum.alchemy.metatag.IEventHandlerMetatag */
		
		public function get name():String
		{
			return _name;
		}
		
		public function get eventKey():String 
		{
			return _eventKey;
		}
		
		public function get targetKey():String 
		{
			return _targetKey;
		}
		
		public function get parametersKey():String 
		{
			return _parametersKey;
		}
		
		public function get priorityKey():String 
		{
			return _priorityKey;
		}
		
		public function get useCaptureKey():String 
		{
			return _useCaptureKey;
		}
		
		public function get stopPropagationKey():String 
		{
			return _stopPropagationKey;
		}
		
		public function get stopImmediatePropagationKey():String 
		{
			return _stopImmediatePropagationKey;
		}
	}

}