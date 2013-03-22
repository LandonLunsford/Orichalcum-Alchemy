package subject 
{

	public class ClassWithPostConstruct
	{
		
		public var postConstructCalled:Boolean;
		
		public function postConstruct():void
		{
			postConstructCalled = true;
		}
		
	}

}
