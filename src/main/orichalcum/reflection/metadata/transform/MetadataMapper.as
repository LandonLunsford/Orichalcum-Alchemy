package orichalcum.reflection.metadata.transform 
{
	import flash.utils.Dictionary;
	import orichalcum.utility.Xmls;

	public class MetadataMapper implements IMetadataTransform
	{
		
		private var _hostname:String;
		private var _arguments:Dictionary = new Dictionary;
		
		public function hostname(property:String):MetadataMapper
		{
			_hostname = property;
			return this;
		}
		
		public function argument(key:String):MetadataArgumentMapper
		{
			return _arguments[key] = new MetadataArgumentMapper(this, key);
		}
		
		public function transform(metadata:XML, flyweight:Object = null):* 
		{
			const to:Object = flyweight ? flyweight : {};
			
			if (_hostname)
			{
				to[_hostname] = metadata.parent().@name.toString();
			}
			
			for each(var metadataArgument:XML in metadata.arg)
			{
				var key:String = metadataArgument.@key.toString();
				var value:String = metadataArgument.@value.toString();
				
				var argument:MetadataArgumentMapper;
				var interpretedValue:*;
				
				if (key.length == 0)
				{
					argument = _arguments[value];
					interpretedValue = argument && argument._implicit
						? argument._implicit
						: true;
						
					key = value;
				}
				else
				{
					argument = _arguments[key];
					interpretedValue = Xmls.valueOf(value);
				}
				
				if (argument == null)
				{
					to[key] = interpretedValue;
					continue;
				}
				
				if (argument._format != null)
				{
					interpretedValue = argument._format(interpretedValue);
				}
				
				if (argument._rename)
				{
					key = argument._rename;
				}
				
				to[key] = interpretedValue;
				
			}
			
			for each(argument in _arguments)
			{
				if (argument._validate != null)
				{
					key = argument._rename ? argument._rename : argument._key;
					to[key] = argument._validate(metadata, to[key]);
				}
			}
			
			return to;
		}
		
	}

}
