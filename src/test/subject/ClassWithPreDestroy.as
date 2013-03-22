package subject 
{

	public class ClassWithPreDestroy
	{
		
		public var preDestroyCalled:Boolean;
		
		public function preDestroy():void
		{
			preDestroyCalled = true;
		}
		
	}

}
