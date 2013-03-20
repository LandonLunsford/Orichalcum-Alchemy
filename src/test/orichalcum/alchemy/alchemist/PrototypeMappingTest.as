package orichalcum.alchemy.alchemist 
{
	import flash.display.Sprite;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.not;
	import org.hamcrest.object.strictlyEqualTo;
	import orichalcum.alchemy.provider.factory.type;

	public class PrototypeMappingTest 
	{
		
		private var _alchemist:Alchemist;
		private var _id:String = 'id';
		private var _type:Class = Sprite;
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
		}
		
		[Test]
		public function testIsType():void
		{
			_alchemist.map(_id).to(type(_type));
			assertThat(_alchemist.conjure(_id), isA(_type));
		}
		
		[Test]
		public function testIsNeverTheSameInstance():void
		{
			_alchemist.map(_id).to(type(_type));
			assertThat(_alchemist.conjure(_id), not(strictlyEqualTo(_alchemist.conjure(_id))));
			assertThat(_alchemist.conjure(_id), not(strictlyEqualTo(_alchemist.conjure(_id))));
			assertThat(_alchemist.conjure(_id), not(strictlyEqualTo(_alchemist.conjure(_id))));
		}
		
	}

}