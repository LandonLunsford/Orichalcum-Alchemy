package orichalcum.reflection.metadata.transform 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.utility.Xmls;

	public class MetadataMapper implements IMetadataTransform
	{
		
		private var _mappings:Dictionary;
		private var _currentMapping:MetadataMapping;
		
		public function MetadataMapper()
		{
			_mappings = new Dictionary;
		}
		
		public function map(property:String):MetadataMapping
		{
			return _mappings[property] = new MetadataMapping(this);
		}
		
		public function transform(metadata:XML, flyweight:Object = null):* 
		{
			const to:Object = flyweight ? flyweight : {};
				
			for each(var argument:XML in metadata.arg)
			{
				var key:String = argument.@key.toString();
				var value:String = argument.@value.toString();
				
				var interpretedValue:*;
				var mapping:MetadataMapping;
				
				if (key.length == 0)
				{
					mapping = _mappings[value];
					interpretedValue = mapping && mapping._implicit
						? mapping._implicit
						: true;
						
					key = value;
				}
				else
				{
					mapping = _mappings[key];
					interpretedValue = Xmls.valueOf(value);
				}
				
				if (mapping == null)
				{
					to[key] = interpretedValue;
					continue;
				}
				
				if (mapping._format != null)
				{
					interpretedValue = mapping._format(to, key, interpretedValue);
				}
				
				if (interpretedValue == null && mapping._implicit)
				{
					mapping._fallback(metadata);
				}
				
				if (mapping._rename)
				{
					key = mapping._rename;
				}
				
				to[key] = interpretedValue;
				
			}
			return to;
		}
		
	}

}