package orichalcum.reflection.metadata.transform 
{

	public class MetadataArgumentMapper implements IMetadataTransform
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
		
		public function MetadataArgumentMapper(parent:MetadataMapper)
		{
			_parent = parent;
		}
		
		public function to(value:String):MetadataArgumentMapper
		{
			_rename = value;
			return this;
		}
		
		public function format(value:Function):MetadataArgumentMapper
		{
			_format = value;
			return this;
		}
		
		public function implicit(value:*):MetadataArgumentMapper
		{
			_implicit = value;
			return this;
		}
		
		public function fallback(value:Function):MetadataArgumentMapper
		{
			_fallback = value;
			return this;
		}
		
		public function argument(property:String):MetadataArgumentMapper
		{
			return _parent.argument(property);
		}
		
		public function transform(metadata:XML, flyweight:Object = null):*
		{
			return _parent.transform(metadata, flyweight);
		}
		
	}

}
