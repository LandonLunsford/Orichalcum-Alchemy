package orichalcum.alchemy.ingredient.metatag 
{
	import orichalcum.alchemy.ingredient.SignalHandler;

	public class MetatagToSignalHandlerTransform 
	{
		
		public function MetatagToSignalHandlerTransform() 
		{
			
		}
		
		public function apply(metatag:XML):*
		{
			return new SignalHandler(getSignalPath(metatag), getSlotPath(metatag), getOnce(metatag));
		}
		
	}

}