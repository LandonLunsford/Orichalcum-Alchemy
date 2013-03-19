package orichalcum.alchemy.alchemist
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import orichalcum.alchemist.element.analyst.ElementAnalyst;
	import orichalcum.alchemist.guise.IAnalyst;
	import orichalcum.alchemist.guise.IBinder;
	import orichalcum.alchemist.guise.IComposer;
	import orichalcum.alchemist.guise.ICreator;
	import orichalcum.alchemist.guise.IInjector;
	import orichalcum.alchemist.guise.IInstanceProvider;
	import orichalcum.alchemist.guise.IMapper;
	import orichalcum.alchemist.guise.IMapping;
	import orichalcum.alchemist.guise.IMediator;
	import orichalcum.alchemist.guise.IMediatorMapping;
	import orichalcum.alchemist.guise.INamer;
	import orichalcum.alchemist.guise.IProvider;
	import orichalcum.alchemist.element.provider.factory.reference;
	import orichalcum.alchemist.element.provider.factory.value;
	import orichalcum.alchemist.element.analysis.IElementAnalysis;
	import orichalcum.alchemist.element.analysis.IElementBuilder;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.reflection.IReflector;
	import orichalcum.reflection.Reflector;
	
	public class Alchemist implements IMapper, IProvider, ICreator, IComposer, IBinder, IInjector, INamer, IAnalyst, IMediator, IDisposable, IMapping, IMediatorMapping
	{
		
		private var  expressionQualifier:RegExp = /^{.*}$/;
		private var  expressionQualifiers:RegExp = /{|}|\s/gm;
		private var _providers:Dictionary;
		private var _reflector:IReflector;
		private var _parent:Alchemist;
		private var _analyst:IAnalyst;
		
		/**
		 * Be wary of side effects with this
		 */
		private var _currentMappingId:String;
		 
		public function Alchemist()
		{
			_providers = new Dictionary;
			_reflector = Reflector.getInstance(ApplicationDomain.currentDomain);
			_analyst = new ElementAnalyst(_reflector);
		}
		
		/* INTERFACE orichalcum.provizor.arm.IExtendable */
		
		public function dispose():void 
		{
			throw new ArgumentError;
		}
		
		/* INTERFACE orichalcum.provizor.arm.IExtendable */
		
		public function extend():Object 
		{
			const extension:Alchemist = new Alchemist;
			extension._parent = this;
			return extension;
		}
		
		/* INTERFACE orichalcum.provizor.arm.IMapper */
		
		public function map(classOrMappingId:Object):IMapping
		{
			throw new ArgumentError;
		}
		
		public function unmap(classOrMappingId:Object):void
		{
			throw new ArgumentError;
		}
		
		public function mapped(classOrMappindId:Object):Boolean
		{
			throw new ArgumentError;
		}
		
		public function mappedDirectly(classOrMappingId:Object):Boolean
		{
			throw new ArgumentError;
		}
		
		/* INTERFACE orichalcum.provizor.arm.IProvider */
		
		public function provide(classOrMappingId:Object):* 
		{
			throw new ArgumentError;
		}
		
		/* INTERFACE orichalcum.provizor.arm.ICreator */
		
		public function create(type:Class):Object 
		{
			throw new ArgumentError;
		}
		
		/* INTERFACE orichalcum.provizor.arm.IComposer */
		
		public function compose(instance:Object):Object 
		{
			throw new ArgumentError;
		}
		
		public function destroy(instance:Object):Object 
		{
			throw new ArgumentError;
		}
		
		/* INTERFACE orichalcum.provizor.arm.IBinder */
		
		public function bind(instance:Object):Object 
		{
			throw new ArgumentError;
		}
		
		public function unbind(instance:Object):Object 
		{
			throw new ArgumentError;
		}
		
		/* INTERFACE orichalcum.provizor.arm.IInjector */
		
		public function inject(instance:Object):Object 
		{
			throw new ArgumentError;
		}
		
		public function unject(instance:Object):Object 
		{
			throw new ArgumentError;
		}
		
		/* INTERFACE orichalcum.provizor.arm.INamer */
		
		public function name(viewClassOrInstance:Object):Object 
		{
			// remember to name upon creation later if its a class
			throw new ArgumentError;
		}
		
		/* INTERFACE orichalcum.provizor.arm.IProfiler */
		
		public function analyze(classOrInstance:Object):IElementAnalysis 
		{
			return _analyst.analyze(classOrInstance);
		}
		
		/* INTERFACE orichalcum.provizor.arm.IMediator */
		
		public function mediate(viewClassOrInstance:Object):IMediatorMapping 
		{
			throw new ArgumentError;
		}
		
		public function unmediate(viewClassOrInstance:Object):void 
		{
			throw new ArgumentError;
		}
		
		public function mediates(viewClassOrInstance:Object):Boolean 
		{
			throw new ArgumentError;
		}
		
		public function mediatesDirectly(viewClassOrInstance:Object):Boolean 
		{
			throw new ArgumentError;
		}
		
		/* INTERFACE orichalcum.provizor.arm.IMediatorMapping */
		
		public function using(mediatorClassOrInstance:Object):void 
		{
			throw new ArgumentError;
		}
		
		/* INTERFACE orichalcum.provizor.arm.IMapping */
		
		public function to(valueReferenceOrProvider:*):IElementBuilder
		{
			if (mapped(_currentMappingId))
				trace('[WARNING] overwriting mapping');
			
			var provider:IProvider;
			
			if (valueReferenceOrProvider is IProvider)
			{
				provider = valueReferenceOrProvider as IProvider;
			}
			else if (valueReferenceOrProvider is String && expressionQualifier.test(valueReferenceOrProvider))
			{
				provider = reference(valueReferenceOrProvider.replace(expressionQualifiers,''));
			}
			else
			{
				provider = value(valueReferenceOrProvider);
			}
			_providers[_currentMappingId] = provider;
			return null;
			//return provider is IInstanceProvider ? (_currentMappingId is Class || _reflector.getTypeByName(_currentMappingId)) ? profile((provider as IInstanceProvider).type) : profile((provider as IInstanceProvider).type).extend() : null;//return null profile pleeeeze to avoid null pointer exceptions, maybe trace warnings
		}
		
		/* PRIVATE PARTS */
		
		private function getValidMappingId(qualifiedMappingId:Object):String
		{
			var id:String;
			
			if (qualifiedMappingId is String)
			{
				id = qualifiedMappingId as String;
			}
			else if (qualifiedMappingId is Class)
			{
				id = _reflector.getTypeName(qualifiedMappingId);
			}
			else
			{
				throw new ArgumentError('Argument "injectionId" must be of type String or Class not ' + _reflector.getTypeName(qualifiedMappingId));
			}
			if (_reflector.isPrimitiveType(id))
			{
				throw new ArgumentError('Argument "injectionId" must not be any of these primitive types: (Function, Object, Array, Boolean, Number, String, int, uint)');
			}
			
			return id;
		}
	
	}

}