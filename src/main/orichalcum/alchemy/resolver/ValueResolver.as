package orichalcum.alchemy.resolver 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.alchemist.Unmapped;
	
	public class ValueResolver implements IDependencyResolver
	{
		
		public function resolves(id:String, mapping:*):Boolean 
		{
			return mapping != Unmapped;
		}
		
		public function resolve(id:String, mapping:*, recipe:Dictionary, alchemist:IAlchemist):* 
		{
			return mapping;
		}
		
	}

}