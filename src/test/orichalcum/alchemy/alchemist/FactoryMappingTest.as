package orichalcum.alchemy.alchemist 
{
	import flash.display.Sprite;
	import org.flexunit.asserts.fail;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.strictlyEqualTo;
	import orichalcum.alchemy.provider.factory.multiton;
	import orichalcum.alchemy.provider.factory.type;
	import subject.Multiton;

	public class FactoryMappingTest 
	{
		
		private var _alchemist:Alchemist;
		private var _type:Class = Multiton;
		private var _poolSize:int = 3;
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
			_alchemist.map(_type).to(multiton(_type, _poolSize));
		}
		
		[Test]
		public function testIsType():void
		{
			fail()
		}
		
		
	}

}