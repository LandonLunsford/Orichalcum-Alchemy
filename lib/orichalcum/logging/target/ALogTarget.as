package orichalcum.logging.target 
{
	import flash.errors.IllegalOperationError;
	import orichalcum.logging.format.StandardFormatter;
	import orichalcum.logging.ILogFormatter;
	import orichalcum.logging.ILogTarget;
	import orichalcum.logging.LogLevel;

	public class ALogTarget implements ILogTarget
	{
		private var _formatter:ILogFormatter;
		
		public function ALogTarget(formatter:ILogFormatter = null)
		{
			this.formatter = formatter || new StandardFormatter;
		}
		
		public function get formatter():ILogFormatter 
		{
			return _formatter;
		}
		
		public function set formatter(value:ILogFormatter):void 
		{
			_formatter = value;
		}
		
		/* INTERFACE orichalcum.logging.ILogTarget */
		
		public function log(level:LogLevel, source:Object, message:String, substitutions:Array = null):void 
		{
			logMessage(formatter.format(level, source, message));
		}
		
		protected function logMessage(message:String):void
		{
			throw new IllegalOperationError('AbstractTarget is an abstract class and its "log" function must be overridden');
		}
		
	}

}
