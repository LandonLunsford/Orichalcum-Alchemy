package orichalcum.alchemy.alchemist 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import subject.ClassWithEventHandlerMetatags;
	import subject.ClassWithEventlessEventHandlerMetatag;
	import subject.ClassWithInvalidEventHandlerTarget;
	import subject.ClassWithInvalidEventHandlerTargetPath;

	public class EventHandlerTest extends EventDispatcher
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
		
		[Test]
		public function testEventHandlerMemberTarget():void
		{
			const creation:ClassWithEventHandlerMetatags = _alchemist.create(ClassWithEventHandlerMetatags) as ClassWithEventHandlerMetatags;
			assertThat(creation.target.hasEventListener(Event.COMPLETE));
		}
		
		[Test]
		public function testEventHandlerTargetRetrievedWithChildByName():void
		{
			const creation:ClassWithEventHandlerMetatags = _alchemist.create(ClassWithEventHandlerMetatags) as ClassWithEventHandlerMetatags;
			assertThat((creation.root.getChildByName('child') as DisplayObjectContainer).getChildByName('child').hasEventListener(Event.COMPLETE));
		}
		
		[Test]
		public function testEventHandlerUnboundAtDestroy():void
		{
			const creation:ClassWithEventHandlerMetatags = _alchemist.create(ClassWithEventHandlerMetatags) as ClassWithEventHandlerMetatags;
			assertThat(creation.hasEventListener(Event.COMPLETE));
			assertThat(creation.target.hasEventListener(Event.COMPLETE));
			assertThat((creation.root.getChildByName('child') as DisplayObjectContainer).getChildByName('child').hasEventListener(Event.COMPLETE));
			_alchemist.destroy(creation);
			assertThat(creation.hasEventListener(Event.COMPLETE), isFalse());
			assertThat(creation.target.hasEventListener(Event.COMPLETE), isFalse());
			assertThat((creation.root.getChildByName('child') as DisplayObjectContainer).getChildByName('child').hasEventListener(Event.COMPLETE), isFalse());
		}
		
	}

}