package orichalcum.alchemy.recipe.ingredient 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.utility.Strings;

	public class EventHandler implements IDisposable
	{
		static private var _delegateArguments:Array = [];
		
		/* Set at "activation-time" */
		//private var _hostName:String;
		
		/* Set at "activation-time" */
		private var _listener:Function;
		private var _target:IEventDispatcher;
		private var _relay:IEventDispatcher;
		
		/* Set at "creation-time" */
		private var _type:String;
		private var _listenerName:String;
		private var _targetPath:String;
		private var _relayPath:String;
		private var _priority:int;
		private var _useCapture:Boolean;
		private var _stopPropagation:Boolean;
		private var _stopImmediatePropagation:Boolean;
		private var _parameters:Array;
		
		public function EventHandler(options:Object = null)
		{
			if (options)
			{
				if ('type' in options) _type = options.type;
				if ('listenerName' in options) _listenerName = options.listenerName;
				if ('target' in options) _targetPath = options.target;
				if ('relay' in options) _relayPath = options.relay;
				if ('useCapture' in options) _useCapture = options.useCapture;
				if ('priority' in options) _priority = options.priority;
				if ('stopPropagation' in options) _stopPropagation = options.stopPropagation;
				if ('stopImmediatePropagation' in options) _stopImmediatePropagation = options.stopImmediatePropagation;
				if ('parameters' in options) _parameters = options.parameters;
			}
		}
		
		public function dispose():void 
		{
			_targetPath = null;
			_relayPath = null;
			_type = null;
			_listener = null;
			_listenerName = null;
			_parameters = null;
			_target = null;
			_relay = null;
		}
		
		public function get target():IEventDispatcher 
		{
			return _target;
		}
		
		public function set target(value:IEventDispatcher):void 
		{
			_target = value;
		}
		
		public function get relay():IEventDispatcher 
		{
			return _relay;
		}
		
		public function set relay(value:IEventDispatcher):void 
		{
			_relay = value;
		}
		
		public function get targetPath():String
		{
			return _targetPath;
		}
		
		public function set targetPath(value:String):void
		{
			_targetPath = value;
		}
		
		public function get relayPath():String
		{
			return _relayPath;
		}
		
		public function set relayPath(value:String):void
		{
			_relayPath = value;
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
			return Strings.interpolate(
				'<event-handler event="{}" listener="{}" target="{}" relay="{}" parameters="{}" useCapture="{}" priority="{}" stopPropagation="{}" stopImmediatePropagation="{}"/>'
				, type, listenerName, targetPath, relayPath, parameters, useCapture, priority, stopPropagation, stopImmediatePropagation);
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
			
			relay && relay.dispatchEvent(event);
		}
		
		public function get isBound():Boolean
		{
			return target && target.hasEventListener(type);
		}
		
		public function bind():void
		{
			target.addEventListener(type, handle, useCapture, priority);
		}
		
		public function unbind():void
		{
			target.removeEventListener(type, handle);
					
			/**
			 * Release runtime references
			 */
			target = null;
			relay = null;
			listener = null;
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