package orichalcum.alchemy.language.xmltag 
{
	
	public interface IMapXmltag 
	{
		function get name():String
		function set name(value:String):void;
		
		function get id():String;
		function set id(value:String):void;
		
		function get to():String;
		function set to(value:String):void;
		
		function get toValue():String;
		function set toValue(value:String):void;
		
		function get toReference():String;
		function set toReference(value:String):void;
		
		function get toProvider():String;
		function set toProvider(value:String):void;
		
		function get toPrototype():String;
		function set toPrototype(value:String):void;
		
		function get toSingleton():String;
		function set toSingleton(value:String):void;
		
		function get toPool():String;
		function set toPool(value:String):void;
		
		function get toFactory():String;
		function set toFactory(value:String):void;
		
		function get factoryMethodDelimiter():String;
		function set factoryMethodDelimiter(value:String):void;
	}

}