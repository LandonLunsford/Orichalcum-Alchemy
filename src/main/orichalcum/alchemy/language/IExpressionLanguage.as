package orichalcum.alchemy.language 
{

	public interface IExpressionLanguage 
	{
		function get expressionQualifier():RegExp;
		function set expressionQualifier(value:RegExp):void;
		
		function get expressionRemovals():RegExp;
		function set expressionRemovals(value:RegExp):void;
	}

}