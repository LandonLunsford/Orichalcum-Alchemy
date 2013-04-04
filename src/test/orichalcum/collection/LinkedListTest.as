package orichalcum.collection 
{

	public class LinkedListTest extends AbstractListTest
	{

		override protected function get newEmptyCollection():IList 
		{
			return new LinkedList;
		}
		
		override protected function get newFilledCollection():IList 
		{
			return new LinkedList(0,1,2);
		}
		
	}

}