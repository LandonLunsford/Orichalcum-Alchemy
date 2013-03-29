package orichalcum.collection 
{

	public class LinkedList implements ICollection
	{
		
		private var _head:LinkedListNode;
		private var _tail:LinkedListNode;
		private var _length:int;
		
		public function LinkedList() 
		{
			_head = new HeadNode;
			_tail = new TailNode;
			_head.next = _tail;
			_tail.next = _head;
		}
		
		/* INTERFACE orichalcum.collection.ICollection */
		
		public function add(...values):void 
		{
			/**
			 * N
			 */
			for each(var value:* in values)
			{
				_tail.add(value);
				_length++;
			}
		}
		
		public function remove(...values):void 
		{
			/**
			 * N^2
			 */
			for each(var value:* in values)
			{
				_head.remove(value) && _length--;
			}
		}
		
		public function contains(...values):Boolean 
		{
			/**
			 * N^2
			 */
			for each(var value:* in values)
			{
				if (!_head.contains(value))
					return false;
			}
			return !isEmpty;
		}
		
		public function getValue(index:uint):* 
		{
			return _head.getValue(index);
		}
		
		public function get length():uint 
		{
			return _length;
		}
		
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
		// only add to tail in Singly Linked List
		throw new IllegalOperationError('Select tail node for insertion.');
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
}

internal class TailNode extends LinkedListNode
{
	override public function getValue(index:uint):* 
	{
		throw new TypeError('Index is out of bounds.');
	}
	
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
}