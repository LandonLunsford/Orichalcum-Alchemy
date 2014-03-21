package orichalcum.alchemy.alchemist 
{
	import flash.events.EventDispatcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperty;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.nullValue;
	import org.hamcrest.object.strictlyEqualTo;
	import orichalcum.alchemy.provider.factory.value;
	import orichalcum.alchemy.ingredient.factory.constructorArgument;
	import orichalcum.alchemy.ingredient.factory.eventHandler;
	import orichalcum.alchemy.ingredient.factory.postConstruct;
	import orichalcum.alchemy.ingredient.factory.preDestroy;
	import orichalcum.alchemy.ingredient.factory.property;

	public class ValueMappingTest 
	{
		
		private var _alchemist:Alchemist;
		private var _id:String = 'id';
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
		}
		
		[Test]
		public function testMapToNull():void
		{
			_alchemist.map(_id).to(null);
			assertThat(_alchemist.conjure(_id), nullValue());
		}
		
		[Test]
		public function testMapToUndefinedWrappedInValueProvider():void
		{
			_alchemist.map(_id).to(undefined);
			assertThat(_alchemist.conjure(_id), equalTo(undefined));
		}
		
		[Test]
		public function testMapToUint():void
		{
			_alchemist.map(_id).to(uint(1));
			assertThat(_alchemist.conjure(_id), equalTo(uint(1)));
		}
		
		[Test]
		public function testMapToInt():void
		{
			_alchemist.map(_id).to(int(1));
			assertThat(_alchemist.conjure(_id), equalTo(int(1)));
		}
		
		[Test]
		public function testMapToNumber():void
		{
			_alchemist.map(_id).to(Number(1));
			assertThat(_alchemist.conjure(_id), equalTo(Number(1)));
		}
		
		[Test]
		public function testMapToFunction():void
		{
			const fn:Function = function():void {};
			_alchemist.map(_id).to(fn);
			assertThat(_alchemist.conjure(_id), equalTo(fn));
		}
		
		[Test]
		public function testMapToBooleanTrue():void
		{
			_alchemist.map(_id).to(true);
			assertThat(_alchemist.conjure(_id));
		}
		
		[Test]
		public function testMapToBooleanFalse():void
		{
			_alchemist.map(_id).to(false);
			assertThat(_alchemist.conjure(_id), isFalse());
		}
		
		[Test]
		public function testMapToString():void
		{
			const string:String = 'string';
			_alchemist.map(_id).to(string);
			assertThat(_alchemist.conjure(_id), equalTo(string));
		}
		
		[Test]
		public function testMapToClass():void
		{
			_alchemist.map(_id).to(Class);
			assertThat(_alchemist.conjure(_id), equalTo(Class));
		}
		
		[Test]
		public function testMapToObject():void
		{
			const object:Object = {};
			_alchemist.map(_id).to(object);
			assertThat(_alchemist.conjure(_id), strictlyEqualTo(object));
		}
		
		/**
		 * Insures that recipes mapped to primitive values
		 * are ignored and not applied.
		 */
		[Test]
		public function testMapToInjectedPrimitive():void
		{
			_alchemist.map(_id).to(true)
				.add(constructorArgument(1))
				.add(property('x', 1))
				.add(eventHandler({event:'click', listenerName:'go'}))
				.add(postConstruct('init'))
				.add(preDestroy('dispose'))
				
			assertThat(_alchemist.conjure(_id));
		}
		
		/**
		 * Should this functionality be supported given most of the recipe will be ignored?
		 * This functionality is not supported in 1.0 and will be considered for 1.1
		 */
		[Ignore]
		[Test]
		public function testMapToInjectedObject():void
		{
			_alchemist.map('poo').to({
					bindee: new EventDispatcher
					,go: function():void {}
					,init: function():void { this.initialized = true; }
					,dispose: function():void { this.disposed = true; }
					,initialized: false
					,disposed: false
				})
				.add(constructorArgument(1))
				.add(property('x', 1))
				.add(eventHandler({event:'click', listenerName:'go', target:'bindee'}))
				.add(postConstruct('init'))
				.add(preDestroy('dispose'))
				
			const object:Object = _alchemist.conjure('poo');
			assertThat(object.initialized, isFalse());
			assertThat(object.disposed, isFalse());
			assertThat(object, hasProperty('x', equalTo(1)));
			assertThat(object.bindee.hasEventListener('complete'));
			
			_alchemist.destroy(object);
			assertThat(object.disposed, isTrue());
			assertThat(object.bindee.hasEventListener('complete'), isFalse());
		}
		
		[Test]
		public function tesMapToReferenceConflict():void
		{
			const valueA:int = 0;
			const valueB:String = '{a}';
			_alchemist.map('a').to(valueA);
			_alchemist.map('b').to(valueB);
			assertThat(_alchemist.conjure('b'), equalTo(valueA));
		}
		
		[Test]
		public function testMapToReferenceConflictResolution():void
		{
			const valueA:int = 0;
			const valueB:String = '{a}';
			_alchemist.map('a').to(valueA);
			_alchemist.map('b').to(value(valueB));
			assertThat(_alchemist.conjure('b'), equalTo(valueB));
		}
		
	}

}
