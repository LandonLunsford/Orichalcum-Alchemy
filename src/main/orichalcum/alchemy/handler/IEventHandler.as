package orichalcum.alchemy.handler 
{
	import flash.events.Event;

	/**
	 * @private
	 */
	public interface IEventHandler
	{
		function get listener():Function;
		function set listener(value:Function):void;
		
		function get targetPath():String;
		
		function get listenerName():String;
		
		function get type():String;
		
		function get useCapture():Boolean;
		
		function get priority():int;
		
		function get stopPropagation():Boolean;
		
		function get stopImmediatePropagation():Boolean;
		
		function get parameters():Array;
		
		function handle(event:Event):void;
		
	}

}