package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.recipe.ingredient.PostConstruct;


	public class PostConstructProcessor implements IIngredientProcessor
	{
		private var _metatagName:String;
		private var _key:String = 'postConstruct';
		
		public function PostConstructProcessor(metatagName:String = null) 
		{
			_metatagName = metatagName ? metatagName : 'PostConstruct';
		}
		
		public function create(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void
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
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			const postConstruct:PostConstruct = ingredient as PostConstruct;
			if (postConstruct)
			{
				recipe[_key] = postConstruct.name;
			}
		}
		
		public function inherit(parent:Dictionary, child:Dictionary):void 
		{
			parent[_key] = child[_key];
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			recipe[_key] && (instance[recipe[_key]] as Function).call(instance);
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			/**
			 * Does nothing
			 */
		}
		
	}

}