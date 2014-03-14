package orichalcum.alchemy.recipe.ingredient 
{
	import orichalcum.signals.ISignal;

	public class SignalHandler 
	{
		
		private var _signal:ISignal;
		private var _slot:Function;
		private var _signalPath:String;
		private var _slotPath:String;
		
		public function SignalHandler(options:Object = null) 
		{
			if (options)
			{
				if ('signal' in options) this.signalPath = options.signal;
				if ('slot' in options) this.slotPath = options.slot;
			}
		}
		
		public function get isBound():Boolean
		{
			return _signal && _signal.has(_slot);
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
		
		public function bind():void
		{
			_signal.add(_slot);
		}
		
		public function unbind():void
		{
			_signal.remove(_slot);
			_signal = null;
			_slot = null;
		}
		
	}

}