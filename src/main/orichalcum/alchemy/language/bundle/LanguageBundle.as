package orichalcum.alchemy.language.bundle 
{
	import orichalcum.alchemy.language.ExpressionLanguage;
	import orichalcum.alchemy.language.IExpressionLanguage;
	import orichalcum.alchemy.language.IMetatagLanguage;
	import orichalcum.alchemy.language.IXmltagLanguage;
	import orichalcum.alchemy.language.MetatagLanguage;
	import orichalcum.alchemy.language.XmltagLanguage;
	
	public class LanguageBundle implements ILanguageBundle
	{
		private var _expressionLanguage:IExpressionLanguage;
		private var _metatagLanguage:IMetatagLanguage;
		private var _xmltagLanguage:IXmltagLanguage;
		
		public function LanguageBundle()
		{
			_expressionLanguage = new ExpressionLanguage;
			_metatagLanguage = new MetatagLanguage;
			_xmltagLanguage = new XmltagLanguage;
		}
		
		/* INTERFACE orichalcum.alchemy.language.bundle.ILanguageBundle */
		
		public function get expressionLanguage():IExpressionLanguage 
		{
			return _expressionLanguage;
		}
		
		public function get metatagLanguage():IMetatagLanguage 
		{
			return _metatagLanguage;
		}
		
		public function get xmltagLanguage():IXmltagLanguage 
		{
			return _xmltagLanguage;
		}
		
	}

}
