package orichalcum.collection 
{

	public interface IList extends ICollection
	{
		
		function push(...values):uint;
		function pop():*;
		function unshift(...values):uint;
		function shift():*;
		function reverse():IList;
		function concat(collection:ICollection = null):IList;
		//function splice(...rest):ICollection;
		//function slice(A:* = 0, b:* = int.MAX_VALUE);
		//function sort(...rest):ICollection;
		//function sortOn(names:*, options:* = 0, ...rest):ICollection;
		//function set length(value:uint):void;
	}

}