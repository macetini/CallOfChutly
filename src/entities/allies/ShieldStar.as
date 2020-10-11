package entities.allies 
{
	import meta.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	
	/**
	 * Shield Star entity. Initiates Shield effect.
	 * 
	 * @see Shield Class
	 * 
	 * @author Marko Cetinic
	 */
	
	
	public class ShieldStar extends Entity
	{
		public static const MAX_SPEED:Number = 200;
		
		public static const TYPE:String = "shieldStar";
		
		public static const PLAY_TWINKLE:String = "twinkle";
		public static const PLAY_TWINKLES_FPS:uint = 13;
		
		public static const MAP_SIZE:uint = 57;
		
		public static var Weight:Number = 5;
			
		protected var _map:Spritemap;
		protected var _currentSpeed:Number;
		
		public function ShieldStar() 
		{
			_map = new Spritemap(GraphicConstants.SHILD_STAR_MAP, MAP_SIZE, MAP_SIZE);
			_map.add(PLAY_TWINKLE, [0, 1, 2, 3, 4, 5, 6, 7], PLAY_TWINKLES_FPS, true);
			_map.centerOrigin();
			
			this.type = TYPE;
		}
		
		override public function added():void
		{
			this.addGraphic(_map);
			
			_map.play(PLAY_TWINKLE);
			
			this.setHitbox(MAP_SIZE/2, MAP_SIZE/2, MAP_SIZE/4, MAP_SIZE/4);
			
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
		
		//moves up or down
		override public function update():void
		{
			y += FP.elapsed * this._currentSpeed;
			
			if (y < -height || y > (FP.height + height))
				FP.world.remove(this);	
			
			super.update();
		}
		
	}

}