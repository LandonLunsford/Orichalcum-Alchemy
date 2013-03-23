package orichalcum.alchemy.mapper 
{
	
	public interface IMapper 
	{
		function to(providerValueOrReference:*):IMapper;
		function toValue(value:*):IMapper;
		function toReference(id:String):IMapper;
		function toPrototype(type:Class):IMapper;
		function toSingleton(type:Class):IMapper;
		function toMultiton(type:Class, poolSize:uint):IMapper;
		function asPrototype():IMapper;
		function asSingleton():IMapper;
		function asMultiton(poolSize:uint):IMapper;
		
		function withConstructorArguments(...args):IMapper;
		function withConstructorArgument(value:*, index:int = -1):IMapper;
		function withProperties(properties:Object):IMapper;
		function withProperty(name:String, value:*):IMapper;
		function withPostConstruct(value:String):IMapper;
		function withPreDestroy(value:String):IMapper;
		function withEventHandler(
			type:String
			,listener:String
			,target:String = null
			,useCapture:Boolean = false
			,priority:uint = 0
			,stopPropagation:Boolean = false
			,stopImmediatePropagation:Boolean = false
			):IMapper;
			
		function withMediator(mediatorInstanceClassOrId:*):IMapper;
	}

}
