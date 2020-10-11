package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import graphic.SpriteSheet;
	
	/**
	 * ...
	 * @author mc
	 */
	
	[SWF(width=640,height=480,backgroundColor=0x000000)]
	
	public class Preloader extends MovieClip
	{
		[Embed(source="../assets/spritemaps/fly_spa_monster.png")]
		public static const FLY_SPA_MONST_MAP:Class;
		
		[Embed(source="../assets/spritemaps/chutly_idle_sprite.png")]
		public static const CHUTLY_IDLE_SPRITE:Class;
		
		public static const LINE_COLOR:uint = 0xFF0000;
		public static const FILL_COLOR:uint = 0xFFFFFF;
		
		protected var _progressBar:Shape;
		
		private var _px:int;
		private var _py:int;
		private var _w:int;
		private var _h:int;
		private var _sw:int;
		private var _sh:int;
		
		private var _loadedIndex:int;
		
		private var _tenticleX:int = 75;
		private var _tenticleY:int = 250;
		
		private var _fsmMap:SpriteSheet;
		private var _fsmMapCount:int = 0;
		
		private var _mapTimer:Timer;
		private var _chutlyMap:SpriteSheet;
		private var _chutlyMapCount:int = 1;
		
		public function Preloader()
		{
			_fsmMap = new SpriteSheet(new FLY_SPA_MONST_MAP(), 140, 123);
			_fsmMap.x = _tenticleX + 13;
			_fsmMap.y = _tenticleY + 10;
			this.addChild(_fsmMap);
			
			_chutlyMap = new SpriteSheet(new CHUTLY_IDLE_SPRITE(), 65, 92);
			_chutlyMap.x = 495;
			_chutlyMap.y = 18;
			this.addChild(_chutlyMap);
			
			if (stage != null)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				
				_sw = stage.stageWidth;
				_sh = stage.stageHeight;
				
				_w = stage.stageWidth * 0.8;
				_h = 20;
				
				_px = (_sw - _w) * 0.55;
				_py = (_sh - _h) * 0.90;
				
				this.graphics.beginFill(LINE_COLOR);
				this.graphics.drawRect(_px - 2, _py - 2, _w + 4, _h + 4);
				this.graphics.endFill();
				
				_progressBar = new Shape();
				
				addChild(_progressBar);
			}
			
			this.addEventListener(Event.ENTER_FRAME, checkFrame);
			
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			_mapTimer = new Timer(90, 0);
			_mapTimer.addEventListener(TimerEvent.TIMER, mapTimerHandler);
			_mapTimer.start();
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		private function returnSineWaveShape(speed:int, waveHeight:int, waveLength:int, yStartPosition:int):Shape
		{
			_tenticleX += speed;
			_tenticleY = (waveHeight * Math.sin(_tenticleX / waveLength)) + yStartPosition;
			
			var followX:int = _chutlyMap.x;
			var followY:int = _chutlyMap.y;
			
			var fsmMapX:int = _fsmMap.x - 13;
			var fsmMapY:int = _fsmMap.y;
			
			var deltaX:int = followX - fsmMapX;
			var deltaY:int = followY - fsmMapY;
			
			var bearing:int = Math.atan2(deltaY, deltaX) * 180 / Math.PI;
			var rotation:Number = bearing * Math.PI / 180;
			
			var rX:int = Math.cos(rotation) * (_tenticleX - fsmMapX) - Math.sin(rotation) * (_tenticleY - fsmMapY) + fsmMapX;
			var rY:int = Math.sin(rotation) * (_tenticleX - fsmMapX) + Math.cos(rotation) * (_tenticleY - fsmMapY) + fsmMapY;
			
			var circle:Shape = new Shape();
			circle.x = rX;
			circle.y = rY;
			circle.graphics.beginFill(0xCDBE7A, 1);
			circle.graphics.drawCircle(80, 50, 4);
			circle.graphics.endFill();
			
			return circle;
		}
		
		private function mapTimerHandler(e:TimerEvent):void
		{
			if (_fsmMapCount < 3)
				_fsmMap.drawTile(_fsmMapCount++);
			else
				_fsmMapCount = 0;
			
			if (_chutlyMapCount < 3)
				_chutlyMap.drawTile(_chutlyMapCount++);
			else
				_chutlyMapCount = 0;
		}
		
		private function progress(e:ProgressEvent):void
		{
			var p:Number = (e.bytesLoaded / e.bytesTotal);
			
			_progressBar.graphics.clear();
			_progressBar.graphics.beginFill(FILL_COLOR);
			_progressBar.graphics.drawRect(_px, _py, p * _w, _h);
			_progressBar.graphics.endFill();
			
			var loadingIndex:int = Math.floor(p * 100);
			
			if (_loadedIndex < loadingIndex)
			{
				var circle:Shape;
				var loadingDifference:uint = loadingIndex - _loadedIndex;
				
				_loadedIndex = loadingIndex;
				
				for (var i:int; i < loadingDifference; i++)
					for (var j:int = 0; j < 4; j++)
					{
						circle = returnSineWaveShape(1, 6, 20, _fsmMap.y);
						addChild(circle);
					}
			}
		}
		
		private function checkFrame(e:Event):void
		{
			if (currentFrame == totalFrames)
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void
		{
			this.removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			_mapTimer.stop();
			_mapTimer.removeEventListener(TimerEvent.TIMER, mapTimerHandler);
			
			// TODO hide loader
			
			startup();
		}
		
		private function startup():void
		{
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
	
	}

}