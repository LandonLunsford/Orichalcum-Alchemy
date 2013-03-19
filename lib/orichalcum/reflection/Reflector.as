package orichalcum.reflection 
{
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import orichalcum.lifecycle.IDisposable;

	public class Reflector implements IDisposable, IReflector
	{
		static private var _instance:Reflector;
		
		static public function getInstance(applicationDomain:ApplicationDomain = null):IReflector
		{
			return _instance ||= new Reflector(applicationDomain);
		}
		
		private var _nativeTypes:RegExp = /^air\.|^fl\.|^flash\.|^flashx\.|^spark\.|^mx\.|^Object$|^Class$|^String$|^Function$|^Array$|^Boolean$|^Number$|^uint$|^int$/;
		private var _primitiveTypes:RegExp = /^Object$|^Class$|^String$|^Function$|^Array$|^Boolean$|^Number$|^uint$|^int/;
		private var _applicationDomain:ApplicationDomain;
		private var _typeDescriptions:Dictionary;
		
		
		public function Reflector(applicationDomain:ApplicationDomain = null)
		{
			_applicationDomain = applicationDomain || ApplicationDomain.currentDomain;
			_typeDescriptions = new Dictionary;
		}
		
		/* INTERFACE orichalcum.lifecycle.IDisposable */
		
		public function dispose():void 
		{
			_nativeTypes = null;
			_primitiveTypes = null;
			_applicationDomain = null;
			_typeDescriptions = null;
		}
		
		/* INTERFACE orichalcum.reflection.IReflector */
		
		public function isNativeType(qualifiedClassName:String):Boolean
		{
			return _nativeTypes.test(qualifiedClassName);
		}
		
		public function isPrimitiveType(qualifiedClassName:String):Boolean
		{
			return _primitiveTypes.test(qualifiedClassName);
		}
		
		public function isComplexType(qualifiedClassName:String):Boolean
		{
			return !isPrimitiveType(qualifiedClassName);
		}
		
		public function isType(qualifiedClassName:String):Boolean 
		{
			return _applicationDomain.hasDefinition(qualifiedClassName);
		}
		
		public function getType(qualifiedClassName:String):Class 
		{
			return _applicationDomain.getDefinition(qualifiedClassName) as Class;
		}
		
		public function getTypeName(classOrInstance:*):String
		{
			return getQualifiedClassName(classOrInstance);
		}
		
		public function getTypeDescription(classOrInstance:*):XML 
		{
			return _typeDescriptions[getQualifiedClassName(classOrInstance)] ||= describeType(classOrInstance);
		}
		
		public function isPrimitive(value:*):Boolean 
		{
			return value is int || value is uint || value is Number || value is Boolean || value is String;
		}
		
	}

}