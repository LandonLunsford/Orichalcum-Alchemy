package orichalcum.alchemy.alchemist 
{
	import flash.events.Event;
	import org.hamcrest.assertThat;
	import subject.ClassWithEventHandlerMetatags;
	import subject.ClassWithEventlessEventHandlerMetatag;
	import subject.ClassWithInvalidEventHandlerTarget;
	import subject.ClassWithInvalidEventHandlerTargetPath;

	public class EventHandlerTest 
	{
		
		private var _alchemist:Alchemist;
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
		}
		
		[Test(expects = "Error")]
		public function testEventHandlerWithNoEvent():void
		{
			_alchemist.create(ClassWithEventlessEventHandlerMetatag);
		}
		
		[Test(expects = "Error")]
		public function testNonEventDispatcherEventHandlerTarget():void
		{
			_alchemist.create(ClassWithInvalidEventHandlerTarget);
		}
		
		[Test(expects = "Error")]
		public function testInvalidEventHandlerTargetPath():void
		{
			_alchemist.create(ClassWithInvalidEventHandlerTargetPath);
		}
		
		[Test]
		public function testEventHandlerWithNoTarget():void
		{
			const creation:ClassWithEventHandlerMetatags = _alchemist.create(ClassWithEventHandlerMetatags) as ClassWithEventHandlerMetatags;
			assertThat(creation.hasEventListener(Event.COMPLETE));
		}
		
	}

}