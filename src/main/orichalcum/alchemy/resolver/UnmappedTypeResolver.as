package orichalcum.alchemy.resolver 
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedSuperclassName;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.alchemist.Unmapped;
	import orichalcum.reflection.IReflector;
	import orichalcum.reflection.Reflector;
	
	public class UnmappedTypeResolver implements IDependencyResolver
	{
		private var _reflector:IReflector;
		
		public function UnmappedTypeResolver(reflector:IReflector = null)
		{
			_reflector = reflector ? reflector : Reflector.getInstance();
		}
		
		public function resolves(id:String, mapping:*):Boolean 
		{
			return _reflector.isType(id)
				// HOTFIX for mapping interfaces to a value
				// _reflector.isInterface(Class)
				&& getQualifiedSuperclassName(_reflector.getType(id)) != null
		}
		
		public function resolve(id:String, mapping:*, recipe:Dictionary, alchemist:IAlchemist):* 
		{
			return alchemist.create(_reflector.getType(id), recipe, id);
		}
		
	}

}