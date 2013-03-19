package orichalcum.utility 
{
	
	public class ColorUtil 
	{
		
		static public function toHex(a:uint, r:uint, g:uint, b:uint):uint
		{
			return a << 24 | r << 16 | g << 8 | b;
		}
		
		static public function interpolate(from:uint, to:uint, position:Number = .5):uint
		{
			var inversePosition:Number = 1 - position;
			return	((from >> 24) * inversePosition) + ((to >> 24) * position) << 24 |
				(((from >> 16) & 0xff) * inversePosition) + (((to >> 16) & 0xff) * position) << 16 |
				(((from >> 8) & 0xff) * inversePosition) + (((to >> 8) & 0xff) * position) << 8 |
				((from & 0xff) * inversePosition) + ((to & 0xff) * position);
		}
		
		static public function multiply(color:uint, factor:Number = .5):uint
		{
			return	((color >> 24) * factor) << 24 |
				(((color >> 16) & 0xff) * factor) << 16 |
				(((color >> 8) & 0xff) * factor) << 8 |
				((color & 0xff) * factor);
		}

	}

}