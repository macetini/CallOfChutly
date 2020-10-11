package entities.allies
{
	import meta.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	
	/**
	 * Life entity, adds one +1 to health
	 *
	 * @author Marko Cetinic
	 */
	
	public class Life extends Entity
	{
		public static const TYPE:String = "life";
		
		public static const MAX_SPEED:int = 220;
		
		/**
         * Amplitude of a wave
         */
		public static const WAVE_HEIGHT:uint = 100;
		
		/**
         * Period of a wave
         */
		public static const WAVE_LENGHT:uint = 30;
		
		public static const IMAGE_WIDTH:uint = 53;
		public static const IMAGE_HEIGHT:uint = 45;
		
		/**
         * Time necessary to pass for respawn
         */
		public static var Timeout:Number = 7.0;
		
		/**
         * Respawn time counter
         */
		public static var TimeOutCounter:Number = 0;
		
		/**
         * Entity weight
         */
		public static var Weight:Number = 6.0;
		
		protected var _image:Image;
		protected var _currentSpeed:Number;
		
		protected var _initalY:Number;
		
		public function Life()
		{
			_image = new Image(GraphicConstants.HUD_HEART_FULL);
			_image.smooth = true;
			
			this.type = TYPE;
		}
		
		override public function added():void
		{
			this.addGraphic(_image);
			
			this.setHitbox(IMAGE_WIDTH, IMAGE_HEIGHT);
			
			if (FP.rand(2) > 0)
			{
				this.x = FP.width + this.halfWidth;
				this._currentSpeed = -MAX_SPEED;
			}
			else
			{
				this.x = -halfWidth;
				this._currentSpeed = MAX_SPEED;
			}
			
			this.y = FP.rand(FP.height - this.height);
			
			if (this.y + WAVE_HEIGHT + this.height > FP.height)
				this.y = FP.height - WAVE_HEIGHT - this.height;
			else if (this.y - WAVE_HEIGHT < 0)
				this.y = WAVE_HEIGHT;
			
			this._initalY = this.y;
			
			super.added();
		}
		
		/**
		 * Moves entity in sine wave ( y = A * sin(B/x) + yInit ).
		 *
		 * @param speed Speed of the entity movement.
		 * @param waveHeight Amplitude or Wave height.
		 * @param waveLength Period or Wave length.
		 * @param waveLength Y coordinate starting position
		 *
		 */
		protected function sineWave(speed:int, waveHeight:int, waveLength:int, yStartPosition:int):void
		{
			this.x += speed;
			this.y = (waveHeight * Math.sin(this.x / waveLength)) + yStartPosition;
		}
		
		override public function update():void
		{
			// y = A * sin(B/x) + yInit
			sineWave(FP.elapsed * this._currentSpeed, WAVE_HEIGHT, WAVE_LENGHT, this._initalY);
			
			if (this.x < -width || this.x > (FP.width + width))
				FP.world.remove(this);
			
			super.update();
		}
	
	}

}