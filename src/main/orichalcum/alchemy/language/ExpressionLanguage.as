package orichalcum.alchemy.language 
{

	public class ExpressionLanguage
	{
		private var _expressionQualifier:RegExp;
		private var _expressionRemovals:RegExp;
		
		public function ExpressionLanguage(expressionQualifier:RegExp = null, expressionRemovals:RegExp = null) 
		{
			_expressionQualifier = expressionQualifier || /^{.*}$/;
			_expressionRemovals = expressionRemovals || /{|}|\s/gm;
		}
		
		public function get expressionQualifier():RegExp 
		{
			return _expressionQualifier;
		}
		
		public function set expressionQualifier(value:RegExp):void 
		{
			_expressionQualifier = value;
		}
		
		public function get expressionRemovals():RegExp 
		{
			return _expressionRemovals;
		}
		
		public function set expressionRemovals(value:RegExp):void 
		{
			_expressionRemovals = value;
		}
		
	}

}