package orichalcum.alchemy.language.xmltag 
{
	
	public class MapXmltag 
	{
		private var _name:String;
		private var _id:String;
		private var _to:String;
		private var _toValue:String;
		private var _toReference:String;
		private var _toProvider:String;
		private var _toPrototype:String;
		private var _toSingleton:String;
		private var _toPool:String;
		private var _toFactory:String;
		private var _factoryMethodDelimiter:String;
		
		public function MapXmltag(
			name:String = 'map',
			id:String = 'id',
			to:String = 'to',
			toValue:String = 'to-value',
			toReference:String = 'to-reference',
			toProvider:String = 'to-provider',
			toPrototype:String = 'to-prototype',
			toSingleton:String = 'to-singleton',
			toPool:String = 'to-pool',
			toFactory:String = 'to-factory',
			factoryMethodDelimiter:String = '#') 
		{
			_name = name;
			_id = id;
			_to = to;
			_toValue = toValue;
			_toReference = toReference;
			_toProvider = toProvider;
			_toPrototype = toPrototype;
			_toSingleton = toSingleton;
			_toPool = toPool;
			_toFactory = toFactory;
			_factoryMethodDelimiter = factoryMethodDelimiter;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public function set id(value:String):void 
		{
			_id = value;
		}
		
		public function get to():String 
		{
			return _to;
		}
		
		public function set to(value:String):void 
		{
			_to = value;
		}
		
		public function get toValue():String 
		{
			return _toValue;
		}
		
		public function set toValue(value:String):void 
		{
			_toValue = value;
		}
		
		public function get toReference():String 
		{
			return _toReference;
		}
		
		public function set toReference(value:String):void 
		{
			_toReference = value;
		}
		
		public function get toProvider():String 
		{
			return _toProvider;
		}
		
		public function set toProvider(value:String):void 
		{
			_toProvider = value;
		}
		
		public function get toPrototype():String 
		{
			return _toPrototype;
		}
		
		public function set toPrototype(value:String):void 
		{
			_toPrototype = value;
		}
		
		public function get toSingleton():String 
		{
			return _toSingleton;
		}
		
		public function set toSingleton(value:String):void 
		{
			_toSingleton = value;
		}
		
		public function get toPool():String 
		{
			return _toPool;
		}
		
		public function set toPool(value:String):void 
		{
			_toPool = value;
		}
		
		public function get toFactory():String 
		{
			return _toFactory;
		}
		
		public function set toFactory(value:String):void 
		{
			_toFactory = value;
		}
		
		public function get factoryMethodDelimiter():String 
		{
			return _factoryMethodDelimiter;
		}
		
		public function set factoryMethodDelimiter(value:String):void 
		{
			_factoryMethodDelimiter = value;
		}
		
	}

}