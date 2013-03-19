package orichalcum.logging.target 
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import orichalcum.logging.LogLevel;

	public class FileStreamTarget extends ALogTarget
	{
		private var _fileStream:FileStream;
		private var _logFile:File;
		
		public function FileStreamTarget(logFile:File) 
		{
			if (logFile == null)
				throw new ArgumentError('Argument "logFile" may not be null for FileStreamTarget');
				
			_logFile = logFile;
			_fileStream = new FileStream;
		}
		
		override protected function logMessage(message:String):void 
		{
			_fileStream.open(_logFile, FileMode.APPEND);
			_fileStream.writeUTFBytes(message);
			_fileStream.close();
		}
		
	}

}
