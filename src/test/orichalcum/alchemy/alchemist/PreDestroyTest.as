package orichalcum.alchemy.alchemist 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import orichalcum.alchemy.provider.factory.singleton;
	import orichalcum.alchemy.ingredient.factory.preDestroy;
	import subject.ClassWithPreDestroy;
	import subject.ClassWithPreDestroyMetatag;

	public class PreDestroyTest 
	{
		
		private var _alchemist:Alchemist;
		private var _preDestroy:String = 'preDestroy';
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
		}
		
		[Test]
		public function testMetadataConfiguredPreDestroyIsCalledByDestroy():void
		{
			const creation:ClassWithPreDestroyMetatag = new ClassWithPreDestroyMetatag;
			_alchemist.destroy(creation);
			assertThat(creation.preDestroyCalled, isTrue());
		}
		
		[Test]
		public function testRuntimeConfiguredPreDestroyIsCalledByDestroy():void
		{
			_alchemist.map(ClassWithPreDestroy)
				.add(preDestroy(_preDestroy))
			
			const creation:ClassWithPreDestroy = new ClassWithPreDestroy;
			_alchemist.destroy(creation);
			assertThat(creation.preDestroyCalled, isTrue());
		}
		
		[Test]
		public function testMetadataConfiguredPreDestroyOverridenByRuntimeConfiguredPreDestroy():void
		{
			_alchemist.map(ClassWithPreDestroyMetatag)
				.add(preDestroy('otherPreDestroy'))
			
			const creation:ClassWithPreDestroyMetatag = new ClassWithPreDestroyMetatag;
			_alchemist.destroy(creation);
			assertThat(creation.preDestroyCalled, isFalse());
			assertThat(creation.otherPreDestroyCalled, isTrue());
		}
		
		[Test]
		public function testIdMappedRuntimeConfiguredPreDestroyIsCalledByDestroy():void
		{
			const id:String = 'id';
			_alchemist.map(id)
				.to(singleton(ClassWithPreDestroy))
				.add(preDestroy(_preDestroy))
				
			const creation:ClassWithPreDestroy = _alchemist.conjure(id) as ClassWithPreDestroy;
			_alchemist.destroy(creation);
			assertThat(creation.preDestroyCalled, isTrue());
		}

	}

}
