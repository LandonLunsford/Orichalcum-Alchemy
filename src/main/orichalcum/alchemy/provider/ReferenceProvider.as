package orichalcum.alchemy.provider 
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.lifecycle.IDisposable;
	
	
	public class ReferenceProvider implements IProvider, IDisposable
	{
		private var _reference:String;
		
		/**
		 * @param id Custom name, class or qualified class name
		 */
		public function ReferenceProvider(id:*) 
		{
			_reference = getValidId(id);
		}
		
		public function dispose():void 
		{
			_reference = null;
		}
		
		public function provide(id:*, activeAlchemist:IAlchemist, activeRecipe:Dictionary):*
		{
			return activeAlchemist.conjure(_reference, activeRecipe);
		}
		
		public function destroy(provision:*):* 
		{
			return provision;
		}
		
		/**
		 * Duplicate code
		 */
		private function getValidId(id:*):String 
		{
			if (id is String)
				return id as String;
				
			if (id is Class)
				return getQualifiedClassName(id as Class);
				
			throw new ArgumentError('Argument "id" must be of type "String" or "Class" not ' + getQualifiedClassName(id));
		}
		
		
	}

}
