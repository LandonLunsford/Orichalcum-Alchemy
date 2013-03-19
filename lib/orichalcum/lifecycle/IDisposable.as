package orichalcum.lifecycle 
{
	
	public interface IDisposable
	{
		/**
		 * Call this method to release all resources reserved by the object
		 * This is usually called directly before releaseing the object itself
		 * @example
		 * disposable.dispose();
		 * disposable = null;
		 */
		function dispose():void;
	}
	
}