package orichalcum.alchemy.handler 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public interface IEventHandler
	{
		function get listener():Function;
		function set listener(value:Function):void;
		
		function get targetPath():String;
		function set targetPath(value:String):void;
		
		function get listenerName():String;
		function set listenerName(value:String):void;
		
		function get type():String;
		function set type(value:String):void;
		
		function get useCapture():Boolean;
		function set useCapture(value:Boolean):void;
		
		function get priority():int;
		function set priority(value:int):void;
		
		function get stopPropagation():Boolean;
		function set stopPropagation(value:Boolean):void;
		
		function get stopImmediatePropagation():Boolean;
		function set stopImmediatePropagation(value:Boolean):void;
		
		function get parameters():Array;
		function set parameters(value:Array):void;
		
		function handle(event:Event):void;
		
	}

}