package orichalcum.logging.target 
{
	import flash.text.TextField;
	import orichalcum.logging.ILogFormatter;
	import orichalcum.logging.ILogTarget;
	import orichalcum.logging.LogLevel;

	public class TextFieldTarget extends ALogTarget
	{
		
		private var _textField:TextField;
		
		public function TextFieldTarget(textField:TextField, formatter:ILogFormatter = null)
		{
			super(formatter);
			_textField = textField;
		}
		
		/* INTERFACE orichalcum.logging.ILogTarget */
		
		override protected function logMessage(message:String):void 
		{
			_textField && _textField.appendText(message);
		}
		
	}

}
