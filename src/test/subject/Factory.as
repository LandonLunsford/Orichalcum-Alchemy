package subject 
{
	
	public class Factory 
	{
		static public var staticFactoryMethodProvision:*;
		static public var instanceFactoryMethodProvision:*;
		
		static public function staticFactoryMethod():*
		{
			return staticFactoryMethodProvision;
		}
		
		public function instanceFactoryMethod():*
		{
			return instanceFactoryMethodProvision;
		}
		
	}

}