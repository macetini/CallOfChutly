package graphic
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
	import flash.events.Event;
	
	/**
	 * Sprite sheet stand alone class. Used out side of FP engine.
	 * 
	 * @see Preloader
	 * 
	 */
    
    public class SpriteSheet extends Sprite 
    {   
        private var tileSheetBitmapData:BitmapData;
        private var canvasBitmapData:BitmapData;
        
        private var tileWidth:int;
        private var tileHeight:int;
        private var rowLength:int;
        
        private var tileRectangle:Rectangle;
        private var tilePoint:Point;
		
		/**
		 * SpriteSheet constructor.
		 *
		 * @param tileSheetBitmap Sprite sheet bmp.
		 * @param Bmp tile width.
		 * @param Bmp tile height.
		 *
		 */
        public function SpriteSheet(tileSheetBitmap:Bitmap, width:Number = 16, height:Number = 16) 
        {   
            tileSheetBitmapData = tileSheetBitmap.bitmapData;
            tileWidth = width;
            tileHeight = height;
            
            rowLength = int(tileSheetBitmap.width / width);
            
            tileRectangle = new Rectangle(0, 0, tileWidth, tileHeight);
            tilePoint = new Point(0, 0);
            
            canvasBitmapData = new BitmapData(tileWidth, tileHeight, true);
            var canvasBitmap:Bitmap = new Bitmap(canvasBitmapData);
            addChild(canvasBitmap);
            
            drawTile(0);
            
            addEventListener(Event.REMOVED_FROM_STAGE, remove);
        }
        
		/**
		 * Update sprite tile.
		 *
		 * @param tileNumber Tile number to show.
		 *
		 */
        public function drawTile(tileNumber:int):BitmapData
        {
            tileRectangle.x = int((tileNumber % rowLength)) * tileWidth;
            tileRectangle.y = int((tileNumber / rowLength)) * tileHeight;
            canvasBitmapData.copyPixels(tileSheetBitmapData, tileRectangle, tilePoint);
            
            return canvasBitmapData.clone();
        }
        
        protected function tileBoard(boardIndex:Array):BitmapData
        {
            var wide:int = boardIndex[0].length;
            var tall:int = boardIndex.length;
            
            canvasBitmapData = new BitmapData((tileWidth * wide), (tileHeight * tall), true);
            var boardCanvas:Bitmap = Bitmap(getChildAt(0));
            boardCanvas.bitmapData = canvasBitmapData;
            
            tileRectangle = new Rectangle(0, 0,(tileWidth * wide), (tileHeight * tall));
            for (var i:int = 0; i < wide; i++) {
                for (var j:int = 0; j < tall; j++) {
                    tilePoint = new Point((tileWidth * i), (tileHeight * j));
                    
                    drawTile(boardIndex[j][i]);
                }
            }
            return canvasBitmapData.clone();
        }
        
        public function remove(e:Event):void
        {
            tileSheetBitmapData.dispose();
            canvasBitmapData.dispose();
        }
    }
}