package orichalcum.alchemy.alchemist 
{
	import flash.system.ApplicationDomain;
	import orichalcum.alchemy.mapper.IMapper;
	import orichalcum.alchemy.metatag.bundle.IMetatagBundle;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.reflection.IReflector;
	import orichalcum.reflection.Reflector;

	/**
	 * CHAIN OF RESPONSIBILITY PATTERN
	 * 
	 * This class serves as the ID validation decorator.
	 * This class ensures that ID's are only validated once.
	 */
	public class Alchemist implements IAlchemist, IDisposable
	{
		private var _reflector:IReflector;
		private var _delegate:IAlchemist;
		
		public function Alchemist()
		{
			_reflector = Reflector.getInstance(ApplicationDomain.currentDomain);
			_delegate = new AlchemistMediator(reflector);
		}
		
		private function get reflector():IReflector
		{
			return _reflector;
		}
		
		private function set reflector(value:IReflector):void
		{
			_reflector = value;
		}

		private function get delegate():IAlchemist
		{
			return _delegate;
		}
		
		private function set delegate(value:IAlchemist):void
		{
			_delegate = value;
		}
		
		/* INTERFACE orichalcum.lifecylce.IDisposable */
		
		public function dispose():void
		{
			(_delegate as IDisposable).dispose();
			_delegate = null;
			_reflector = null;
		}
		
		/* INTERFACE orichalcum.alchemy.alchemist.IAlchemist */
		
		public function map(id:*):IMapper 
		{
			return delegate.map(qualify(id));
		}
		
		public function create(type:Class, recipe:Recipe = null):Object 
		{
			return delegate.create(type);
		}
		
		public function inject(instance:Object, recipe:Recipe = null):Object 
		{
			return delegate.inject(instance, recipe);
		}
		
		public function destroy(instance:Object, recipe:Recipe = null):Object 
		{
			return delegate.destroy(instance);
		}
		
		public function conjure(id:*, recipe:Recipe = null):* 
		{
			return delegate.conjure(qualify(id), recipe);
		}
		
		public function evaluate(providerReferenceOrValue:*):*
		{
			return delegate.evaluate(providerReferenceOrValue);
		}
		
		public function extend():IAlchemist 
		{
			const extension:Alchemist = new Alchemist;
			extension.delegate = delegate.extend();
			extension.reflector = reflector;
			return extension;
		}
		
		public function get metatagBundle():IMetatagBundle 
		{
			return delegate.metatagBundle;
		}
		
		public function set metatagBundle(value:IMetatagBundle):void 
		{
			delegate.metatagBundle = value;
		}
		
		public function get expressionQualifier():RegExp 
		{
			return delegate.expressionQualifier;
		}
		
		public function set expressionQualifier(value:RegExp):void 
		{
			delegate.expressionQualifier = value;
		}
		
		public function get expressionRemovals():RegExp
		{
			return delegate.expressionRemovals;
		}
		
		public function set expressionRemovals(value:RegExp):void
		{
			delegate.expressionRemovals = value;
		}
		
		private function qualify(id:*):String
		{
			if (id == null)
				throw new ArgumentError('Argument "id" must not be null.');
			
			var validId:String;
			
			if (id is String)
			{
				validId = id as String;
			}
			else if (id is Class)
			{
				validId = reflector.getTypeName(id);
			}
			else
			{
				throw new ArgumentError('Argument "id" must be of type "String" or "Class" not ' + reflector.getTypeName(validId));
			}
			if (reflector.isPrimitiveType(id))
			{
				throw new ArgumentError('Argument "id" must not be any of these primitive types: (Function, Object, Array, Boolean, Number, String, int, uint)');
			}
			
			return validId;
		}
		
		/** 
		 * Icould also coerce everything into a string
		 * The following logic infers that you can pass this function a string ID, CLass, or instance of any type but (String, Class)
		private function getValidId(id:*):String 
		{
			return id is String ? id as String : _reflector.getTypeName(id);
		}
		*/
		
	}

}