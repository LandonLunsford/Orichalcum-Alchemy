package orichalcum.alchemy.alchemist 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.strictlyEqualTo;
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.recipe.Recipe;

	public class ProviderMappingTest implements IProvider
	{
		static private var _provision:* = {};
		private var _alchemist:Alchemist;
		private var _id:String = 'id';
		static private var _destroyed:Boolean;
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
			_alchemist.map(_id).to(this);
			_destroyed = false;
		}
		
		[Test]
		public function testProvide():void
		{
			assertThat(_alchemist.conjure(_id), strictlyEqualTo(_provision));
		}
		
		[Test]
		public function testDestroy():void
		{
			_alchemist.destroy(_alchemist.conjure(_id));
			assertThat(_destroyed, isTrue());
		}
		
		/* INTERFACE orichalcum.alchemy.provider.IProvider */
		
		public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):* 
		{
			return _provision;
		}
		
		public function destroy(provision:*):* 
		{
			_destroyed = true;
			return provision;
		}
		
	}

}
