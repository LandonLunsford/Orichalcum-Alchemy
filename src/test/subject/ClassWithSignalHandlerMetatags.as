package subject
{
	import orichalcum.signals.Signal;

	public class ClassWithSignalHandlerMetatags 
	{
		
		
		public var target:Object = {
			signal: new Signal,
			threeArgumentSignal: new Signal(Number, String, Array),
			oneShot: new Signal
		};
		
		// will throw error
		//[SignalHandler]
		//public function shouldThrowError():void {}
		
		[SignalHandler]
		public function target_signal():void
		{
			
		}
		
		[SignalHandler]
		public function target_threeArgumentSignal(array:Array, number:Number, string:String):void
		{
			array.push(number, string);
		}
		
		[SignalHandler(signal="target.signal")]
		public function explicitelyPathedSignalHandler():void
		{
			
		}
		
		[SignalHandler(once)]
		public function target_oneShot():void
		{
			
		}
		
	}

}