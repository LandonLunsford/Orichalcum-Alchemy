package orichalcum.utility 
{

	public class StringUtil 
	{
		
		static private const DIGIT_STRINGS:Vector.<String> = new <String>['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
		
		static public function digitString(digit:int):String
		{
			return DIGIT_STRINGS[digit];
		}
		
		static public function padLeft(string:String, padding:String = ' ', totalLength:int = 0):String
		{
			if (totalLength == 0) return string;
				
			while (string.length < totalLength)
				string = padding + string;
				
			return string;
		}
		
		static public function padRight(string:String, padding:String = ' ', totalLength:int = 0):String
		{
			if (totalLength == 0) return string;
				
			while (string.length < totalLength)
				string = string + padding;
				
			return string;
		}
		
		static public function substitute(string:String, ...substitutions):String
		{
			if (!substitutions || substitutions.length == 0)
				return string;
				
			return substitutions[0] is Array
				? _substitute(string, substitutions[0])
				: _substitute(string, substitutions);
		}
		
		static private function _substitute(string:String, substitutions:Array):String
		{
			for (var i:int = 0; i < substitutions.length; i++)
			{
				string = string.replace(new RegExp('\\{' + i + '\\}', 'g'), substitutions[i]);
			}
			return string;
		}
		
	}

}