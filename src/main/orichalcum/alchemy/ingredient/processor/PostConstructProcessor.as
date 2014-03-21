package orichalcum.alchemy.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.ingredient.PostConstruct;


	public class PostConstructProcessor implements IIngredientProcessor
	{
		private var _metatagName:String;
		private var _ingredientId:String = 'postConstruct';
		
		public function PostConstructProcessor(metatagName:String = 'PostConstruct') 
		{
			_metatagName = metatagName;
		}
		
		public function introspect(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void
		{
			const methods:XMLList = typeDescription.factory[0].method;
			const postConstructs:XMLList = methods.(@declaredBy == typeName).metadata.(@name == _metatagName);
			
			if (postConstructs.length() > 1)
			{
				throw new AlchemyError('Multiple "[{}]" metatags defined in class "{}".', _metatagName, typeName);
			}
				
			if (postConstructs.length() > 0)
			{
				recipe[_ingredientId] = postConstructs[0].parent().@name;
			}
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			const postConstruct:PostConstruct = ingredient as PostConstruct;
			if (postConstruct)
			{
				recipe[_ingredientId] = postConstruct.name;
			}
		}
		
		public function inherit(parent:Dictionary, child:Dictionary):void 
		{
			parent[_ingredientId] = child[_ingredientId];
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			recipe[_ingredientId] && (instance[recipe[_ingredientId]] as Function).call(instance);
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			/**
			 * Does nothing
			 */
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