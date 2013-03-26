package subject 
{
	import flash.display.Sprite;

	public class Mediator 
	{
		
		[Inject]
		public var view:Sprite;
		
		public function Mediator() 
		{
			
		}
		
		[EventHandler(event = "addedToStage", target = "view")]
		public function onAddedToStage():void
		{
			trace('onAddedToStage()');
		}
		
		[EventHandler(event = "removedFromStage", target = "view")]
		public function onRemovedFromStage():void
		{
			trace('onRemovedFromStage()');
		}
		
	}

}