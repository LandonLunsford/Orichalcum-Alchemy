package orichalcum.collection 
{

	public class ArraySequenceTest extends AbstractCollectionTest
	{

		override protected function get newEmptyCollection():ICollection 
		{
			return new ArrayCollection;
		}
		
		override protected function get newFilledCollection():ICollection 
		{
			return new ArrayCollection(0,1,2);
		}
		
	}

}