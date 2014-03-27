package orichalcum.reflection.metadata.transform 
{

	public class MetadataArgumentMapper implements IMetadataTransform
	{
		
		internal var _parent:MetadataMapper;
		
		internal var _key:String;
		
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
		internal var _validate:Function;
		
		public function MetadataArgumentMapper(parent:MetadataMapper, key:String)
		{
			_parent = parent;
			_key = key;
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
		
		public function validate(value:Function):MetadataArgumentMapper
		{
			_validate = value;
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
