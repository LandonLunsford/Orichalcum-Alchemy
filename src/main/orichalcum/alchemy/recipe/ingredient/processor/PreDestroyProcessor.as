package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.error.AlchemyError;

	public class PreDestroyProcessor 
	{
		private var _metatagName:String;
		private var _key:String = 'preDestroy';
		
		public function PreDestroyProcessor() 
		{
			_metatagName = metatagName ? metatagName : 'PreDestroy';
		}
		
		public function create(typeName:String, typeDescription:XML, recipe:Dictionary):void 
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
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			parent[_key] = child[_key];
		}
		
		public function activate(instance:*, recipe:Dictionary):void 
		{
			
		}
		
		public function deactivate(instance:*, recipe:Dictionary):void 
		{
			
		}
		
	}

}