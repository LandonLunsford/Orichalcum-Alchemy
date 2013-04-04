package orichalcum.collection 
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Proxy;

	public class AbstractList extends Proxy implements IList
	{
		
		/* INTERFACE orichalcum.collection.ICollection */
		
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
				collection.add(closure.call(thisObject, value));
			return collection;
		}
		
		public function filter(closure:Function, thisObject:Object = null):ICollection
		{
			const collection:ICollection = newInstance;
			for each(var value:* in this)
				closure.call(thisObject, value) && collection.add(value);
			return collection;
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
		
		public function concat(collection:ICollection = null):IList 
		{
			const newCollection:ICollection = newInstance;

			for each(var value:* in this)
			{
				newCollection.add(value);
			}
			
			if (collection != null)
			{
				for (var i:int = 0; i < collection.length; i++)
				{
					newCollection.add(collection[i]);
				}
			}
			return newCollection as IList;
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
		
		public function get isEmpty():Boolean 
		{
			return length == 0;
		}
		
		public function remove(...values):void 
		{
			throw new IllegalOperationError('ACollection.remove() is abstract and must be overriden.');
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
		
		protected function get newInstance():ICollection
		{
			throw new IllegalOperationError('ACollection.newInstance is abstract and must be overriden.');
		}
		
		public function get length():uint 
		{
			throw new IllegalOperationError('ACollection.length is abstract and must be overriden.');
		}
		
		public function add(...values):uint 
		{
			return push.apply(this, values);
		}
		
		public function toString():String
		{
			if (isEmpty) return '( empty )';
			
			var string:String = '( ';
			for each(var value:* in this)
				string += value + ', ';
				
			return string.substr(0, string.length - 2) + ' )';
		}
		
		public function push(...values):uint 
		{
			throw new IllegalOperationError('ACollection.push is abstract and must be overriden.');
		}
		
		public function pop():* 
		{
			throw new IllegalOperationError('ACollection.pop is abstract and must be overriden.');
		}
		
		public function unshift(...values):uint 
		{
			throw new IllegalOperationError('ACollection.unshift is abstract and must be overriden.');
		}
		
		public function shift():* 
		{
			throw new IllegalOperationError('ACollection.shift is abstract and must be overriden.');
		}
		
		public function reverse():IList 
		{
			throw new IllegalOperationError('ACollection.reverse is abstract and must be overriden.');
		}
		
		
	}

}
