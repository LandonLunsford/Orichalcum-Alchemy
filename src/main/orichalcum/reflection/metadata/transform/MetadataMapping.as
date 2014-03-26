package orichalcum.reflection.metadata.transform 
{

	public class MetadataMapping implements IMetadataTransform
	{
		
		internal var _parent:MetadataMapper;
		
		/**
		 * New name on target object
		 */
		internal var _rename:String;
		
		/**
		 * Formating function
		 */
		internal var _format:Function;
		
		/**
		 * Value if found to be "keyless"
		 */
		internal var _implicit:* = undefined;
		
		/**
		 * Formating function
		 */
		internal var _fallback:Function;
		
		public function MetadataMapping(parent:MetadataMapper)
		{
			_parent = parent;
		}
		
		public function to(value:String):MetadataMapping
		{
			_rename = value;
			return this;
		}
		
		public function format(value:Function):MetadataMapping
		{
			_format = value;
			return this;
		}
		
		public function implicit(value:*):MetadataMapping
		{
			_implicit = value;
			return this;
		}
		
		public function fallback(value:Function):MetadataMapping
		{
			_fallback = value;
			return this;
		}
		
		public function map(property:String):MetadataMapping
		{
			return _parent.map(property);
		}
		
		public function transform(metadata:XML, flyweight:Object = null):*
		{
			return _parent.transform(metadata, flyweight);
		}
		
	}

}