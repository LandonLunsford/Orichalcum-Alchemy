package orichalcum.alchemy.mapper 
{
	
	public interface IMapper 
	{
		function to(providerValueOrReference:*):IMapper;
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