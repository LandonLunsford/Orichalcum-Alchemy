package orichalcum.collection 
{
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	public class ACollection implements ICollection
	{
		
		public function ACollection() 
		{
			
		}
		
		/* INTERFACE orichalcum.collection.ICollection */
		
		public function push(...values):uint 
		{
			throw new IllegalOperationError('ACollection.push() is abstract and must be overriden.');
		}
		
		public function pop():* 
		{
			throw new IllegalOperationError('ACollection.pop() is abstract and must be overriden.');
		}
		
		public function unshift(...values):uint 
		{
			throw new IllegalOperationError('ACollection.unshift() is abstract and must be overriden.');
		}
		
		public function shift():* 
		{
			throw new IllegalOperationError('ACollection.shift() is abstract and must be overriden.');
		}
		
		public function every(closure:Function, thisObject:Object = null):Boolean 
		{
			if (isEmpty)
				return false;
			
			const iterator:IIterator = iterator;
			for (iterator.start(); iterator.hasNext(); iterator.step())
				if (!closure.call(thisObject, iterator.value))
					return false;
					
			return true;
		}
		
		public function some(closure:Function, thisObject:Object = null):Boolean 
		{
			if (isEmpty)
				return false;
			
			const iterator:IIterator = iterator;
			for (iterator.start(); iterator.hasNext(); iterator.step())
				if (closure.call(thisObject, iterator.value))
					return true;
					
			return false;
		}
		
		public function forEach(closure:Function, thisObject:Object = null):void 
		{
			const iterator:IIterator = iterator;
			for (iterator.start(); iterator.hasNext(); iterator.step())
				closure.call(thisObject, iterator.value);
		}
		
		public function map(closure:Function, thisObject:Object = null):ICollection 
		{
			const collection:ICollection = newInstance;
			const iterator:IIterator = iterator;
			for (iterator.start(); iterator.hasNext(); iterator.step())
				collection.push(closure.call(thisObject, iterator.value));
			return collection;
		}
		
		public function filter(closure:Function, thisObject:Object = null):ICollection
		{
			const collection:ICollection = newInstance;
			const iterator:IIterator = iterator;
			for (iterator.start(); iterator.hasNext(); iterator.step())
				closure.call(thisObject, iterator.value) && collection.push(iterator.value);
			return collection;
		}
		
		public function remove(...values):void 
		{
			throw new IllegalOperationError('ACollection.remove() is abstract and must be overriden.');
		}
		
		public function contains(...values):Boolean 
		{
			if (isEmpty) return false;
			
			var containsAllValues:Boolean = true;
			var iterator:IIterator = iterator;
			for each(var value:* in values)
			{
				var containsValue:Boolean;
				for (iterator.start(); iterator.hasNext(); iterator.step())
					iterator.value === value && (containsValue = true);
				containsAllValues = containsAllValues && containsValue;
			}
			return containsAllValues;
		}
		
		public function getValue(index:uint):* 
		{
			throw new IllegalOperationError('ACollection.getValue() is abstract and must be overriden.');
		}
		
		public function setValue(index:uint, value:*):void 
		{
			throw new IllegalOperationError('ACollection.setValue() is abstract and must be overriden.');
		}
		
		public function clear():void 
		{
			throw new IllegalOperationError('ACollection.clear() is abstract and must be overriden.');
		}
		
		public function concat(collection:ICollection = null):ICollection 
		{
			const newCollection:ICollection = newInstance;

			const iterator:IIterator = iterator;
			for (iterator.start(); iterator.hasNext(); iterator.step())
			{
				newCollection.push(iterator.value);
			}
			
			if (collection != null)
			{
				for (var i:int = 0; i < collection.length; i++)
				{
					newCollection.push(collection.getValue(i));
				}
			}
			return newCollection;
		}
		
		public function reverse():ICollection
		{
			throw new IllegalOperationError('ACollection.reverse is abstract and must be overriden.');
		}
		
		public function join(delimiter:String = null):String
		{
			if (isEmpty) return '';
			
			var string:String = '';
			const iterator:IIterator = iterator;
			for (iterator.start(); iterator.hasNext(); iterator.step())
				string += iterator.value + delimiter;
				
			return string.substr(0, delimiter.length) + '';
		}
		
		public function toArray():Array 
		{
			const array:Array = [];
			const iterator:IIterator = iterator;
			for (iterator.start(); iterator.hasNext(); iterator.step())
				array[array.length] = iterator.value;
			return array;
		}
		
		public function get length():uint 
		{
			throw new IllegalOperationError('ACollection.length is abstract and must be overriden.');
		}
		
		public function get isEmpty():Boolean 
		{
			return length == 0;
		}
		
		public function get iterator():IIterator 
		{
			throw new IllegalOperationError('ACollection.iterator is abstract and must be overriden.');
		}
		
		protected function get newInstance():ICollection
		{
			throw new IllegalOperationError('ACollection.newInstance is abstract and must be overriden.');
		}
		
		public function toString():String
		{
			if (isEmpty) return '( empty )';
			
			var string:String = '( ';
			const iterator:IIterator = iterator;
			for (iterator.start(); iterator.hasNext(); iterator.step())
				string += iterator.value + ', ';
				
			return string.substr(0, string.length - 2) + ' )';
		}
		
	}

}
