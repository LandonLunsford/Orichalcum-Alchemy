package orichalcum.alchemy.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.ingredient.PreDestroy;

	public class PreDestroyProcessor implements IIngredientProcessor
	{
		private var _metatagName:String;
		private var _ingredientId:String = 'preDestroy';
		
		public function PreDestroyProcessor(metatagName:String = 'PreDestroy') 
		{
			_metatagName = metatagName;
		}
		
		public function introspect(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void
		{
			const methods:XMLList = typeDescription.factory[0].method;
			const preDestroys:XMLList = methods.(@declaredBy == typeName).metadata.(@name == _metatagName);
			
			if (preDestroys.length() > 1)
			{
				throw new AlchemyError('Multiple "[{}]" metatags defined in class "{}".', _metatagName, typeName);
			}
				
			if (preDestroys.length() > 0)
			{
				recipe[_ingredientId] = preDestroys[0].parent().@name.toString();
			}
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			const preDestroy:PreDestroy = ingredient as PreDestroy;
			if (preDestroy)
			{
				recipe[_ingredientId] = preDestroy.name;
			}
		}
		
		public function inherit(parent:Dictionary, child:Dictionary):void 
		{
			if (_ingredientId in child)
			{
				parent[_ingredientId] = child[_ingredientId];
			}
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			/**
			 * Does nothing
			 */
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			recipe[_ingredientId] && (instance[recipe[_ingredientId]] as Function).call(instance);
		}
		
		public function provide(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			/**
			 * Do nothing
			 */
		}
		
		public function configure(xml:XML, alchemist:IAlchemist):void 
		{
			// process xml bean
		}
	}

}