package orichalcum.alchemy.language.bundle 
{
	import orichalcum.alchemy.language.IExpressionLanguage;
	import orichalcum.alchemy.language.IMetatagLanguage;
	import orichalcum.alchemy.language.IXmltagLanguage;
	
	public interface ILanguageBundle 
	{
		function get expressionLanguage():IExpressionLanguage;
		function get metatagLanguage():IMetatagLanguage;
		function get xmltagLanguage():IXmltagLanguage;
	}

}