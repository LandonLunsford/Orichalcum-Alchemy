package orichalcum.alchemy.extension.mediation 
{
	import flash.display.DisplayObject;
	
	public interface IMediator 
	{
		function onActivate(view:*):void;
		function onDeactivate(view:*):void;
	}

}