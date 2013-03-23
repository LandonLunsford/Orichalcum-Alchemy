package orichalcum.alchemy.alchemist 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class AlchemistExtensionTest 
	{
		
		private var _grandparent:IAlchemist;
		private var _parent:IAlchemist;
		private var _child:IAlchemist;
		private var _id:String = 'id';
		private var _value:int = 9999;
		
		[Before]
		public function setup():void
		{
			_grandparent = new Alchemist;
			_parent = _grandparent.extend();
			_child = _parent.extend();
		}
		
		[Test]
		public function testParentFallback():void
		{
			_parent.map(_id).to(_value);
			assertThat(_value, equalTo(_child.conjure(_id)));
		}
		
		[Test]
		public function testGrandparentFallback():void
		{
			_grandparent.map(_id).to(_value);
			assertThat(_value, equalTo(_child.conjure(_id)));
		}
		
		[Test]
		public function testGrandparentFallbackOverridenByParent():void
		{
			const overridenValue:int = 1;
			_grandparent.map(_id).to(_value);
			_parent.map(_id).to(overridenValue);
			assertThat(overridenValue, equalTo(_child.conjure(_id)));
		}
		
		[Test]
		public function testChildPriorityOverAncestors():void
		{
			const overridenValue:int = 1;
			_grandparent.map(_id).to(_value);
			_parent.map(_id).to(_value);
			_child.map(_id).to(overridenValue);
			assertThat(overridenValue, equalTo(_child.conjure(_id)));
		}
		
	}

}