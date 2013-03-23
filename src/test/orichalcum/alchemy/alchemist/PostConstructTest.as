package orichalcum.alchemy.alchemist 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import subject.ClassWithPostConstruct;
	import subject.ClassWithPostConstructMetatag;

	public class PostConstructTest 
	{
		
		private var _alchemist:Alchemist;
		private var _postConstruct:String = 'postConstruct';
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
		}
		
		[Test]
		public function testMetadataConfiguredPostConstructCalledByCreate():void
		{
			const creation:ClassWithPostConstructMetatag = _alchemist.create(ClassWithPostConstructMetatag) as ClassWithPostConstructMetatag;
			assertThat(creation.postConstructCalled, isTrue());
		}
		
		[Test]
		public function testMetadataConfiguredPostConstructNotCalledByInject():void
		{
			const creation:ClassWithPostConstructMetatag = _alchemist.inject(new ClassWithPostConstructMetatag) as ClassWithPostConstructMetatag;
			assertThat(creation.postConstructCalled, isFalse());
		}
		
		[Test]
		public function testRuntimeConfiguredPostConstructCalledByCreate():void
		{
			_alchemist.map(ClassWithPostConstruct)
				.withComposer(_postConstruct);
			
			const creation:ClassWithPostConstruct = _alchemist.create(ClassWithPostConstruct) as ClassWithPostConstruct;
			assertThat(creation.postConstructCalled, isTrue());
		}
		
		[Test]
		public function testRuntimeConfiguredPostConstructNotCalledByInject():void
		{
			_alchemist.map(ClassWithPostConstruct)
				.withComposer(_postConstruct);
				
			const creation:ClassWithPostConstruct = _alchemist.inject(new ClassWithPostConstruct) as ClassWithPostConstruct;
			assertThat(creation.postConstructCalled, isFalse());
		}
		
		[Test]
		public function testRuntimeConfiguredPostConstructOverridesMetadataConfiguredPostConstruct():void
		{
			_alchemist.map(ClassWithPostConstructMetatag)
				.withComposer('otherPostConstruct');
				
			const creation:ClassWithPostConstructMetatag = _alchemist.create(ClassWithPostConstructMetatag) as ClassWithPostConstructMetatag;
			assertThat(creation.postConstructCalled, isFalse());
			assertThat(creation.otherPostConstructWasCalled, isTrue());
		}
		
	}

}
