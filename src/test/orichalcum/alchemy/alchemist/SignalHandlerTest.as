package orichalcum.alchemy.alchemist
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import orichalcum.alchemy.alchemist.Alchemist;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.signals.ISignal;
	import subject.ClassWithSignalHandlerMetatags;

	public class SignalHandlerTest 
	{
		
		private var _alchemist:IAlchemist;
		private var _slotHost:ClassWithSignalHandlerMetatags;
		
		[Before]
		public function before():void
		{
			_alchemist = new Alchemist;
			_slotHost = _alchemist.conjure(ClassWithSignalHandlerMetatags) as ClassWithSignalHandlerMetatags;
		}
		
		[After]
		public function after():void
		{
			_alchemist = null;
		}
		
		[Test]
		public function testAddOnActivate():void
		{
			const signal:ISignal = _slotHost.target.signal;
			assertThat(signal.hasListeners, isTrue());
		}
		
		[Test]
		public function testRemoveOnDeactivate():void
		{
			const signal:ISignal = _slotHost.target.signal;
			assertThat(signal.hasListeners, isTrue());
			_alchemist.destroy(_slotHost);
			assertThat(signal.hasListeners, isFalse());
		}
		
		[Test]
		public function testThreeParameterSignalRecievesArguments():void
		{
			const signal:ISignal = _slotHost.target.threeArgumentSignal;
			const actual:Array = [];
			const expected:Array = [1, 'string'];
			signal.dispatch(actual, expected[0], expected[1]);
			assertThat(actual, equalTo(expected));
		}
		
	}

}