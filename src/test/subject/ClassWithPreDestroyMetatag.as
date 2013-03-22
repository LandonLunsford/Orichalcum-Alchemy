package subject 
{

	public class ClassWithPreDestroyMetatag 
	{
		
		public var preDestroyCalled:Boolean;
		public var otherPreDestroyCalled:Boolean;
		
		[PreDestroy]
		public function preDestroy():void
		{
			preDestroyCalled = true;
		}
		
		public function otherPreDestroy():void
		{
			otherPreDestroyCalled = true;
		}
		
	}

}
