package orichalcum.logging.target 
{
	import orichalcum.logging.ILogFormatter;
	import orichalcum.logging.LogLevel;

	public class TraceTarget extends ALogTarget
	{
		
		public function TraceTarget(formatter:ILogFormatter = null)
		{
			super(formatter);
		}
		
		/* INTERFACE orichalcum.logging.ILogTarget */
		
		override protected function logMessage(message:String):void 
		{
			trace(message);
		}
		
	}

}
