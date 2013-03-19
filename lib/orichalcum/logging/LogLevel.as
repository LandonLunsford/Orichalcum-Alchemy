package orichalcum.logging 
{

	public class LogLevel 
	{
		static public const FATAL:LogLevel = new LogLevel('FATAL', 2);
		static public const ERROR:LogLevel = new LogLevel('ERROR', 4);
		static public const WARN:LogLevel = new LogLevel('WARN', 8);
		static public const INFO:LogLevel = new LogLevel('INFO', 16);
		static public const DEBUG:LogLevel = new LogLevel('DEBUG', 32);
		
		private var _ordinal:uint;
		private var _name:String;
		
		public function LogLevel(name:String, ordinal:uint) 
		{
			_name = name;
			_ordinal = ordinal;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get ordinal():uint 
		{
			return _ordinal;
		}
		
		static public function fromString(string:String):LogLevel
		{
			switch (string.toUpperCase())
			{
				case 'FATAL': return FATAL;
				case 'ERROR': return ERROR;
				case 'WARN': return WARN;
				case 'INFO': return INFO;
				case 'DEBUG': return DEBUG;
			}
			throw new ArgumentError;
		}
		
	}

}
