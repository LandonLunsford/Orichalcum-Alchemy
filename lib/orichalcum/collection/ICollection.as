package orichalcum.collection 
{

	public interface ICollection
	{
		function get isEmpty():Boolean;
		function get length():uint;
		function add(...values):uint;
		function forEach(closure:Function, thisObject:Object = null):void
		function every(closure:Function, thisObject:Object = null):Boolean;
		function some(closure:Function, thisObject:Object = null):Boolean;
		function map(closure:Function, thisObject:Object = null):ICollection;
		function filter(closure:Function, thisObject:Object = null):ICollection;
		//function concat(collection:ICollection = null):ICollection;
		function toString():String;
		function join(delimiter:String = null):String;
		function remove(...values):void;
		function contains(...values):Boolean;
		function clear():void;
		function toArray():Array;
	}

}
