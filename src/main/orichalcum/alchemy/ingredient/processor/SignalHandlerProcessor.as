package orichalcum.alchemy.ingredient.processor 
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.ingredient.factory.signalHandler;
	import orichalcum.alchemy.ingredient.SignalHandler;
	import orichalcum.reflection.metadata.transform.IMetadataTransform;
	import orichalcum.reflection.metadata.transform.MetadataMapper;
	import orichalcum.signals.ISignal;
	import orichalcum.utility.Objects;
	import orichalcum.utility.Strings;

	public class SignalHandlerProcessor implements IIngredientProcessor
	{
		private var _metatagName:String;
		private var _ingredientId:String = 'signalHandlers';
		private var _signalMapper:IMetadataTransform = new MetadataMapper()
			.hostname('slotPath')
			.argument('signal')
				.to('signalPath')
				.validate(function(metadata:XML, value:*):* {
					if (!Strings.isNullOrEmpty(value)) return value;
					const hostname:String = metadata.parent().@name.toString();
					const possibleSignalPath:Array = hostname.split('_');
					if (possibleSignalPath.length < 2)
						throw new ArgumentError(Strings.substitute(
							'Argument "{}" not found on metatag "[{}]" for function "{}". Also the host function name does not resemble a path in the form "path_to_signal".',
							'signal', _metatagName, hostname));
					return possibleSignalPath.join('.');
				})
		
		public function SignalHandlerProcessor(metatagName:String = 'SignalHandler') 
		{
			_metatagName = metatagName;
		}
		
		public function introspect(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void
		{
			for each(var metadata:XML in typeDescription.factory[0].method.metadata.(@name == _metatagName))
			{
				(recipe[_ingredientId] ||= []).push(_signalMapper.transform(metadata, new SignalHandler(null, null)));
			}
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			if (ingredient is SignalHandler)
			{
				(recipe[_ingredientId] ||= []).push(ingredient);
			}
		}
		
		public function inherit(to:Dictionary, from:Dictionary):void 
		{
			for each(var ingredient:* in from[_ingredientId])
			{
				(to[_ingredientId] ||= []).push(ingredient);
			}
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			for each(var handler:SignalHandler in recipe[_ingredientId])
			{
				var target:Object = Objects.find(instance, handler.signalPath);
				var targetAsSignal:ISignal = target as ISignal;
				
				if (targetAsSignal == null)
				{
					
					/*
						Metatag argument key "signal" was not defined
						Also, the slot name did not have a name like the following:
						signalHost_signalName
					 */
					if (target === instance)
						throw new AlchemyError('Class "{}" must implement "{}" in order to have a signal handler with no signal path specified.', getQualifiedClassName(instance), getQualifiedClassName(ISignal));
					
						
					/*
						Fallback:
						Try to conjure the signalPath
					 */
					targetAsSignal = alchemist.conjure(handler.signalPath) as ISignal;
					
					/*
						Case:
						[SignalHandler(signal="incorrect.path.to.signal")]
						alchemist.map(A).to(provider(B)).add(signalHandler('incorect.path.to.signal', 'slotName'));
					 */
					throw new AlchemyError('Variable or child named "{}" could not be found on class "{}". Check to make sure that the signal is public and the named correctly.', handler.signalPath, getQualifiedClassName(instance));
				}
				
				handler.bind(targetAsSignal, instance[handler.slotPath]);
			}
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			for each(var handler:SignalHandler in recipe[_ingredientId])
			{
				handler.isBound && handler.unbind();
			}
		}
		
		public function provide(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			/**
			 * Do nothing
			 */
		}
		
		public function configure(xml:XML, alchemist:IAlchemist):void 
		{
			/*
				Parse XML config
			 */
		}
		
	}

}