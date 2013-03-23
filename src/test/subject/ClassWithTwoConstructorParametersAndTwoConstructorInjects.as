package subject 
{
	import flash.geom.Point;
	
	[Inject('constructorArgument0','constructorArgument1')]
	public class ClassWithTwoConstructorParametersAndTwoConstructorInjects 
	{
		
		public var constructorArgument0:Point;
		public var constructorArgument1:Point;
		
		public function ClassWithTwoConstructorParametersAndTwoConstructorInjects(constructorArgument0:Point, constructorArgument1:Point) 
		{
			this.constructorArgument1 = constructorArgument1;
			this.constructorArgument0 = constructorArgument0;
		}
		
	}

}
