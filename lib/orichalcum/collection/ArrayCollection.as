package orichalcum.collection 
{
	import orichalcum.utility.StringUtil;

	public class ArrayCollection extends ACollection implements IIterator
	{
		private var _array:Array;
		
		public function ArrayCollection(...values) 
		{
			_array = [];
			_array.push.apply(_array, values);
		}
		
		/* INTERFACE orichalcum.collection.ICollection */
		
		override public function push(...values):uint 
		{
			return _array.push.apply(_array, values);
		}
		
		override public function pop():* 
		{
			return _array.pop();
		}
		
		override public function unshift(...values):uint 
		{
			return _array.unshift.apply(_array, values);
		}
		
		override public function shift():* 
		{
			return _array.shift();
		}
		
		override public function remove(...values):void 
		{
			for each(var value:* in values)
			{
				var index:int = _array.indexOf(value);
				if (index >= 0) _array.splice(index, 1);
			}
		}
		
		override public function getValue(index:uint):* 
		{
			return _array[index];
		}
		
		override public function setValue(index:uint, value:*):void 
		{
			if (index >= length)
				throw new ArgumentError(StringUtil.substitute('Argument "{0}" ({1}) is out of bounds{2}.', 'index', index, length == 0 ? '' : ' (0 to ' + (length - 1) + ')'));
			
			_array[index] = value;
		}
		
		override public function reverse():ICollection 
		{
			_array.reverse();
			return this;
		}
		
		override public function clear():void 
		{
			_array.length = 0;
		}
		
		override public function toArray():Array 
		{
			return _array.concat();
		}
		
		override public function get length():uint 
		{
			return _array.length;
		}
		
		override public function get iterator():IIterator 
		{
			return this as IIterator;
		}
		
		override protected function get newInstance():ICollection 
		{
			return new ArrayCollection;
		}
		
		/* INTERFACE orichalcum.collection.IIterator */
		
		private var _index:int;
		
		public function start():void 
		{
			_index = 0;
		}
		
		public function step():void 
		{
			_index++;
		}
		
		public function hasNext():Boolean 
		{
			return _index < _array.length;
		}
		
		public function get value():* 
		{
			return _array[_index];
		}
		
		public function set value(value:*):void 
		{
			_array[_index] = value;
		}
		
	}

}
