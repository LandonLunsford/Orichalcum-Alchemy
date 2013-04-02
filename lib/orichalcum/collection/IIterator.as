package orichalcum.collection 
{

	/**
	 * @example
	 * for (iterator.start(); iterator.hasNext(); iterator.next())
	 * 	trace(iterator.value);
	 */
	public interface IIterator
	{
		function start():void;
		function step():void;
		function hasNext():Boolean;
		function get value():*;
		function set value(value:*):void;
	}

}
