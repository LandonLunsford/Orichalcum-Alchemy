package orichalcum.logging 
{

	public interface ILogFormatter 
	{
		function format(level:LogLevel, source:Object, message:String):String;
		function get showTime():Boolean;
		function set showTime(value:Boolean):void;
		function get showLevel():Boolean;
		function set showLevel(value:Boolean):void;
		function get showSource():Boolean;
		function set showSource(value:Boolean):void;
		function get showMessage():Boolean;
		function set showMessage(value:Boolean):void;
		/*
		 * function get timeFormat:String = 'mm:dd:yy'
		 * function set timeFormat(value:String):void;
		 * 
		 * timeFormat 'hh:mm:ss:fff
		 * 
		 * 
		 */
	}

}