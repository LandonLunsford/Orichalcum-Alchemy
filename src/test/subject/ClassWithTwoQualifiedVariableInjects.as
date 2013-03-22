package subject 
{
	import flash.geom.Point;
	
	public class ClassWithTwoQualifiedVariableInjects 
	{
		[Inject('variable0')]
		public var variable0:Point;
		
		[Inject('variable1')]
		public var variable1:Point;
		
	}

}
