package orichalcum.reflection 
{
	import orichalcum.lifecycle.IDisposable;
	
	public interface IReflector
	{
		function isType(qualifiedClassName:String):Boolean;
		function isPrimitiveType(qualifiedClassName:String):Boolean;
		function isComplexType(qualifiedClassName:String):Boolean;
		function isNativeType(qualifiedClassName:String):Boolean;
		
		function getType(qualifiedClassName:String):Class;
		function getTypeName(classOrInstance:*):String;
		function getTypeDescription(classOrInstance:*):XML;
		
		function isPrimitive(value:*):Boolean;
		
		//function implementsOrExtends(classOrInstanceA:*, superclassOrInterface:*):Boolean;
		//function getAncestors(type:Class, classNameFilter:RegExp = null):XMLList;
	}

}