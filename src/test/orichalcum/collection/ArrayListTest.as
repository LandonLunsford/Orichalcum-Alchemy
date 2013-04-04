package orichalcum.collection 
{

	public class ArrayListTest extends AbstractListTest
	{

		override protected function get newEmptyCollection():IList 
		{
			return new ArrayList;
		}
		
		override protected function get newFilledCollection():IList 
		{
			return new ArrayList(0,1,2);
		}
		
	}

}