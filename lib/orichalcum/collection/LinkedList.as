package orichalcum.collection 
{
	import flash.utils.flash_proxy;
	import orichalcum.utility.StringUtil;
	
	use namespace flash_proxy;
	
	public class LinkedList extends ACollection
	{
		private var _head:LinkedListNode;
		private var _tail:LinkedListNode;
		private var _length:uint;
		private var _current:LinkedListNode;
		
		public function LinkedList(...values) 
		{
			push.apply(this, values);
		}
		
		/* INTERFACE orichalcum.collection.ICollection */
		
		override public function push(...values):uint 
		{
			for each(var value:* in values)
			{
				var node:LinkedListNode = new LinkedListNode(value);
				
				if (isEmpty)
				{
					_head = _tail = node;
				}
				else
				{
					_tail.next = node;
					_tail = node;
				}
				_length++;
			}
			return _length;
		}
		
		override public function pop():* 
		{
			if (isEmpty)
				return undefined;
			
			const value:* = _tail.value;
			
			_length--;
			
			if (_length == 0)
			{
				_head = _tail = null;
			}
			else
			{
				_tail = _head;
				for (var i:int = 0; i < _length; i++)
					_tail = _tail.next;
			}
			return value;
		}
		
		override public function unshift(...values):uint 
		{
			for each(var value:* in values)
			{
				const node:LinkedListNode = new LinkedListNode(value);
			
				if (isEmpty)
				{
					_head = _tail = node;
				}
				else
				{
					node.next = _head;
					_head = node;
				}
				_length++;
			}
			return _length;
		}
		
		override public function shift():* 
		{
			if (isEmpty)
				return undefined;
				
			const value:* = _head.value;
			_head = _head.next;
			--_length == 0 && (_tail = null);
			return value;
		}
		
		/**
		 * Removes first occurance of value
		 */
		override public function remove(...values):void 
		{
			for each(var value:* in values)
			{
				if (isEmpty) return;
				
				if (_head.value === value)
				{
					_head = _head.next;
					--_length == 0 && (_tail = null);
					continue;
				}
				
				for (var previous:LinkedListNode = _head, current:LinkedListNode = _head.next; current != null; previous = current,	current = current.next)
				{
					if (current.value === value)
					{
						previous.next = current.next;
						--_length == 0 && (_tail = null);
						break;
					}
				}
			}
		}
		
		override public function reverse():ICollection 
		{
			if (length < 2)
				return this;
			
			_tail = _head;
			var previous:LinkedListNode = _head.next;
			var next:LinkedListNode = _head.next.next;
			previous.next = _head;
			_head.next = next;
			next = next.next;
			while (_head.next != null)
			{
				_head.next.next = previous;
				previous = _head.next;
				_head.next = next;
				next != null && (next = next.next);
			}
			_head = previous;
			return this;
		}
		
		override protected function getValue(index:uint):* 
		{
			if (index >= length)
				return undefined;
			
			for (var node:LinkedListNode = _head; index > 0; index--)
				node = node.next;
				
			return node.value;
		}
		
		override protected function setValue(index:uint, value:*):void 
		{
			if (index >= length)
				throw new ArgumentError(StringUtil.substitute('Argument "{0}" ({1}) is out of bounds{2}.', 'index', index, length == 0 ? '' : ' (0 to ' + (length - 1) + ')'));
			
			for (var node:LinkedListNode = _head; index > 0; index--)
			{
				node || push(undefined);
				node = node.next;
			}
			node.value = value;
		}
		
		override public function clear():void 
		{
			_head = _tail = null;
			_length = 0;
		}
		
		override public function get length():uint 
		{
			return _length;
		}
		
		override protected function get newInstance():ICollection
		{
			return new LinkedList;
		}
		
		/* OVERRIDE flash_proxy */
		
		override flash_proxy function getProperty(name:*):*
		{
			return getValue(name);
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			setValue(name, value);
		}
		
		override flash_proxy function nextNameIndex(index:int):int
		{
			return index < length ? index + 1 : 0;
		}
		
		override flash_proxy function nextValue(index:int):*
		{
			if (index > _length)
				return undefined;
			
			if (index == 1)
			{
				_current = _head;
				return _head.value;
			}
			
			_current = _current.next;
			return _current.value;
		}
		
	}

}

internal class LinkedListNode
{
	public var value:*;
	public var next:LinkedListNode;
	
	public function LinkedListNode(value:* = undefined)
	{
		this.value = value;
	}
}
