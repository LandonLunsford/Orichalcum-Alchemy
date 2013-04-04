package orichalcum.collection 
{
	import flash.utils.flash_proxy;
	import orichalcum.utility.StringUtil;
	
	use namespace flash_proxy;

	public class ArrayList extends AbstractList implements IList
	{
		private var _array:Array;
		
		public function ArrayList(...values) 
		{
			_array = [];
			_array.push.apply(_array, values);
		}
		
		/* INTERFACE orichalcum.collection.IList */
		
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
		
		override protected function getValue(index:uint):* 
		{
			return _array[index];
		}
		
		override protected function setValue(index:uint, value:*):void 
		{
			if (index >= length)
				throw new ArgumentError(StringUtil.substitute('Argument "{0}" ({1}) is out of bounds{2}.', 'index', index, length == 0 ? '' : ' (0 to ' + (length - 1) + ')'));
			
			_array[index] = value;
		}
		
		override public function reverse():IList 
		{
			_array.reverse();
			return this;
		}
		
		/* OVERRIDE ICollection */
		
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
		
		override protected function get newInstance():ICollection 
		{
			return new ArrayList;
		}
		
		/* OVERRIDE flash_proxy */
		
		override flash_proxy function hasProperty(name:*):Boolean 
		{
			return name in _array;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return _array[name];
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_array[name] = value;
		}
		
		override flash_proxy function nextNameIndex(index:int):int
		{
			return index < length ? index + 1 : 0;
		}
		
		override flash_proxy function nextValue(index:int):*
		{
			return _array[index - 1];
		}
		
	}

}
