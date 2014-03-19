package orichalcum.alchemy.resolver 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.alchemist.Unmapped;
	import orichalcum.reflection.IReflector;
	import orichalcum.reflection.Reflector;
	
	public class ProviderlessTypeResolver implements IDependencyResolver
	{
		private var _reflector:IReflector;
		
		public function ProviderlessTypeResolver(reflector:IReflector = null)
		{
			_reflector = reflector ? reflector : Reflector.getInstance();
		}
		
		public function resolves(id:String, mapping:*):Boolean 
		{
			return _reflector.isType(id);
		}
		
		public function resolve(id:String, mapping:*, recipe:Dictionary, alchemist:IAlchemist):* 
		{
			return alchemist.create(_reflector.getType(id), recipe, id);
		}
		
	}

}