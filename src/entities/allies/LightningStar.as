package entities.allies 
{
	import meta.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	
	/**
	 * Lightning Star entity. Initiates Lightning effect.
	 * 
	 * @see Lightning Class
	 * 
	 * @author Marko Cetinic
	 */
	
	public class LightningStar extends Entity
	{
		public static const TYPE:String = "lightningStar";
		
		public static const MAX_SPEED:Number = 200;
		
		public static const PLAY_TWINKLE:String = "twinkle";
		public static const PLAY_TWINKLE_FPS:uint = 13;
		
		public static const MAP_SIZE:uint = 84;
		
		/**
         * Entity weight
         */
		public static var Weight:Number = 5;
		
		protected var _map:Spritemap;
		protected var _currentSpeed:Number;
		
		public function LightningStar() 
		{
			_map = new Spritemap(GraphicConstants.LIGHTNING_STAR_MAP, MAP_SIZE, MAP_SIZE);
			_map.add(PLAY_TWINKLE, [0, 1, 2, 3, 4, 5], PLAY_TWINKLE_FPS, true);
			_map.centerOrigin();
			
			this.type = TYPE;
		}
		
		override public function added():void
		{
			this.addGraphic(_map);
			
			_map.play(PLAY_TWINKLE);
			
			var hitBoxRadius:uint = 28;
			
			this.setHitbox(hitBoxRadius, hitBoxRadius, hitBoxRadius/2, hitBoxRadius/2);
			
			if (FP.rand(2) > 0)
			{
				this.y = FP.height + this.height;
				
				this._currentSpeed = -MAX_SPEED;
			}
			else
			{
				this.y = -height;
				this._currentSpeed = MAX_SPEED;
			}
			
			x = FP.rand(FP.width - this.width);
			
			super.added();
		}
		
		// Moves up or down
		override public function update():void
		{
			y += FP.elapsed * this._currentSpeed;
			
			if (y < -height || y > (FP.height + height))
				FP.world.remove(this);	
			
			super.update();
		}
		
	}

}