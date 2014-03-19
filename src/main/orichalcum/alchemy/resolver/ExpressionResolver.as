package orichalcum.alchemy.resolver 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;

	public class ExpressionResolver implements IDependencyResolver 
	{
		
		private var expressionQualifier:RegExp = /^{.*}$/;
		private var expressionRemovals:RegExp = /{|}|\s/gm;
		
		public function ExpressionResolver(expressionQualifier:RegExp = null, expressionRemovals:RegExp = null) 
		{
			if (expressionQualifier) this.expressionQualifier = expressionQualifier;
			if (expressionRemovals) this.expressionRemovals = expressionRemovals;
		}
		
		public function resolves(id:String, mapping:*):Boolean 
		{
			return mapping is String && expressionQualifier.test(mapping);
		}
		
		public function resolve(id:String, mapping:*, recipe:Dictionary, alchemist:IAlchemist):* 
		{
			return alchemist.conjure((mapping as String).replace(expressionRemovals, ''), null);
		}
		
	}

}