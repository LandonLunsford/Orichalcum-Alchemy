package orichalcum.alchemy.mapper 
{
	
	public interface IAlchemyMapper 
	{
		function to(providerValueOrReference:*):IAlchemyMapper;
		function toValue(value:*):IAlchemyMapper;
		function toReference(id:*):IAlchemyMapper;
		function toPrototype(type:Class):IAlchemyMapper;
		function toSingleton(type:Class):IAlchemyMapper;
		function toPool(type:Class):IAlchemyMapper;
		function asPrototype():IAlchemyMapper;
		function asSingleton():IAlchemyMapper;
		function asPool():IAlchemyMapper;
		
		function withConstructorArguments(...args):IAlchemyMapper;
		function withConstructorArgument(value:*, index:int = -1):IAlchemyMapper;
		function withProperties(properties:Object):IAlchemyMapper;
		function withProperty(name:String, value:*):IAlchemyMapper;
		function withPostConstruct(value:String):IAlchemyMapper;
		function withPreDestroy(value:String):IAlchemyMapper;
		function withEventHandler(
			type:String
			,listener:String
			,target:String = null
			,useCapture:Boolean = false
			,priority:uint = 0
			,stopPropagation:Boolean = false
			,stopImmediatePropagation:Boolean = false
			):IAlchemyMapper;
	}

}
