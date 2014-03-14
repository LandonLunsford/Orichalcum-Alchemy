package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.recipe.ingredient.PreDestroy;

	public class PreDestroyProcessor implements IIngredientProcessor
	{
		private var _metatagName:String;
		private var _key:String = 'preDestroy';
		
		public function PreDestroyProcessor(metatagName:String = null) 
		{
			_metatagName = metatagName ? metatagName : 'PreDestroy';
		}
		
		public function introspect(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void
		{
			const methods:XMLList = typeDescription.factory[0].method;
			const preDestroys:XMLList = methods.(@declaredBy == typeName).metadata.(@name == _metatagName);
			
			if (preDestroys.length() > 1)
			{
				throw new AlchemyError('Multiple "[{0}]" metatags defined in class "{2}".', _metatagName, typeName);
			}
				
			if (preDestroys.length() > 0)
			{
				recipe[_key] = preDestroys[0].parent().@name;
			}
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			const preDestroy:PreDestroy = ingredient as PreDestroy;
			if (preDestroy)
			{
				recipe[_key] = preDestroy.name;
			}
		}
		
		public function inherit(parent:Dictionary, child:Dictionary):void 
		{
			parent[_key] = child[_key];
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			/**
			 * Does nothing
			 */
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			recipe[_key] && (instance[recipe[_key]] as Function).call(instance);
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