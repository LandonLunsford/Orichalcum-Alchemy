package subject 
{

	public class ClassWithInvalidEventHandlerTargetPath 
	{
		
		[EventHandler(event = 'complete', target = 'a.b')]
		public function invalidTargetPath_onComplete():void
		{
			
		}
		
	}

}