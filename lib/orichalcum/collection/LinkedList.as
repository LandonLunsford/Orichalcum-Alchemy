package orichalcum.collection 
{
	

	public class LinkedList implements ICollection
	{
		
		private var _length:int;
		private var _head:Node;
		private var _tail:Node;
		
		public function LinkedList()
		{
			
		}
		
		/* INTERFACE orichalcum.collection.ICollection */
		
		public function add(...values):void 
		{
			for each(var value:* in values)
			{
				const node:Node = new Node;
				node.value = value;
				tail.add(node);
				_length++;
			}
		}
		
		public function remove(...values):void 
		{
			if (isEmpty) return;
			
			/**
			 * N*N
			 */
			for each(var value:* in values)
			{
				head.remove(value) && _length--;
			}
		}
		
		public function contains(...values):Boolean 
		{
			if (isEmpty) return false;
			
			var containsEach:Boolean = true;
			for each(var value:* in values)
			{
				containsEach = containsEach && head.contains(value);
			}
			return containsEach;
		}
		
		public function getValue(index:uint):* 
		{
			return head.getItem(index);
		}
		
		public function get length():uint 
		{
			return _length;
		}
		
		public function get isEmpty():Boolean
		{
			return _length == 0;
		}
		
		private function get head():Node
		{
			return _head ||= (_tail = new Node);
		}
		
		private function get tail():Node
		{
			return _tail ||= (_head = new Node);
		}

	}

}

internal class Node
{
	public var value:*;
	public var next:Node;
	
	public function add(node:Node):void
	{
		next ? next.add(node) : next = node;
	}
	
	public function remove(value:*):Boolean
	{
		if (next)
		{
			if (next.value == value)
			{
				next = next.next;
				return true;
			}
			return next.remove(value);
		}
		return false;
	}
	
	public function contains(value:*):Boolean
	{
		return this.value == value || next.contains(value);
	}
	
	public function getItem(index:uint):*
	{
		return index == 0 ? value : next.value
	}
	
}
