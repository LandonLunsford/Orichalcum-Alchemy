package orichalcum.collection 
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Proxy;

	public class ACollection extends Proxy implements ICollection
	{
		
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
			
			for each(var value:* in this)
				if (!closure.call(thisObject, value))
					return false;
					
			return true;
		}
		
		public function some(closure:Function, thisObject:Object = null):Boolean 
		{
			if (isEmpty)
				return false;
			
			for each(var value:* in this)
				if (closure.call(thisObject, value))
					return true;
					
			return false;
		}
		
		public function forEach(closure:Function, thisObject:Object = null):void 
		{
			for each(var value:* in this)
				closure.call(thisObject, value);
		}
		
		public function map(closure:Function, thisObject:Object = null):ICollection 
		{
			const collection:ICollection = newInstance;
			for each(var value:* in this)
				collection.push(closure.call(thisObject, value));
			return collection;
		}
		
		public function filter(closure:Function, thisObject:Object = null):ICollection
		{
			const collection:ICollection = newInstance;
			for each(var value:* in this)
				closure.call(thisObject, value) && collection.push(value);
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
			for each(var value:* in values)
			{
				var containsValue:Boolean;
				for each(var nestedValue:* in this)
					nestedValue === value && (containsValue = true);
				containsAllValues = containsAllValues && containsValue;
			}
			return containsAllValues;
		}
		
		protected function getValue(index:uint):* 
		{
			throw new IllegalOperationError('ACollection.getValue() is abstract and must be overriden.');
		}
		
		protected function setValue(index:uint, value:*):void 
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

			for each(var value:* in this)
			{
				newCollection.push(value);
			}
			
			if (collection != null)
			{
				for (var i:int = 0; i < collection.length; i++)
				{
					newCollection.push(collection[i]);
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
			for each(var value:* in this)
				string += value + delimiter;
				
			return string.substr(0, delimiter.length) + '';
		}
		
		public function toArray():Array 
		{
			const array:Array = [];
			for each(var value:* in this)
				array[array.length] = value;
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
		
		protected function get newInstance():ICollection
		{
			throw new IllegalOperationError('ACollection.newInstance is abstract and must be overriden.');
		}
		
		public function toString():String
		{
			if (isEmpty) return '( empty )';
			
			var string:String = '( ';
			for each(var value:* in this)
				string += value + ', ';
				
			return string.substr(0, string.length - 2) + ' )';
		}
		
	}

}
