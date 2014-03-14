package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.error.AlchemyError;


	public class PostConstructProcessor 
	{
		private var _metatagName:String;
		private var _key:String = 'postConstruct';
		
		public function PostConstructProcessor() 
		{
			_metatagName = metatagName ? metatagName : 'PostConstruct';
		}
		
		public function create(typeName:String, typeDescription:XML, recipe:Dictionary):void 
		{
			const methods:XMLList = typeDescription.factory[0].method;
			const postConstructs:XMLList = methods.(@declaredBy == typeName).metadata.(@name == _metatagName);
			
			if (postConstructs.length() > 1)
			{
				throw new AlchemyError('Multiple "[{}]" metatags defined in class "{}".', _metatagName, typeName);
			}
				
			if (postConstructs.length() > 0)
			{
				recipe[_key] = postConstructs[0].parent().@name;
			}
		}
		
		public function inherit(parent:Dictionary, child:Dictionary):void 
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