package orichalcum.collection 
{

	/**
	 * This interface mirrors the commonly known
	 * AS3 Array API to eliminate any learning curve
	 */
	public interface ICollection
	{
		
		/*
		 * AS3 Array methods
		 */
		
		function get length():uint;
		function push(...values):uint;
		function pop():*;
		function unshift(...values):uint;
		function shift():*;
		function forEach(closure:Function, thisObject:Object = null):void
		function every(closure:Function, thisObject:Object = null):Boolean;
		function some(closure:Function, thisObject:Object = null):Boolean;
		function map(closure:Function, thisObject:Object = null):ICollection;
		function filter(closure:Function, thisObject:Object = null):ICollection;
		function concat(collection:ICollection = null):ICollection;
		function reverse():ICollection;
		function toString():String;
		function join(delimiter:String = null):String;
		//function splice(...rest):ICollection;
		//function slice(A:* = 0, b:* = int.MAX_VALUE);
		//function sort(...rest):ICollection;
		//function sortOn(names:*, options:* = 0, ...rest):ICollection;
		
		/*
		 * New ICollection methods
		 */
		
		function get isEmpty():Boolean;
		function remove(...values):void;
		function contains(...values):Boolean;
		function getValue(index:uint):*;
		function setValue(index:uint, value:*):void;
		function clear():void;
		function toArray():Array;
	}

}
