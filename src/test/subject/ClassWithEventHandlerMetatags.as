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
		public var onCompleteCalled:Boolean;
		public var target_onCompleteCalled:Boolean;
		public var root_child_child_onCompleteCalled:Boolean;
		
		public function ClassWithEventHandlerMetatags() 
		{
			target = new EventDispatcher;
			
			root = new Sprite;
			
			const child:Sprite = new Sprite;
			child.name = 'child';
			root.addChild(child);
			
			const grandchild:Sprite = new Sprite;
			grandchild.name = 'child';
			child.addChild(grandchild);
		}
		
		[EventHandler(event = 'complete')]
		public function onComplete():void
		{
			onCompleteCalled = true;
		}
		
		[EventHandler(event = 'complete', target = 'target')]
		public function target_onComplete():void
		{
			target_onCompleteCalled = true;
		}
		
		[EventHandler(event = 'complete', target = 'root.child.child')]
		public function root_child_child_onComplete():void
		{
			root_child_child_onCompleteCalled = true;
		}
		
	}

}