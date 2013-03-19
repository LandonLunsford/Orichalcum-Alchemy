package subject
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	public class ClassWithAllMetatags 
	{
		[Inject]
		public var memberInject:Point;
		public var postConstructCalled:Boolean;
		public var preDestroyCalled:Boolean;
		public var eventHandled:Boolean;
		private var _constructorInject:Point;
		private var _setterInject:Point;
		public var eventDispatcher:IEventDispatcher;
		
		public function ClassWithAllMetatags(constructorInject:Point) 
		{
			this.constructorInject = constructorInject;
			this.eventDispatcher = new EventDispatcher;
		}
		
		public function get setterInject():Point
		{
			return _setterInject;
		}
		
		[Inject]
		public function set setterInject(value:Point):void
		{
			_setterInject = value;
		}
		
		public function get constructorInject():Point 
		{
			return _constructorInject;
		}
		
		public function set constructorInject(value:Point):void 
		{
			_constructorInject = value;
		}
		
		[PostConstruct]
		public function postConstruct():void
		{
			postConstructCalled = true;
		}
		
		[PreDestroy]
		public function preDestroy():void
		{
			preDestroyCalled = true;
		}
		
		[EventHandler(event = "complete", target = "eventDispatcher")]
		public function onComplete():void
		{
			eventHandled = !eventHandled;
		}
		
		public function dispatchEventToToggleEventHandled():void
		{
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}

}