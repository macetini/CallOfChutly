package entities.points
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	
	/**
	 * Planet point base class.
	 * 
	 * @author Marko Cetinic
	 */
	
	public class Planet extends Entity
	{
		public static const TYPE:String = "planet";
		
		public static const MAX_SPEED:Number = 220;
		
		public static const MAP_SIZE:uint = 40;
		
		/**
         * Entity weight
         */
		public static const Weight:Number = 0;
		
		protected var _image:Image;
				
		protected var _currentSpeed:Number;
		
		public function Planet()
		{			
			this.type = TYPE;
		}
		
		override public function added():void
		{			
			this.setHitbox(MAP_SIZE, MAP_SIZE, MAP_SIZE/2, MAP_SIZE/2);
			
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
			
			y = FP.rand(FP.height - this.height);
			
			super.added();
		}
		
		override public function update():void
		{
			x += FP.elapsed * this._currentSpeed;
			
			if (x < -width || x > (FP.width + width))
			{
				FP.world.remove(this);
			}
			
			super.update();
		}
	}

}