package orichalcum.logging.format 
{
	import flash.errors.IllegalOperationError;
	import orichalcum.logging.ILogFormatter;
	import orichalcum.logging.LogLevel;

	public class ALogFormatter implements ILogFormatter
	{
		private var _showTime:Boolean;
		private var _showLevel:Boolean;
		private var _showSource:Boolean;
		private var _showMessage:Boolean;
		
		public function ALogFormatter(showTime:Boolean = true, showLevel:Boolean = true, showSource:Boolean = true, showMessage:Boolean = true) 
		{
			this.showTime = showTime;
			this.showLevel = showLevel;
			this.showSource = showSource;
			this.showMessage = showMessage;
		}
		
		/* INTERFACE orichalcum.logging.ILogFormatter */
		
		public function format(level:LogLevel, source:Object, message:String):String 
		{
			throw new IllegalOperationError('AbstractFormatter is an abstract class and its "format" function must be overridden');
		}
		
		/* INTERFACE orichalcum.logging.ILogFormatter */
		
		public function get showTime():Boolean 
		{
			return _showTime;
		}
		
		public function set showTime(value:Boolean):void 
		{
			_showTime = value;
		}
		
		public function get showLevel():Boolean 
		{
			return _showLevel;
		}
		
		public function set showLevel(value:Boolean):void 
		{
			_showLevel = value;
		}
		
		public function get showSource():Boolean 
		{
			return _showSource;
		}
		
		public function set showSource(value:Boolean):void 
		{
			_showSource = value;
		}
		
		public function get showMessage():Boolean 
		{
			return _showMessage;
		}
		
		public function set showMessage(value:Boolean):void 
		{
			_showMessage = value;
		}
		

		
	}

}
