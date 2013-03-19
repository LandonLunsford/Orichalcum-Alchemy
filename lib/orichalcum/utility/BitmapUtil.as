package orichalcum.utility 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BitmapUtil
	{
		static private const _sourceRect:Rectangle = new Rectangle();
		static private const _destPoint:Point = new Point();
		static private const _bitmap:Bitmap = new Bitmap();
		static private const _matrix:Matrix = new Matrix(-1);
		
		static public function createArray(bitmapData:BitmapData, cellWidth:int, cellHeight:int):Array
		{
			if (!bitmapData || cellWidth < 1 || cellHeight < 1)
				throw new ArgumentError('Verify that bitmapData != null and cellWidth and Height exceed 1');
			
			var array:Array = [];
			var dataWidth:int = bitmapData.width;
			var dataHeight:int = bitmapData.height;	
				
			_destPoint.x = 0;
			_destPoint.y = 0;
			_sourceRect.x = 0;
			_sourceRect.y = 0;
			_sourceRect.width = cellWidth;
			_sourceRect.height = cellHeight;
			
			for (var row:int = 0; row * cellHeight < dataHeight; row++)
			{
				for (var col:int = 0; col * cellWidth < dataWidth; col++)
				{
					var cell:BitmapData = new BitmapData(cellWidth, cellHeight);
					_sourceRect.x = col * cellWidth;
					_sourceRect.y = row * cellHeight;
					cell.copyPixels(bitmapData, _sourceRect, _destPoint);
					array.push(cell);
				}
			}
			
			bitmapData.dispose();
			
			return array;
		}
		
		static public function createTiledBitmap(data:Array, tiles:Array, tilesPerRow:int):Bitmap
		{
			if (!data || !tiles || tiles.length == 0)
				throw new ArgumentError('Verify that data, tiles, tilesPerRow != null');
				
			var tile:BitmapData = tiles[0] as BitmapData;
			if (!tile)
				throw new ArgumentError('tiles:Array contains non-bitmapData');
				
			var bitmapWidth:int = tile.width * tilesPerRow;
			var bitmapHeight:int = tile.height * data.length / tilesPerRow;
			var bitmap:Bitmap = new Bitmap(new BitmapData(bitmapWidth, bitmapHeight));
			BitmapUtil.drawTileMap(data, tiles, bitmap.bitmapData);
			return bitmap;
		}
		
		static public function drawTileMap(data:Array, tiles:Array, map:BitmapData):void
		{
			if (!data || !tiles || tiles.length == 0 || !map)
				throw new ArgumentError('Verify that mapData, mapTiles, map != null');
			
			var tile:BitmapData = tiles[0] as BitmapData;
			if (!tile)
				throw new ArgumentError('tiles:Array contains non-bitmapData');
				
			var code:int, col:int, row:int;
			var tileWidth:int = tile.width;
			var tileHeight:int = tile.height;
			var tileBuffer:BitmapData;
			
			_sourceRect.x = 0;
			_sourceRect.y = 0;
			_sourceRect.width = tileWidth;
			_sourceRect.height = tileHeight;
			_matrix.tx = tileWidth;
				
			for each(code in data)
			{
				_destPoint.x = col * tileWidth;
				_destPoint.y = row * tileHeight;
				
				if (code >= 0)
				{
					map.copyPixels(tiles[code], _sourceRect, _destPoint);
				}
				else
				{
					if (!tileBuffer)
						tileBuffer = new BitmapData(tileWidth, tileHeight);
					_bitmap.bitmapData = tiles[ -code];
					tileBuffer.draw(_bitmap, _matrix);
					map.copyPixels(tileBuffer, _sourceRect, _destPoint);
				}
			
				if (++col * tileWidth >= map.width)
				{
					col = 0;
					row++;
				}
			}
		}
		
	}

}