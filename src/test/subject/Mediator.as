package subject 
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class Mediator 
	{
		
		[Inject]
		public var view:Sprite;
		
		public function Mediator() 
		{
			
		}
		
		[PostConstruct]
		public function postConstruct():void
		{
			trace('m.view', view);
			trace('view.hasEventListener', view.hasEventListener(Event.COMPLETE));
		}
		
		[EventHandler(event = "addedToStage", target = "view")]
		public function onAddedToStage():void
		{
			trace('onAddedToStage()');
		}
		
		[EventHandler(event = "complete", target = "view")]
		public function onComplete():void
		{
			trace('onComplete');
		}
		
		[EventHandler(event = "removedFromStage", target = "view")]
		public function onRemovedFromStage():void
		{
			trace('onRemovedFromStage()');
		}
		
	}

}