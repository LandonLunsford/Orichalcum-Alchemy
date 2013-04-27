package orichalcum.alchemy.language.metatag 
{

	public interface IEventHandlerMetatag 
	{
		function get name():String;
		function get eventKey():String;
		function get targetKey():String;
		function get parametersKey():String;
		function get priorityKey():String;
		function get useCaptureKey():String;
		function get stopPropagationKey():String;
		function get stopImmediatePropagationKey():String;
	}

}
