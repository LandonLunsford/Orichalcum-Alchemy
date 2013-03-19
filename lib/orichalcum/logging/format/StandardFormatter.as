package orichalcum.logging.format 
{
	import flash.filesystem.File;
	import flash.utils.getQualifiedClassName;
	import mx.utils.StringUtil;
	import orichalcum.logging.ILogFormatter;
	import orichalcum.logging.LogLevel;

	public class StandardFormatter extends ALogFormatter
	{
		
		override public function format(level:LogLevel, source:Object, message:String):String 
		{
			var levelName:String = StringUtil.substitute('{0}', level.name);
			while (levelName.length < 6) levelName += ' ';
			const sourceName:String = getQualifiedClassName(source);
			return StringUtil.substitute('{0} {1}[{2}] {3}' + File.lineEnding, formattedTime, levelName, sourceName, message);
		}
		
		private function get formattedTime():String
		{
			if (!showTime) return '';
			var date:Date = new Date;
			var formattedTime:String = StringUtil.substitute('{0}:{1}:{2}:{3}', date.hours, date.minutes, date.seconds, date.milliseconds);
			while (formattedTime.length < 12) formattedTime += '0';
			return formattedTime;
		}
	}

}
