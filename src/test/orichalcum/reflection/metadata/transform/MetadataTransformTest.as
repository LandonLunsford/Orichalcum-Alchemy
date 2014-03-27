package orichalcum.reflection.metadata.transform 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	
	public class MetadataTransformTest 
	{
		private var _metatagA:XML = 
			<metadata name="metatagA">
				<arg key="keyA" value="valueA"/>
				<arg key="keyB" value="true"/>
				<arg key="keyC" value="false"/>
				<arg key="" value="keyD"/>
				<arg key="keyE" value="1.1"/>
				<arg key="keyF" value="1.1.1"/>
				<arg key="keyG" value="a,b,c"/>
				<arg key="" value="H"/>
				<arg key="" value="I"/>
			</metadata>;
			
		private var _metatagB:XML = 
			<metadata name="metatagB">
				<arg key="" value="a"/>
				<arg key="" value="b"/>
				<arg key="" value="c"/>
			</metadata>;
			
		[Test]
		public function testingMapper():void
		{
			const mapper:IMetadataTransform = new MetadataMapper()
				.argument('keyA')
					.to('newKeyA')
				.argument('keyG')
					.to('newKeyG')
					.format(function(value:String):* {
						return value.split(',');
					})
				.argument('H')
					.implicit('this')
				.argument('I')
					.to('i')
					
			assertThat(
				mapper.transform(_metatagA),
				hasProperties({
					newKeyA: 'valueA',
					keyB: true,
					keyC: false,
					keyD: true,
					keyE: 1.1,
					keyF: '1.1.1',
					newKeyG: equalTo(['a', 'b', 'c']),
					H: 'this',
					i: true
				})
			)
		}
		
	}

}