package graphic 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import graphic.events.DataLoadedEvent;
	import meta.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import nochump.util.zip.*;
	
	/**
	 * Background image randomizer. Randomizer consists of 20 sub - images whose positions are randomized.
	 * Sub images are decompresed before randomization.
	 * 
	 * @author Marko Cetinic
	 */
	
	public class RandomBackground extends EventDispatcher
	{
		/**
		 * Dispatched when a file contained in a ZIP archive has
		 * loaded successfully.
		 *
		 * @eventType DataUncompressedEvent.DATA_UNCOMPRESSED
		 */
		[Event(name="dataLoaded",type="graphic.events.DataLoadedEvent")]
		
		/**
		 * Width of image (stage.width).
		 */
		public static const WIDTH:uint = 640;
		
		/**
		 * Height of image (stage.height).
		 */
		public static const HEIGHT:uint = 480;
		
		/**
		 * Tile width.
		 */
		public static const TILE_WIDTH:uint = 128;
		
		/**
		 * Tile height.
		 */
		public static const TILE_HEIGHT:uint = 96;
		
		/**
		 * Tile rows and colums count.
		 */
		public static const TILE_UNITS_SIZE:uint = 5;
		
		public static const DEFAULT_BACKGROUND:uint = 0x000000;
		
		private var _bitmapArr:Array;
		private var _bitmapLoaded:uint;
		
		private var _content:BitmapData;
		
		private var _zipFile:ZipFile;
		
		public function RandomBackground()
		{
			super();
			
			this._bitmapArr = new Array;
			this._bitmapLoaded = 0;
			
			this._content = new BitmapData(WIDTH, HEIGHT, false, DEFAULT_BACKGROUND);
			
			this._zipFile = new ZipFile(new GraphicConstants.SPACE_SLICES_ZIP);
			this._zipFile.entries.sort(randomizeSort);
		}
		
		/**
		 * Content accesor. 
		 * 
		 * @return Randomised image.
		 * 
		 */
		public function get content():BitmapData
		{
			return this._content;
		}
	
		/**
		 * Content accesor. Sets the image.
		 * 
		 */
		public function set content(value:BitmapData):void
		{
			this._content = value;
		}
		
		/**
		 * Adds subimage to content. Calld in loop
		 * 
		 * @param bitmap Subimage.
		 * @param index Subimage index.
		 * 
		 */
		protected function drawContent(bitmap:Bitmap, index:uint):void
		{
			var tx:uint = index % TILE_UNITS_SIZE * TILE_WIDTH;
			var ty:uint = int(index / TILE_UNITS_SIZE) * TILE_HEIGHT;
			
			var matrix:Matrix = new Matrix(1, 0, 0, 1, tx, ty);
			
			this._content.draw(bitmap.bitmapData, matrix);
		}
		
		/**
		 * 
		 * Randomize sort function.
		 * 
		 * @param a First object.
		 * @param b Second object.
		 * 
		 * @see randomizeContent
		 */
		
		protected function randomizeSort(a:*, b:*):int
		{
			return (Math.random() > .5) ? 1 : -1;
		}
		
		/**
		 * 
		 * Randomize content.
		 * 
		 */
		public function randomizeContnet():void
		{
			if (this._bitmapArr != null)
				this._bitmapArr.sort(randomizeSort);
			
			this._content = new BitmapData(WIDTH, HEIGHT, false, DEFAULT_BACKGROUND);
			
			for (var i:int = 0; i < this._bitmapArr.length; i++)
				drawContent(this._bitmapArr[i], i);
		}
		
		/**
		 * 
		 * Entrie loaded (unziped).
		 * 
		 * @see loadDataFromZipFile
		 * 
		 */
		
		protected function loaderCompleate(e:Event):void
		{			
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			loaderInfo.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleate);
			
			var bitmap:Bitmap = loaderInfo.content as Bitmap;
			
			this._bitmapArr.push(bitmap);
			
			drawContent(bitmap, this._bitmapLoaded);
			
			if (++this._bitmapLoaded >= this._zipFile.entries.length)
				this.dispatchEvent(new DataLoadedEvent());
		}
		
		/**
		 * 
		 * Load data from zip asset.
		 * 
		 * @param entriesIndex Index of file to uncompress.
		 * 
		 * @see loaderCompleate
		 * 
		 */
		
		public function loadDataFromZipFile(entriesIndex:int = 0):void
		{		
			if (entriesIndex == this._zipFile.entries.length)
				return;
				
			var entryContent:ByteArray = this._zipFile.getInput(this._zipFile.entries[entriesIndex]);
			
			var loader:Loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleate);
			
			loader.loadBytes(entryContent);
			
			loadDataFromZipFile(entriesIndex+1);
		}
	}
}