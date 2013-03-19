package orichalcum.logging 
{

	public interface ILog
	{
		function debug(message:String, ...substitutions):void;
		function info(message:String, ...substitutions):void;
		function warn(message:String, ...substitutions):void;
		function error(message:String, ...substitutions):void;
		function fatal(message:String, ...substitutions):void;
		
		function get debugEnabled():Boolean;
		function get infoEnabled():Boolean;
		function get warnEnabled():Boolean;
		function get errorEnabled():Boolean;
		function get fatalEnabled():Boolean;
	}

}
