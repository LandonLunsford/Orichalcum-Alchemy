package orichalcum.collection 
{

	/**
	 * [WARNING] To acheive a minimal data footprint this class's "iterator"
	 * implementation is intentionally non-concurrent and should not be iterated
	 * over twice simultaneously.
	 */
	public class LinkedList implements ICollection, IIterator
	{
		private var _head:LinkedListNode = new HeadNode;
		private var _tail:LinkedListNode = new TailNode;
		private var _length:int;
		private var _current:LinkedListNode;
		
		public function LinkedList(...values) 
		{
			clear();
			add.apply(this, values);
		}
		
		/* INTERFACE orichalcum.collection.ICollection */
		
		/**
		 * O(N) (values.length)
		 */
		public function add(...values):void 
		{
			
			for each(var value:* in values)
			{
				_tail.add(value);
				_length++;
			}
		}
		
		/**
		 * O(N^2) (values.length * length)
		 */
		public function remove(...values):void 
		{
			for each(var value:* in values)
			{
				_head.remove(value) && _length--;
			}
		}
		
		/**
		 * O(values.length * length)
		 */
		public function contains(...values):Boolean 
		{
			for each(var value:* in values)
			{
				if (!_head.contains(value))
					return false;
			}
			return !isEmpty;
		}
		
		/**
		 * O(c)
		 */
		public function clear():void
		{
			_head.next = _tail;
			_tail.next = _head;
			_length = 0;
		}
		
		/**
		 * O(N)
		 */
		public function getValue(index:uint):* 
		{
			return _head.getValue(index);
		}
		
		/**
		 * O(N)
		 */
		public function setValue(index:uint, value:*):void
		{
			_head.setValue(index, value);
		}
		
		/**
		 * O(N^2)
		 */
		public function concat(collection:ICollection = null):ICollection 
		{
			const newCollection:ICollection = new LinkedList;
			/**
			 * O(N)
			 */
			for (var node:LinkedListNode = _head.next; node !== _tail; node = node.next)
			{
				newCollection.add(node.value);
			}
			if (collection)
			{
				/**
				 * O(N^2)
				 */
				for (var i:int = 0; i < collection.length; i++)
				{
					newCollection.add(collection.getValue(i));
				}
			}
			return newCollection;
		}
		
		/**
		 * O(N)
		 */
		public function toArray():Array
		{
			if (isEmpty) return [];
			const array:Array = [];
			for (var node:LinkedListNode = _head.next; node !== _tail; node = node.next)
			{
				array[array.length] = node.value;
			}
			return array;
		}
		
		/**
		 * O(c)
		 */
		public function get length():uint 
		{
			return _length;
		}
		
		/**
		 * O(c)
		 */
		public function get isEmpty():Boolean 
		{
			return _length == 0;
		}
		
		public function get iterator():IIterator
		{
			start();
			return this as IIterator;
		}
		
		/* orichalcum.collection.IIterator */
		
		public function start():void
		{
			_current = _head.next;
		}
		
		public function next():* 
		{
			_current = _current.next;
			return value;
		}
		
		public function get value():* 
		{
			return _current.value;
		}
		
		public function set value(value:*):void
		{
			_current.value = value;
		}
		
		public function hasNext():Boolean 
		{
			return _current !== _tail;
		}
		
	}

}

import flash.errors.IllegalOperationError;
import orichalcum.utility.StringUtil;

internal class LinkedListNode
{
	
	public var value:*;
	public var next:LinkedListNode;
	
	public function LinkedListNode(value:* = null)
	{
		this.value = value;
	}
	
	public function add(value:*):void
	{
		throw new IllegalOperationError('Select tail node for addition.');
	}
	
	public function remove(value:*):Boolean
	{
		if (next.value === value)
		{
			next = next.next;
			return true;
		}
		return next.remove(value);
	}
	
	public function contains(value:*):Boolean
	{
		return this.value == value ? true : next.contains(value);
	}
	
	public function getValue(index:uint):*
	{
		return index == 0 ? value : next.getValue(index - 1);
	}
	
	public function setValue(index:uint, value:*):void
	{
		if (index == 0)
		{
			this.value = value;
		}
		else
		{
			next.setValue(index - 1, value);
		}
	}

}

internal class HeadNode extends LinkedListNode
{

	override public function contains(value:*):Boolean 
	{
		return next.contains(value);
	}
	
	override public function getValue(index:uint):* 
	{
		return next.getValue(index);
	}
	
	override public function setValue(index:uint, value:*):void 
	{
		next.setValue(index, value);
	}
}

internal class TailNode extends LinkedListNode
{
	
	public function TailNode()
	{
		value = TailNode;
	}
	
	override public function add(value:*):void 
	{
		/**
		 * The tail node, (since it is the end) uses the "next" reference
		 * as a "previous reference" for O(c) list addition
		 * previous.next = node;
		 * node.next = this;
		 * this.previous = node;
		 */
		const node:LinkedListNode = new LinkedListNode(value);
		next.next = node;
		node.next = this;
		next = node;
	}
	
	override public function remove(value:*):Boolean 
	{
		return false;
	}
	
	override public function contains(value:*):Boolean 
	{
		return false;
	}
	
	override public function getValue(index:uint):* 
	{
		throw new TypeError('Index is out of bounds.');
	}
	
	override public function setValue(index:uint, value:*):void 
	{
		throw new TypeError('Index is out of bounds.');
	}
}
