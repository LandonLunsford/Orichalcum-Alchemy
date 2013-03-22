package subject 
{

	public class ClassWithPostConstructMetatag
	{
		
		public var postConstructCalled:Boolean;
		
		public var otherPostConstructWasCalled:Boolean;
		
		[PostConstruct]
		public function postConstruct():void
		{
			postConstructCalled = true;
		}
		
		public function otherPostConstruct():void
		{
			otherPostConstructWasCalled = true;
		}
		
	}

}
