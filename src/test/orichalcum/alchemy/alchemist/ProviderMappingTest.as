package orichalcum.alchemy.alchemist 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.strictlyEqualTo;
	import orichalcum.alchemy.provider.factory.provider;
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.recipe.Recipe;

	public class ProviderMappingTest implements IProvider
	{
		
		private var _alchemist:Alchemist;
		private var _id:String = 'id';
		private var _provision:*;
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
		}
		
		[Test]
		public function test():void
		{
			_provision = 0;
			_alchemist.map(_id).to(provider(ProviderMappingTest));
			assertThat(_alchemist.conjure(_id), strictlyEqualTo(_provision));
		}
		
		/* INTERFACE orichalcum.alchemy.provider.IProvider */
		
		public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):* 
		{
			return _provision;
		}
		
	}

}
