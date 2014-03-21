package orichalcum.reflection 
{
	import flash.utils.Dictionary;

	public class Metatag 
	{
		
		private var _arguments:Dictionary;
		private var _implicitArgumentKey:String;
		
		/**
		 * Cases
		 * 1. [Inject("name")]
		 * 2. [Inject("nameA", "nameB", "nameC")]
		 * 3. [Inject("name", booeanFlag)]
		 */
		public function Metatag(metadataDescription:XML, implicitArgumentKey:String, booleanArgumentKeys:Array) 
		{
			_arguments = new Dictionary;
			_implicitArgumentKey = implicitArgumentKey;
			
			const metadataArgumentDescriptions:XMLList = metadataDescription.arg;
			const metadataArgumentDescriptionCount:int = metadataArgumentDescriptions.length();
			if (metadataArgumentDescriptionCount == 1)
			{
				var argumentDescription:XML = metadataArgumentDescriptions[0];
				var argumentKey:String = argumentDescription.@key.toString();
				var argumentValue:String = argumentDescription.@value.toString();
				_arguments[argumentKey.length == 0 ? _implicitArgumentKey : argumentKey] = argumentValue;
			}
			else
			{
				for each(argumentDescription in metadataArgumentDescriptions)
				{
					argumentKey = argumentDescription.@key.toString();
					argumentValue = argumentDescription.@value.toString();
					if (argumentKey.length == 0)
					{
						/*
							Keyless arguments that are not the primary keyless argument are coerced to booleans
							This should not be the case for constructor injection by name thoug...
							[Inject("name", "otherName", "anotherName")]
						*/
						_arguments[argumentValue] = true;
					}
					else
					{
						_arguments[argumentKey] = argumentValue;
					}
				}
			}
		}
		
		public function get arguments():Dictionary
		{
			return _arguments;
		}
		
	}

}