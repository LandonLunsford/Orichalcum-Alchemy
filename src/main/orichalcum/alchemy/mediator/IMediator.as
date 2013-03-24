package orichalcum.alchemy.mediator 
{
	import flash.display.DisplayObject;
	
	public interface IMediator 
	{
		function activate(view:DisplayObject = null):void;
		function deactivate(view:DisplayObject = null):void;
	}

}