package orichalcum.alchemy.ingredient 
{
	import orichalcum.signals.ISignal;
	import orichalcum.utility.Strings;

	public class SignalHandler 
	{
		
		private var _signal:ISignal;
		private var _slot:Function;
		
		private var _signalPath:String;
		private var _slotPath:String;
		private var _once:Boolean;
		
		public function SignalHandler(signalPath:String, slotPath:String, once:Boolean = false) 
		{
			//Assert.notNull(signalPath, '');
			//Assert.notNull(slotPath, '');
			_signalPath = signalPath;
			_slotPath = slotPath;
			_once = once;
		}
		
		public function get signal():ISignal 
		{
			return _signal;
		}
		
		public function set signal(value:ISignal):void 
		{
			_signal = value;
		}
		
		public function get slot():Function 
		{
			return _slot;
		}
		
		public function set slot(value:Function):void 
		{
			_slot = value;
		}
		
		public function get signalPath():String 
		{
			return _signalPath;
		}
		
		public function set signalPath(value:String):void 
		{
			_signalPath = value;
		}
		
		public function get slotPath():String 
		{
			return _slotPath;
		}
		
		public function set slotPath(value:String):void 
		{
			_slotPath = value;
		}
		
		public function get once():Boolean
		{
			return _once;
		}
		
		public function set once(value:Boolean):void
		{
			_once = value;
		}
		
		public function get isBound():Boolean
		{
			return _signal && _signal.has(_handle);
		}
		
		public function bind(signal:ISignal, slot:Function):void
		{
			_signal = signal;
			_slot = slot;
			_signal.add(_handle);
		}
		
		public function unbind():void
		{
			_signal.remove(_handle);
			_signal = null;
			_slot = null;
		}
		
		private function _handle(...args):void
		{
			_slot.apply(null, args);
			_once && unbind();
		}
		
		public function toString():String
		{
			return Strings.substitute('{"signal":"{}", "slot":"{}", "once":{}}', signalPath, slotPath, once);
		}
		
	}

}
