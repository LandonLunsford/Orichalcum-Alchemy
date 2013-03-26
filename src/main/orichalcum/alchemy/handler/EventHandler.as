package orichalcum.alchemy.handler 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.utility.ObjectUtil;
	import orichalcum.utility.StringUtil;

	public class EventHandler implements IEventHandler, IDisposable
	{
		static private var _delegateArguments:Array = [];
		
		/* Set at "activation-time" */
		private var _listener:Function;
		
		/* Set at "creation-time" */
		private var _type:String;
		private var _listenerName:String;
		private var _targetPath:String;
		private var _priority:int;
		private var _useCapture:Boolean;
		private var _parameters:Array;
		private var _stopPropagation:Boolean;
		private var _stopImmediatePropagation:Boolean;
		
		public function EventHandler(
			type:String = null
			,listenerName:String = null
			,target:String = null
			,priority:int = 0
			,useCapture:Boolean = false
			,stopPrpagation:Boolean = false
			,stopImmediatePropagation:Boolean = false)
		{
			_type = type;
			_listenerName = listenerName;
			_targetPath = target;
			_priority = priority;
			_useCapture = useCapture;
			_stopPropagation = stopPropagation;
			_stopImmediatePropagation = stopImmediatePropagation;
		}
		
		/* INTERFACE orichalcum.provizor.arm.IDisposable */
		
		public function dispose():void 
		{
			_targetPath = null;
			_type = null;
			_listener = null;
			_listenerName = null;
			_parameters = null;
		}
		
		/* INTERNALS */
		
		public function get targetPath():String
		{
			return _targetPath;
		}
		
		public function set targetPath(value:String):void
		{
			_targetPath = value;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		public function get listener():Function 
		{
			return _listener;
		}
		
		public function set listener(value:Function):void 
		{
			_listener = value;
		}
		
		public function get listenerName():String 
		{
			return _listenerName;
		}
		
		public function set listenerName(value:String):void 
		{
			_listenerName = value;
		}
		
		public function get useCapture():Boolean 
		{
			return _useCapture;
		}
		
		public function set useCapture(value:Boolean):void 
		{
			_useCapture = value;
		}
		
		public function get priority():int 
		{
			return _priority;
		}
		
		public function set priority(value:int):void 
		{
			_priority = value;
		}
		
		public function get stopPropagation():Boolean 
		{
			return _stopPropagation;
		}
		
		public function set stopPropagation(value:Boolean):void 
		{
			_stopPropagation = value;
		}
		
		public function get stopImmediatePropagation():Boolean 
		{
			return _stopImmediatePropagation;
		}
		
		public function set stopImmediatePropagation(value:Boolean):void 
		{
			_stopImmediatePropagation = value;
		}
		
		public function get parameters():Array
		{
			return _parameters;
		}
		
		public function set parameters(value:Array):void 
		{
			_parameters = value;
		}
		
		public function toString():String
		{
			return StringUtil.substitute(
				'<event-handler event="{0}" target="{1}" parameters="{2}" useCapture="{3}" stopPropagation="{4}" stopImmediatePropagation="{5}"/>'
				, type, targetPath, parameters, useCapture, stopPropagation, stopImmediatePropagation);
		}
		
		public function handle(event:Event):void
		{
			if (stopImmediatePropagation)
			{
				event.stopImmediatePropagation();
			}
			else if (stopPropagation)
			{
				event.stopPropagation();
			}
			
			if (listener.length == 0)
			{
				listener();
			}
			else if (listener.length > 0)
			{
				hasParameters
					? listener.apply(null, getArguments(event)) // should not be null, but the listener methods owner
					: listener(event);
			}
		}
		
		/* PRIVATE PARTS */
		
		private function get hasParameters():Boolean
		{
			return _parameters && _parameters.length > 0;
		}
		
		private function getArguments(event:Event):Array
		{
			_delegateArguments.length = 0;
			for each(var eventParameter:String in parameters)
			{
				// for good error messages keep mediator class name
				_delegateArguments.push(event[parameters]);
			}
			return _delegateArguments;
		}
	
	}

}