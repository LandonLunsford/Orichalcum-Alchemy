package subject 
{

	public class Multiton 
	{
		static public var totalInstances:uint;
		
		public function Multiton() 
		{
			totalInstances++;
		}
		
	}

}