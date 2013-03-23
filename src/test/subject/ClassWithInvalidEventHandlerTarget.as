package subject 
{

	public class ClassWithInvalidEventHandlerTarget 
	{
		
		public var invalidTarget:Object = {};
		
		[EventHandler(event = 'complete', target = 'invalidTarget')]
		public function invalidTarget_onComplete():void
		{
			
		}
		
	}

}