package subject 
{
	import flash.display.Sprite;

	public class SpriteFriend 
	{
		
		[Inject]
		public var sprite:Sprite;
		
		[PostConstruct]
		public function postConstruct():void
		{
			trace(sprite.name);
		}
		
	}

}