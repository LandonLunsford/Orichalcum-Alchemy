package orichalcum.logging 
{
	import orichalcum.logging.ILogTarget;
	import orichalcum.logging.LogLevel;

	public interface ILog
	{
		function addTarget(target:ILogTarget):void;
		function removeTarget(target:ILogTarget):void;
		
		function get level():LogLevel;
		function set level(value:LogLevel):void;
		
		function get debugEnabled():Boolean;
		function get infoEnabled():Boolean;
		function get warnEnabled():Boolean;
		function get errorEnabled():Boolean;
		function get fatalEnabled():Boolean;
		
		function debug(message:String, ...substitutions):void;
		function info(message:String, ...substitutions):void;
		function warn(message:String, ...substitutions):void;
		function error(message:String, ...substitutions):void;
		function fatal(message:String, ...substitutions):void;
		
	}

}
