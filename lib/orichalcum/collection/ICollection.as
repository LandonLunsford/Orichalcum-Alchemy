package orichalcum.collection 
{

	public interface ICollection 
	{
		function add(...values):void;
		function remove(...values):void;
		function contains(...values):Boolean;
		function getValue(index:uint):*;
		function get length():uint;
		function get isEmpty():Boolean;
	}

}