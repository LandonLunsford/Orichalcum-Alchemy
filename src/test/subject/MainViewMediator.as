package subject 
{
	import flash.events.EventDispatcher;

	public class MainViewMediator extends EventDispatcher
	{
		
		public function MainViewMediator() 
		{
			
		}
		
		public var view:MainView;
		
		public function completeHandler():void {}
		
		public function view_clickHandler():void {}
		
		public function view_mouseOverHandler(mouseX:Number, mouseY:Number):void {}
		
		public function view_mouseOutHandler():void {}
		
		public function view_mouseDownHandler():void {}
		
		public function view_mouseUpHandler():void {}
		
		public function view_mouseWheelHandler():void {}
		
	}

}