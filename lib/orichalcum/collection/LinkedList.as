package orichalcum.collection 
{

	public class LinkedList implements ICollection
	{
		private var _head:LinkedListNode = new HeadNode;
		private var _tail:LinkedListNode = new TailNode;
		private var _length:int;
		
		public function LinkedList() 
		{
			clear();
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
	
	public function add(node:Node):void
	{
		throw new IllegalOperationError('Select tail node for addition.');
	}
	
	public function remove(value:*):Boolean
	{
		if (this.value === value)
		{
			
			return true;
		}
		return
	}
	
	public function contains(value:*):Boolean
	{
		return this.value == value ? true : next.contains(value);
	}
	
	public function getValue(index:uint):*
	{
		return index == 0 ? value : next.getItem(index - 1);
	}
	
	public function setValue(index:uint, value:*):void
	{
		if (index == 0)
		{
			this.value = value;
		}
		else
		{
			next.setValue(index - 1);
		}
	}
	
}

internal class HeadNode extends LinkedListNode
{
	override public function remove(value:*):Boolean 
	{
		return next.remove(value);
	}
	
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
	
	override public function add(value:*):void 
	{
		/**
		 * Tail node (since it is the end) uses the "next" container as a "previous container"
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