package orichalcum.alchemy.alchemist 
{
	import flash.events.EventDispatcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperty;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.nullValue;
	import org.hamcrest.object.strictlyEqualTo;
	import orichalcum.alchemy.provider.factory.value;

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
		public function testMapToUndefined():void
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
				.withConstructorArgument(1)
				.withProperty('x', 1)
				.withBinding('click', 'go')
				.withComposer('init')
				.withDisposer('dispose');
				
			assertThat(_alchemist.conjure(_id));
		}
		
		/**
		 * Should this functionality be supported given most of the recipe will be ignored?
		 */
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
				.withConstructorArgument(1)
				.withProperty('x', 1)
				.withBinding('complete', 'go', 'bindee')
				.withComposer('init')
				.withDisposer('dispose');
				
			const object:Object = _alchemist.conjure('poo');
			assertThat(object.initialized, isFalse());
			assertThat(object.disposed, isFalse());
			assertThat(object, hasProperty('x', equalTo(1)));
			assertThat(object.bindee.hasEventListener('complete'));
			
			/**
			 * Cannot be accomplished unless the recipe is mapped to the instance as the key
			 */
			_alchemist.destroy(object);
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
