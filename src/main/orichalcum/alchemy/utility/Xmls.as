package orichalcum.alchemy.utility 
{
	import flash.utils.Dictionary;
	
	public class Xmls 
	{
		
		static private var _parsersByType:Dictionary = new Dictionary;
		{
			_parsersByType[Boolean] = function(value:String):Boolean { return value == 'true'; };
			_parsersByType[Array] = function(value:String):Array { return value.split(','); };
			_parsersByType[Number] = function(value:String):Number { return Number(value); };
			_parsersByType[int] = function(value:String):int { return int(value); };
			_parsersByType[uint] = function(value:String):uint { return uint(value); };
			_parsersByType[String] = function(value:String):String { return String(value); };
			_parsersByType[Object] = function(value:String):String { return value; }; // want json parse
		}
		
		static public function parse(value:*, type:Class):*
		{
			if (type in _parsersByType)
				return _parsersByType[type](value);
				
			throw new ArgumentError();
		}
		
		static public function valueOf(value:*):*
		{
			if (value == 'true') return true;
			if (value == 'false') return false;
			if (!isNaN(value)) return Number(value);
			return value;
		}
		
	}

}