package orichalcum.alchemy.ingredient.processor 
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.ingredient.factory.signalHandler;
	import orichalcum.alchemy.ingredient.metatag.SignalHandlerMetatag;
	import orichalcum.alchemy.ingredient.SignalHandler;
	import orichalcum.signals.ISignal;
	import orichalcum.utility.ObjectUtil;

	public class SignalHandlerProcessor implements IIngredientProcessor
	{
		private var _metatagName:String;
		private var _ingredientId:String = 'signalHandlers';
		
		public function SignalHandlerProcessor(metatagName:String = 'SignalHandler') 
		{
			_metatagName = metatagName;
		}
		
		public function introspect(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void
		{
			for each(var signalHandlerMetadata:XML in typeDescription.factory[0].method.metadata.(@name == _metatagName))
			{
				var metatag:SignalHandlerMetatag = new SignalHandlerMetatag(typeName, signalHandlerMetadata);
				(recipe[_ingredientId] ||= []).push(signalHandler(metatag.signalPath, metatag.slotPath, metatag.once));
			}
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			if (ingredient is SignalHandler)
			{
				(recipe[_ingredientId] ||= []).push(ingredient);
			}
		}
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			for each(var ingredient:* in childRecipe[_ingredientId])
			{
				(parentRecipe[_ingredientId] ||= []).push(ingredient);
			}
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			for each(var handler:SignalHandler in recipe[_ingredientId])
			{
				var target:Object = ObjectUtil.find(instance, handler.signalPath);
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