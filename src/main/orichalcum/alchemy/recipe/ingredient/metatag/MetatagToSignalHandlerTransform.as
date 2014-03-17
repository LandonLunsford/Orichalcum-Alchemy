package orichalcum.alchemy.recipe.ingredient.metatag 
{
	import orichalcum.alchemy.recipe.ingredient.SignalHandler;

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