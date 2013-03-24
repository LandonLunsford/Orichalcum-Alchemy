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
		
		[EventHandler(event = "removedToStage", target = "view")]
		public function onRemovedToStage():void
		{
			trace('onRemovedToStage()');
		}
		
	}

}