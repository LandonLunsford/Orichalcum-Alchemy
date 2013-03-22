package orichalcum.alchemy.provider 
{
	
	public interface IPooledInstanceProvider extends IInstanceProvider
	{
		/**
		 * Should be called when instance is destroyed
		 * so the pool can reuse the instance
		 */
		function returnInstance(instance:*):void;
	}

}