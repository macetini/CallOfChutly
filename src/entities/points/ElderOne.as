package entities.points
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import meta.GraphicConstants;
	
	/**
	 * Elder one entity
	 * 
	 * @author Marko Cetinic
	 */
	
	public class ElderOne extends Entity
	{
		public static const TYPE:String = "elderOne";
		public static const VALUE:int = 1;
		
		public static const MAP_WIDTH:uint = 49;
		public static const MAP_HEIGHT:uint = 69;
		
		public static const PLAY_ROTATE:String = "rotate";
		public static const ROTATE_FPS:uint = 20;
		
		/**
         * Amplitude of a wave
         */
		public static const WAVE_HEIGHT:int = 30;
		
		/**
         * Period of a wave
         */
		public static const WAVE_LENGHT:int = 30;
		
		protected var _map:Spritemap;
		
		protected var _parent:ElderOneChain;
		protected var _speed:int;
		protected var _rotation:int;
		protected var _initY:int;
		
		/**
         * Helper x coordinate point
		 * 
		 * @see returnSineWavePoint()
         */
		private var _x:int;
		
		/**
         * Helper y coordinate point
		 * 
		 * @see returnSineWavePoint()
         */
		private var _y:int;
		
		/**
		 * Tentacle class constructor.
		 *
		 * @param parent Elder one chain parent.
		 * @param speed Speed of elder ones movement.
		 * @param rotation Elder one rotation.
		 * @param initX Intial X coordinate.
		 * @param initY Initial Y coordinate.
		 *
		 */
		public function ElderOne(parent:ElderOneChain, speed:int = 4, rotation:int = 0, initX:int = 0, initY:int = 0)
		{
			this._map = new Spritemap(GraphicConstants.ELDER_ONE_SPRITE, MAP_WIDTH, MAP_HEIGHT);
			this._map.add(PLAY_ROTATE, [0, 1, 2, 3, 4, 5], ROTATE_FPS, true);
			
			this._parent = parent;
			this._speed = speed;
			this._rotation = rotation;
			
			this._x = this.x = initX;
			this._initY = this.y = initY;
			
			this.addGraphic(this._map);
			
			this._map.centerOrigin();
			
			var slice:int = 7;
			this.setHitbox(MAP_WIDTH - slice, MAP_HEIGHT/2, (MAP_WIDTH - slice)/2, MAP_HEIGHT/4);
			
			this.type = TYPE;
		}
		
		override public function added():void
		{
			super.added();
			
			this._map.play(PLAY_ROTATE);
		}
		
		/**
		 * Rotate entity around the point
		 *
		 * @param rotation Rotation angle.
		 * @param pO Origin point.
		 * @param pD Destination point.
		 *
		 */
		protected function returnRotateAroundPoint(rotation:Number, pO:Point, pD:Point):Point
		{
			var rX:int = Math.cos(rotation) * (pD.x - pO.x) - Math.sin(rotation) * (pD.y - pO.y) + pO.x;
			var rY:int = Math.sin(rotation) * (pD.x - pO.x) + Math.cos(rotation) * (pD.y - pO.y) + pO.y;
			
			return new Point(rX, rY);
		}
		
		/**
		 * Returns sinus wave tentacle point. ( y = A * sin(B/x) + yInit ).
		 *
		 * @param speed Speed of the entity movement.
		 * @param waveHeight Amplitude or Wave height.
		 * @param waveLength Period or Wave length.
		 * @param waveLength Y coordinate starting position
		 * 
		 * @return New sinus wave point.
		 *
		 */
		protected function returnSineWavePoint(speed:int, waveHeight:int, waveLength:int, yStartPosition:int):Point
		{
			this._x += speed;
			this._y = (waveHeight * Math.sin(this._x / waveLength)) + yStartPosition;
			
			var rotation:Number = this._rotation * Math.PI / 180;
			
			var rPoint:Point = returnRotateAroundPoint(rotation, new Point(0, yStartPosition), new Point(this._x, this._y));
			
			return rPoint;
		}
		
		public function removeMe():void
		{
			this._parent.removeElderOne();
		}
		
		override public function update():void
		{
			super.update();
			
			//New sinus wave point
			var rPoint:Point = returnSineWavePoint(this._speed, WAVE_HEIGHT, WAVE_LENGHT, this._initY);
			
			this.x = rPoint.x;
			this.y = rPoint.y;
			
			var movementDirection:int = this._speed * this._rotation;
			
			if (movementDirection > 0 && this.y >= FP.height + MAP_HEIGHT)
				removeMe();
			
			if (movementDirection < 0 && this.y < -MAP_HEIGHT)
				removeMe();
		}
	}

}