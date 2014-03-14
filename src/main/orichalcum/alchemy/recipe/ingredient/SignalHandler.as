package orichalcum.alchemy.recipe.ingredient 
{
	import orichalcum.signals.ISignal;

	public class SignalHandler 
	{
		
		private var _signal:ISignal;
		private var _slot:Function;
		
		private var _signalPath:String;
		private var _slotPath:String;
		private var _once:Boolean;
		
		public function SignalHandler(options:Object = null) 
		{
			if (options)
			{
				if ('signal' in options) this.signalPath = options.signal;
				if ('slot' in options) this.slotPath = options.slot;
				if ('once' in options) this.once = options.once;
			}
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
		
		public function bind():void
		{
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
		
	}

}
