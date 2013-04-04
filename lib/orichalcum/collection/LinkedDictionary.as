package orichalcum.collection 
{
	import flash.utils.flash_proxy;
	import orichalcum.utility.StringUtil;
	
	use namespace flash_proxy;
	
	/**
	 * Space-efficient, performance-killing Dictionary for small entry counts
	 */
	public class LinkedDictionary implements ICollection
	{
		
		private var _head:LinkedDictionaryNode;
		private var _length:uint;
		
		/* INTERFACE orichalcum.collection.ICollection */
		
		private function _get(key:String):* 
		{
			if (_head == null || key == null)
				return undefined;
			
			for (var node:LinkedDictionaryNode = _head; node != null; node = node.next)
				if (node.key == key) return node.value;
				
			return undefined;
		}
		
		private function _set(key:String, value:*):void 
		{
			for (var current:LinkedDictionaryNode = _head; current != null; current = current.next)
			{
				if (key == current.key)
				{
					current.value = value;
					return;
				}
			}
			
			var node:LinkedDictionaryNode = new LinkedDictionaryNode(value);
			if (_head)
			{
				node.next = _head;
				_head = node;
			}
			else
			{
				_head = node;
			}
			_length++;
		}
		
		private function _delete(key:String):void 
		{
			if (_head == null) return;
			
			if (_head.key == key)
			{
				_head = _head.next;
				_length--;
				return;
			}
			
			for (var previous:LinkedDictionaryNode = _head, current:LinkedDictionaryNode = _head.next; current != null; previous = current,	current = current.next)
			{
				if (current.key === key)
				{
					previous.next = current.next;
					_length--;
					return;
				}
			}
		}
		
		override public function clear():void 
		{
			_head = null;
		}
		
		/* INTERFACE orichalcum.collection.ICollection */
		
		public function get length():uint 
		{
			return _length;
		}
		
		//public function push(...values):uint 
		//{
			//
		//}
		//
		//public function pop():* 
		//{
			//
		//}
		//
		//public function unshift(...values):uint 
		//{
			//
		//}
		//
		//public function shift():* 
		//{
			//
		//}
		
		public function forEach(closure:Function, thisObject:Object = null):void 
		{
			
		}
		
		public function every(closure:Function, thisObject:Object = null):Boolean 
		{
			
		}
		
		public function some(closure:Function, thisObject:Object = null):Boolean 
		{
			
		}
		
		public function map(closure:Function, thisObject:Object = null):ICollection 
		{
			
		}
		
		public function filter(closure:Function, thisObject:Object = null):ICollection 
		{
			
		}
		
		public function concat(collection:ICollection = null):ICollection 
		{
			
		}
		
		public function reverse():ICollection 
		{
			
		}
		
		public function toString():String 
		{
			
		}
		
		public function join(delimiter:String = null):String 
		{
			
		}
		
		public function remove(...values):void 
		{
			
		}
		
		public function contains(...values):Boolean 
		{
			
		}
		
		public function toArray():Array 
		{
			
		}
		
		override public function get isEmpty():Boolean 
		{
			return _head == null;
		}
		
	}

}

internal class LinkedDictionaryNode extends LinkedListNode
{
	public var key:String;
	
	public function LinkedDictionaryNode(key:String, value:* = undefined)
	{
		this.key = key;
		super(value);
	}
}
