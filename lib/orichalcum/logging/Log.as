package orichalcum.logging 
{
	import flash.utils.Dictionary;
	import orichalcum.logging.ILogTarget;
	import orichalcum.logging.LogLevel;
	import orichalcum.utility.StringUtil;

	public class Log implements ILog
	{
		static private var _nullLog:ILog;
		
		static public function get nullLog():ILog
		{
			return _nullLog ||= new NullLog;
		}
		
		private var _parent:Log;
		private var _level:LogLevel;
		private var _source:Object;
		private var _targets:Vector.<ILogTarget>;
		
		public function Log(source:Object)
		{
			_level = LogLevel.INFO;
		}
		
		public function extend(source:Object)
		{
			const extension:Log = new Log(source);
			extension._parent = this;
			extension._level = _level;
			return extension;
		}
		
		public function get targets():Vector.<ILogTarget>
		{
			return _targets ||= new Vector.<ILogTarget>;
		}
		
		public function set targets(value:Vector.<ILogTarget>):void
		{
			_targets = value;
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
			if (targets.indexOf(target) < 0)
				targets.push(target);
		}
		
		public function removeTarget(target:ILogTarget):void
		{
			if (!hasTargets) return;
			const index:int = targets.indexOf(target);
			if (index < 0) return;
			targets.splice(index, 1);
		}
		
		
		/* INTERFACE orichalcum.logging.ILogManager */
		
		public function getLogger(source:Object):ILog
		{
			return new Log(source, this);
		}
		
		/* INTERFACE orichalcum.logging.ILogTarget */
		
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
			return level.ordinal <= LogLevel.DEBUG.ordinal;
		}
		
		public function get infoEnabled():Boolean 
		{
			return level.ordinal <= LogLevel.INFO.ordinal;
		}
		
		public function get warnEnabled():Boolean 
		{
			return level.ordinal <= LogLevel.WARN.ordinal;
		}
		
		public function get errorEnabled():Boolean 
		{
			return level.ordinal <= LogLevel.ERROR.ordinal;
		}
		
		public function get fatalEnabled():Boolean 
		{
			return level.ordinal <= LogLevel.FATAL.ordinal;
		}
		
		/* PRIVATE */
		
		private function hasTargets():Boolean
		{
			return _targets && _targets.length;
		}
		
		private function log(level:LogLevel, message:String, substitutions:Array = null):void
		{
			if (hasTargets)
			{
				message = StringUtil.substitute(message, substitutions);
				for each(var target:ILogTarget in _targets)
					target.log(level, _source, message);
				
			}
			_parent && _parent.log(level, _source, message, substitutions);
		}
		
	}

}
