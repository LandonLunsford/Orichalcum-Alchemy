package orichalcum.alchemy.ingredient.metatag 
{
	import orichalcum.alchemy.error.AlchemyError;

	public class SignalHandlerMetatag 
	{
		
		private const MULTIPLE_METATAGS_ERROR_MESSAGE:String = 'Multiple "[{}]" metatags defined in class "{}".';
		private const MULTIPLE_METATAGS_FOR_MEMBER_ERROR_MESSAGE:String = 'Multiple "[{}]" metatags defined for member "{}" of class "{}".';
		private const MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE:String = 'Multiple "{}" attributes found on "[{}]" metatag for member "{}" in class "{}".';
		private const NO_REQUIRED_METATAG_ATTRIBUTE_ERROR_MESSAGE:String = 'Required attribute "{}" not found on "[{}]" metatag for "{}" in class "{}".';
		
		private var hostName:String;
		private var metatag:XML;
		private var signalArgumentKey:String = 'signal';
		private var onceArgumentKey:String = 'once';
		
		public function SignalHandlerMetatag(hostName:String, metatag:XML) 
		{
			this.hostName = hostName;
			this.metatag = metatag;
		}
		
		public function get slotPath():String
		{
			return metatag.parent().@name.toString();
		}
		
		public function get signalPath():String
		{
			/*
				Usages:
				
				[SignalHandler]
				public function target_signal():void{}
				
				[SignalHandler("signalPath")]
				public function anything():void{}
				
				[SignalHandler("SignalClass")]
				public function anything():void{}
				
				[SignalHandler("signalBeanName")]
				public function anything():void{}
				
				[SignalHandler(signal="signalPath", once)]
				public function anything():void{}
				
				[SignalHandler(signal="signalPath", once="true|false")]
				public function anything():void{}
			*/
			
			const metatagArguments:XMLList = metatag.arg;
			const metatagArgumentCount:int = metatagArguments.length();
			const signalArguments:XMLList = metatagArguments.(@key == signalArgumentKey);
			const signalArgumentCount:int = signalArguments.length();
			
			/*
				Is there multiple "signal" arguments passed to the [SignalHandler] metatag
			 */
			if (signalArgumentCount > 1) 
				throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, signalArgumentKey, metatag.@name, slotPath, hostName);
			
			/*
				signal argument is explicitely set
			 */
			if (signalArgumentCount > 0)
				return signalArguments[0].@value[0].toString();
				
			/*
				Does the metatag have one keyless argument?
				If so use that as the signal path
				e.g. [SignalHandler("path.to.signal")]
			 */
			if (metatagArgumentCount == 1)
			{
				var possibleSignalPath:String = metatagArguments[0].@value.toString();
				if (possibleSignalPath != onceArgumentKey)
					return possibleSignalPath;
			}
			
			/*
				Is the path implicit?
			 */
			const implicitSignalPathSegments:Array = slotPath.split('_');
			if (implicitSignalPathSegments.length > 1)
				return implicitSignalPathSegments.join('.');
				
			throw new AlchemyError(NO_REQUIRED_METATAG_ATTRIBUTE_ERROR_MESSAGE, signalArgumentKey, metatag.@name, hostName);
		}
		
		public function get once():Boolean
		{
			const metatagArguments:XMLList = metatag.arg;
			const onceArguments:XMLList = metatagArguments.(@key == onceArgumentKey);
			const onceArgumentCount:int = onceArguments.length();
			
			/*
				Is there multiple "once" arguments passed to the [SignalHandler] metatag
			 */
			if (onceArgumentCount > 1)
				throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, onceArgumentKey, metatag.@name, slotPath, hostName);
			
			/*
				Once is set true in these cases
				[SignalHandler(once)]
				[SignalHandler(once="true")]
			 */
			const keylessArguments:XMLList = metatagArguments.(@key == '');
			return (keylessArguments.(@value == onceArgumentKey)).length() > 0
				|| onceArguments.length() > 0
				&& onceArguments.@value.toString() == 'true';
		}
		
	}

}