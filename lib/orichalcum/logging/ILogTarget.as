package orichalcum.logging 
{
	
	public interface ILogTarget 
	{
		function log(level:LogLevel, source:Object, message:String, substitutions:Array = null):void;
	}

}