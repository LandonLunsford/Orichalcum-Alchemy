package orichalcum.alchemy.alchemist 
{
	import flash.utils.Dictionary;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.notNullValue;
	import orichalcum.alchemy.provider.factory.factory;

	public class FactoryMappingTest 
	{
		
		private var _alchemist:Alchemist;
		private var _id:String = 'id';
		private var _factoryCalled:Boolean;
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
			_factoryCalled = false;
		}
		
		[Test(expects = "ArgumentError")]
		public function testNullFactory():void
		{
			factory(null);
		}
		
		[Test(expects = "ArgumentError")]
		public function testFactoryWithTooManyArguments():void
		{
			factory(function(a:*,b:*):void{});
		}
		
		[Test]
		public function testZeroArgumentFactoryMethod():void
		{
			
			const method:Function = function():* { _factoryCalled = true; };
			_alchemist.map(_id).to(factory(method));
			_alchemist.conjure(_id);
			assertThat(_factoryCalled, isTrue());
		}
		
		[Test]
		public function testOneArgumentFactoryMethod():void
		{
			const method:Function = function(activeAlchamist:IAlchemist):*
			{
				_factoryCalled = true;
				assertThat(activeAlchamist, notNullValue());
			};
			_alchemist.map(_id).to(factory(method));
			_alchemist.conjure(_id);
			assertThat(_factoryCalled, isTrue());
		}
		
		/**
		 * Candidate feature for 1.1 release
		 */
		[Ignore]
		[Test]
		public function testTwoArgumentFactoryMethod():void
		{
			const method:Function = function(activeAlchamist:IAlchemist, activeRecipe:Dictionary):*
			{
				_factoryCalled = true;
				assertThat(activeAlchamist, notNullValue());
				assertThat(activeRecipe, notNullValue());
			};
			_alchemist.map(_id).to(factory(method));
			_alchemist.conjure(_id);
			assertThat(_factoryCalled, isTrue());
		}
		
	}

}