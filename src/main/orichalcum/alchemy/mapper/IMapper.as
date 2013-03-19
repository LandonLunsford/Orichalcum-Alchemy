package orichalcum.alchemy.mapper 
{
	
	public interface IMapper 
	{
		/* Define provider */
		function to(providerValueOrReference:*):IMapper;
		function toValue(value:*):IMapper;
		function toReference(id:String):IMapper;
		function toPrototype(type:Class):IMapper;
		function toSingleton(type:Class):IMapper;
		function toMultiton(type:Class, poolSize:uint):IMapper;
		function asPrototype():IMapper;
		function asSingleton():IMapper;
		function asMultiton(poolSize:uint):IMapper;
		
		/* Define recipe */
		function withConstructorArguments(...args):IMapper;
		function withConstructorArgument(value:*, index:int = -1):IMapper;
		function withProperties(properties:Object):IMapper;
		function withProperty(name:String, value:*):IMapper;
		function withComposer(value:String):IMapper;
		function withDisposer(value:String):IMapper;
		function withBinding(
			type:String
			,listener:String
			,target:String = null
			,useCapture:Boolean = false
			,priority:uint = 0
			,stopPropagation:Boolean = false
			,stopImmediatePropagation:Boolean = false
			):IMapper;
	}

}
