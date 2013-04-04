package orichalcum.collection 
{
	import flash.errors.IllegalOperationError;
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
		
		public function forEach(closure:Function, thisObject:Object = null):void 
		{
			throw new IllegalOperationError('TODO: unimplemented.');
		}
		
		public function every(closure:Function, thisObject:Object = null):Boolean 
		{
			throw new IllegalOperationError('TODO: unimplemented.');
		}
		
		public function some(closure:Function, thisObject:Object = null):Boolean 
		{
			throw new IllegalOperationError('TODO: unimplemented.');
		}
		
		public function map(closure:Function, thisObject:Object = null):ICollection 
		{
			throw new IllegalOperationError('TODO: unimplemented.');
		}
		
		public function filter(closure:Function, thisObject:Object = null):ICollection 
		{
			throw new IllegalOperationError('TODO: unimplemented.');
		}
		
		public function concat(collection:ICollection = null):ICollection 
		{
			throw new IllegalOperationError('TODO: unimplemented.');
		}
		
		public function toString():String 
		{
			throw new IllegalOperationError('TODO: unimplemented.');
		}
		
		public function join(delimiter:String = null):String 
		{
			throw new IllegalOperationError('TODO: unimplemented.');
		}
		
		public function remove(...values):void 
		{
			throw new IllegalOperationError('TODO: unimplemented.');
		}
		
		public function contains(...values):Boolean 
		{
			throw new IllegalOperationError('TODO: unimplemented.');
		}
		
		public function toArray():Array 
		{
			throw new IllegalOperationError('TODO: unimplemented.');
		}
		
		public function get isEmpty():Boolean 
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
