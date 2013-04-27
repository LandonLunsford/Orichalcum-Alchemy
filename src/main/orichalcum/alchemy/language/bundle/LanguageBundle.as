package orichalcum.alchemy.language.bundle 
{
	import orichalcum.alchemy.language.ExpressionLanguage;
	import orichalcum.alchemy.language.MetatagLanguage;
	import orichalcum.alchemy.language.XmltagLanguage;
	
	public class LanguageBundle
	{
		private var _expressionLanguage:ExpressionLanguage;
		private var _metatagLanguage:MetatagLanguage;
		private var _xmltagLanguage:XmltagLanguage;
		
		public function LanguageBundle()
		{
			_expressionLanguage = new ExpressionLanguage;
			_metatagLanguage = new MetatagLanguage;
			_xmltagLanguage = new XmltagLanguage;
		}
		
		public function get expressionLanguage():ExpressionLanguage 
		{
			return _expressionLanguage;
		}
		
		public function get metatagLanguage():MetatagLanguage 
		{
			return _metatagLanguage;
		}
		
		public function get xmltagLanguage():XmltagLanguage 
		{
			return _xmltagLanguage;
		}
		
	}

}
