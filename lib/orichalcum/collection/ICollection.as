package orichalcum.collection 
{

	public interface ICollection
	{
		function add(...values):void;
		function remove(...values):void;
		function contains(...values):Boolean;
		function getValue(index:uint):*;
		function setValue(index:uint, value:*):void;
		function clear():void;
		function concat(collection:ICollection = null):ICollection;
		function toArray():Array;
		function get length():uint;
		function get isEmpty():Boolean;
		function get iterator():IIterator;
	}

}
