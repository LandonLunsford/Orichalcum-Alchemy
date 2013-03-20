package orichalcum.alchemy.alchemist 
{
	import flash.display.Sprite;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.strictlyEqualTo;
	import orichalcum.alchemy.provider.factory.singleton;

	public class SingletonMappingTest 
	{
		
		private var _alchemist:Alchemist;
		private var _id:String = 'id';
		private var _type:Class = Sprite;
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
		}
		
		[Test(expects = "ArgumentError")]
		public function testNull():void
		{
			_alchemist.map(_id).to(singleton(null));
			_alchemist.conjure(_id);
		}
		
		[Test(expects = "ArgumentError")]
		public function testUndefined():void
		{
			_alchemist.map(_id).to(singleton(undefined));
			_alchemist.conjure(_id);
		}
		
		[Test(expects = "TypeError")]
		public function testClass():void
		{
			_alchemist.map(_id).to(singleton(Class));
			_alchemist.conjure(_id);
		}
		
		[Test]
		public function testIsType():void
		{
			_alchemist.map(_id).to(singleton(_type));
			assertThat(_alchemist.conjure(_id), isA(_type));
		}
		
		[Test]
		public function testIsSingle():void
		{
			_alchemist.map(_id).to(singleton(_type));
			assertThat(_alchemist.conjure(_id), strictlyEqualTo(_alchemist.conjure(_id)));
		}
		
	}

}