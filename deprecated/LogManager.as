package orichalcum.logging 
{
	import flash.utils.Dictionary;
	import orichalcum.utility.StringUtil;

	public class LogManager implements ILogTarget, ILogFactory
	{
		static private var _instance:LogManager;
		static private var _level:LogLevel;
		static private var _targets:Vector.<ILogTarget>;
		
		static public function getInstance():LogManager
		{
			return _instance ||= new LogManager;
		}
		
		static public function getLogger(source:Object):ILog
		{
			return _instance.getLogger(source);
		}
		
		public function LogManager()
		{
			_targets = new Vector.<ILogTarget>;
			_level = LogLevel.INFO;
		}
		
		public function get level():LogLevel 
		{
			return _level;
		}
		
		public function set level(value:LogLevel):void 
		{
			_level = value;
		}
		
		public function addTarget(target:ILogTarget):void
		{
			if (_targets.indexOf(target) < 0)
				_targets.push(target);
		}
		
		public function get debugEnabled():Boolean 
		{
			return _manager.level.ordinal <= LogLevel.DEBUG.ordinal;
		}
		
		public function get infoEnabled():Boolean 
		{
			return _manager.level.ordinal <= LogLevel.INFO.ordinal;
		}
		
		public function get warnEnabled():Boolean 
		{
			return _manager.level.ordinal <= LogLevel.WARN.ordinal;
		}
		
		public function get errorEnabled():Boolean 
		{
			return _manager.level.ordinal <= LogLevel.ERROR.ordinal;
		}
		
		public function get fatalEnabled():Boolean 
		{
			return _manager.level.ordinal <= LogLevel.FATAL.ordinal;
		}
		
		/* INTERFACE orichalcum.logging.ILogManager */
		
		public function getLogger(source:Object):ILog
		{
			return new Log(source, this);
		}
		
		/* INTERFACE orichalcum.logging.ILogTarget */
		
		public function log(level:LogLevel, source:Object, message:String, substitutions:Array = null):void 
		{
			if (level.ordinal <= level.ordinal && _targets && _targets.length)
			{
				message = StringUtil.substitute(message, substitutions);

				for each(var target:ILogTarget in _targets)
					target.log(level, source, message);
			}
		}
		
	}

}
