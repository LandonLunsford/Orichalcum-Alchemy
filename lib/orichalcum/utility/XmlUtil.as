package orichalcum.utility 
{

	public class XmlUtil 
	{
		static private const BOOLEAN_FALSE_DETECTOR:RegExp = /^false$/;
		static private const BOOLEAN_TRUE_DETECTOR:RegExp = /^true$/;
		static private const NUMBER_DETECTOR:RegExp = /^[+-]?(\d+(\.\d*)?|\.\d*)$/;
		
		static public function valueOf(xml:XML):*
		{
			const xmlString:String = xml.toString();
			if (BOOLEAN_FALSE_DETECTOR.test(xmlString)) return false;
			if (BOOLEAN_TRUE_DETECTOR.test(xmlString)) return true;
			if (NUMBER_DETECTOR.test(xmlString)) return Number(xml);
			return xmlString;
		}
		
	}

}