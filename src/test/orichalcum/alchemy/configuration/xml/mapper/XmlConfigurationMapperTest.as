package orichalcum.alchemy.configuration.xml.mapper 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.strictlyEqualTo;
	import orichalcum.alchemy.alchemist.Alchemist;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.provider.IProvider;
	import subject.Factory;
	import subject.MainView;
	import subject.MainViewMediator;
	import subject.Provider;

	public class XmlConfigurationMapperTest 
	{
		private var _alchemist:IAlchemist;
		private var _mapper:XmlConfigurationMapper = new XmlConfigurationMapper;
		
		[Embed(source="../../alchemy.xml", mimeType="application/octet-stream")]
		private var _xmlConfigData:Class;
		private var _xmlConfig:XML = new XML(new _xmlConfigData);
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
			_mapper.map(_alchemist, _xmlConfig);
		}
		
		[Test(expects="Error")]
		public function testMapNull():void
		{
			_mapper.map(_alchemist, null);
		}
		
		[Test(expects="Error")]
		public function testMapNonXML():void
		{
			_mapper.map(_alchemist, 0);
		}
		
		[Test(expects="Error")]
		public function testMapArrayWithNonXML():void
		{
			_mapper.map(_alchemist, [null]);
		}
		
		[Test(expects="Error")]
		public function testNonUniqueIDs():void
		{
			_mapper.map(new Alchemist,
				<alchemy>
					<map id="id"/>
					<map id="id"/>
				</alchemy>
			);
		}
		
		[Test]
		public function testImplicitToValueMapping():void
		{
			assertThat(_alchemist.conjure('implicitToValue')
				,equalTo(1.1));
		}
		
		[Test]
		public function testExplicitToValueMapping():void
		{
			assertThat(_alchemist.conjure('explicitToValue')
				,equalTo(2.2));
		}
		
		[Test]
		public function testImplicitToReferenceMapping():void
		{
			assertThat(_alchemist.conjure('implicitToReference')
				,equalTo(_alchemist.conjure('implicitToValue')));
		}
		
		[Test]
		public function testExplicitToReferenceMapping():void
		{
			assertThat(_alchemist.conjure('explicitToReference')
				,equalTo(_alchemist.conjure('implicitToValue')));
		}
		
		[Test]
		public function testSingletonMapping():void
		{
			const id:* = Point;
			assertThat(_alchemist.conjure(Point)
				,strictlyEqualTo(_alchemist.conjure(Point)));
		}
		
		[Test]
		public function testSingletonMappingById():void
		{
			const id:* = 'point.singleton.id';
			assertThat(_alchemist.conjure(id)
				,strictlyEqualTo(_alchemist.conjure(id)));
		}
		
		/**
		 * How should this behave ??
		 * should an id-mapped type rely on its underlying type's provider?
		 * the whole reason you want an instance by id mapping is to make an instance
		 */
		[Test]
		public function testSingletonMappingByIdIsUnique():void
		{
			assertThat(_alchemist.conjure('point.singleton.id')
				,not(strictlyEqualTo(_alchemist.conjure(Point))));
		}
		
		[Test]
		public function testPrototypeMapping():void
		{
			const id:* = Rectangle;
			assertThat(_alchemist.conjure(id)
				,not(strictlyEqualTo(_alchemist.conjure(id))));
		}
		
		[Test]
		public function testPrototypeMappingById():void
		{
			const id:* = 'rectangle.prototype.id';
			assertThat(_alchemist.conjure(id)
				,not(strictlyEqualTo(_alchemist.conjure(id))));
		}
		
		[Test]
		public function testPoolMapping():void
		{
			const id:* = Sprite;
			const a:Sprite = _alchemist.conjure(id) as Sprite;
			assertThat(a, not(strictlyEqualTo(_alchemist.conjure(id))));
			_alchemist.destroy(a);
			assertThat(_alchemist.conjure(id), strictlyEqualTo(a));
		}
		
		[Test]
		public function testPoolMappingById():void
		{
			const id:* = 'sprite.pool.id';
			const a:Sprite = _alchemist.conjure(id) as Sprite;
			assertThat(a, not(strictlyEqualTo(_alchemist.conjure(id))));
			_alchemist.destroy(a);
			assertThat(_alchemist.conjure(id), strictlyEqualTo(a));
		}
		
		[Test]
		public function testProviderMapping():void
		{
			const id:* = 'provider.provision';
			const provision:* = {};
			Provider.provision = provision;
			const providedProvision:* = _alchemist.conjure(id);
			assertThat(providedProvision, strictlyEqualTo(provision));
			assertThat(_alchemist.destroy(providedProvision), strictlyEqualTo(provision));
		}
		
		[Test(expects="Error")]
		public function testInvalidFactoryMapping():void
		{
			_mapper.map(new Alchemist,
				<alchemy>
					<map id="x" to-factory="y"/>
				</alchemy>
			);
		}
		
		[Test]
		public function testStaticFactoryMethodMapping():void
		{
			const id:* = 'staticFactoryMethodProvision';
			const provision:* = {};
			Factory.staticFactoryMethodProvision = provision;
			assertThat(_alchemist.conjure(id), strictlyEqualTo(provision));
		}
		
		[Test]
		public function testInstanceFactoryMethodMapping():void
		{
			const id:* = 'instanceFactoryMethodProvision';
			const provision:* = {};
			Factory.instanceFactoryMethodProvision = provision;
			assertThat(_alchemist.conjure(id), strictlyEqualTo(provision));
		}
		
		[Test]
		public function testInstanceFactoryMethodMappingByFactoryId():void
		{
			const id:* = 'factory.provision.id';
			const provision:* = {};
			Factory.instanceFactoryMethodProvision = provision;
			assertThat(_alchemist.conjure(id), strictlyEqualTo(provision));
		}
		
		[Test]
		public function testAbstractClassMapping():void
		{
			assertThat(_alchemist.conjure(DisplayObject), isA(Bitmap));
		}
		
		[Test]
		public function testInterfaceMapping():void
		{
			assertThat(_alchemist.conjure(IEventDispatcher), isA(EventDispatcher));
		}
		
		[Test]
		public function testConstructorArgumentValueMapping():void
		{
			assertThat(_alchemist.conjure(Matrix).a, equalTo(1));
		}
		
		[Test]
		public function testConstructorArgumentReferenceMapping():void
		{
			assertThat(_alchemist.conjure(Matrix).b, equalTo(1.1));
		}
		
		[Test]
		public function testPropertyValueMapping():void
		{
			assertThat(_alchemist.conjure(Matrix).c, equalTo(2));
		}
		
		[Test]
		public function testPropertyReferenceMapping():void
		{
			assertThat(_alchemist.conjure(Matrix).d, equalTo(1.1));
		}
		
		[Test]
		public function testPostConstruct():void
		{
			const m:Matrix = _alchemist.conjure('matrix.with.lifecycle.hooks');
			assertThat(m.a, equalTo(2));
			assertThat(m.b, equalTo(0));
			assertThat(m.c, equalTo(0));
			assertThat(m.d, equalTo(2));
		}
		
		[Test]
		public function testPreDestroy():void
		{
			const m:Matrix = _alchemist.conjure('matrix.with.lifecycle.hooks');
			_alchemist.destroy(m);
			
			/**
			 * In Flash the identity matrix is
			 * |0 0|
			 * |0 0|
			 */
			assertThat(m.a, equalTo(0));
			assertThat(m.b, equalTo(0));
			assertThat(m.c, equalTo(0));
			assertThat(m.d, equalTo(0));
		}
		
		/**
		 * Very surface test.
		 * We also need to see if the handlers were properly generated.
		 */
		[Test]
		public function testEventHandlersRegistered():void
		{
			const m:MainViewMediator = _alchemist.conjure(MainViewMediator) as MainViewMediator;
			const v:MainView = m.view;
			assertThat(m.hasEventListener(Event.COMPLETE));
			assertThat(v.hasEventListener(MouseEvent.CLICK));
			assertThat(v.hasEventListener(MouseEvent.MOUSE_OVER));
			assertThat(v.hasEventListener(MouseEvent.MOUSE_OUT));
			assertThat(v.hasEventListener(MouseEvent.MOUSE_DOWN));
			assertThat(v.hasEventListener(MouseEvent.MOUSE_UP));
			assertThat(v.hasEventListener(MouseEvent.MOUSE_WHEEL));
		}
		
		
	}

}