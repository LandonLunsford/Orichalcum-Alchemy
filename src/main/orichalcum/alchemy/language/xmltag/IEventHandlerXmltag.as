package orichalcum.alchemy.language.xmltag 
{
	
	public interface IEventHandlerXmltag 
	{
		function get name():String;
		function set name(value:String):void;
		
		function get priority():String;
		function set priority(value:String):void;
		
		function get useCapture():String;
		function set useCapture(value:String):void;
		
		function get stopPropagation():String;
		function set stopPropagation(value:String):void;
		
		function get stopImmediatePropagation():String;
		function set stopImmediatePropagation(value:String):void;
	}

}