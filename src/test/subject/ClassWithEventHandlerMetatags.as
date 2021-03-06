package subject 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class ClassWithEventHandlerMetatags extends EventDispatcher
	{
		public var target:IEventDispatcher;
		public var root:DisplayObjectContainer;
		
		public function ClassWithEventHandlerMetatags() 
		{
			target = new EventDispatcher;
			
			root = new Sprite;
			
			const child:Sprite = new Sprite;
			child.name = 'child';
			root.addChild(child);
			
			const grandchild:Sprite = new Sprite;
			grandchild.name = 'grandchild';
			child.addChild(grandchild);
		}
		
		[EventHandler(event = 'complete')]
		public function onComplete():void {}
		
		[EventHandler(event = 'complete', target = 'target')]
		public function target_onComplete():void {}
		
		[EventHandler(event = 'complete', target = 'root.child.grandchild')]
		public function grandchild_onComplete():void { }
	
		[EventHandler]
		public function target_click():void {}
		
	}

}