package orichalcum.logging 
{
	import flash.utils.getTimer;
	import orichalcum.utility.StringUtil;

	internal class Log implements ILog
	{
		private var _source:Object;
		private var _manager:LogManager;
		
		public function Log(source:Object, manager:LogManager)
		{
			_source = source;
			_manager = manager;
		}
		
		/* INTERFACE orichalcum.logging.ILog */
		
		public function debug(message:String, ...substitutions):void 
		{
			log(LogLevel.DEBUG, message, substitutions);
		}
		
		public function info(message:String, ...substitutions):void 
		{
			log(LogLevel.INFO, message, substitutions);
		}
		
		public function warn(message:String, ...substitutions):void 
		{
			log(LogLevel.WARN, message, substitutions);
		}
		
		public function error(message:String, ...substitutions):void 
		{
			log(LogLevel.ERROR, message, substitutions);
		}
		
		public function fatal(message:String, ...substitutions):void 
		{
			log(LogLevel.FATAL, message, substitutions);
		}
		
		public function get debugEnabled():Boolean 
		{
			return _manager.debugEnabled;
		}
		
		public function get infoEnabled():Boolean 
		{
			return _manager.infoEnabled;
		}
		
		public function get warnEnabled():Boolean 
		{
			return _manager.warnEnabled;
		}
		
		public function get errorEnabled():Boolean 
		{
			return _manager.errorEnabled;
		}
		
		public function get fatalEnabled():Boolean 
		{
			return _manager.fatalEnabled;
		}
		
		/* PRIVATE */
		
		private function log(level:LogLevel, message:String, substitutions:Array = null):void
		{
			_manager.log(level, _source, message, substitutions);
		}
		
	}

}
