package entities.enemies 
{
	import entities.Chutly;
	import entities.enemies.interfaces.IEnemy;
	import meta.GraphicConstants;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author mc
	 */
	public class Ship extends Entity implements IEnemy
	{	
		public static const TYPE:String = "ship";
		
		public static const MAX_SPEED:Number = 200;
		
		public static const MAP_WIDTH:uint = 86;
		public static const MAP_HEIGHT:uint = 64;
		
		public static const PLAY_SPIN:String = "spin";
		public static const PLAY_SPIN_FPS:uint = 7;
		
		/**
         * Distance that needs to approched to dispach missle.
         */
		public static const MISSLE_DETECTION_DISTANCE:uint = 200;
		
		/**
         * Entity weight
         */
		public static var Weight:Number = 10.0;
		
		/**
         * Missle entity. Dispached from Ship when player approches it.
         */
		protected var _missile:Missile;
		
		/**
         * Dead flag.
		 * 
		 * @see Update()
         */
		protected var _dead:Boolean;
		
		protected var _map:Spritemap;
		protected var _currentSpeed:Number;

		public function Ship() 
		{			
			this._dead = false;
			
			this._missile = null;
			
			this._map = new Spritemap(GraphicConstants.SHIP_MAP, MAP_WIDTH, MAP_HEIGHT);
			this._map.add(PLAY_SPIN, [0, 1, 2], PLAY_SPIN_FPS, true);
			this._map.centerOrigin();
						
			this.type = TYPE;
		}
						
		override public function added():void
		{
			this.addGraphic(_map);
			
			_map.play(PLAY_SPIN);
			
			var hitBoxSize:uint = 76;
			this.setHitbox(hitBoxSize, hitBoxSize/2, hitBoxSize/2, hitBoxSize/4);
			
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
		
		public function die():void
		{
			this._dead = true;
			this.collidable = false;
			
			if(this._missile != null)
				this._missile.die();
		}
		
		override public function update():void
		{
			this.x += FP.elapsed * this._currentSpeed;
			
			if (this._dead)
			{
				this.y += FP.elapsed * this._currentSpeed;
				this._map.angle += FP.elapsed * this._currentSpeed;
			}
			
			if (this.x < -width || this.x > (FP.width + this.width))
			{
				FP.world.remove(this);
			}
			
			if (this.y < 0 || this.y > (FP.height + this.height))
			{
				FP.world.remove(this);
			}
			
			var e:Entity = world.nearestToEntity(Chutly.TYPE, this);
			
			//dispach the missle
			if (e != null && this.collidable && distanceFrom(e) < MISSLE_DETECTION_DISTANCE && world.classCount(Missile) == 0)
			{
				this._missile = new Missile(this.x, this.y);
				FP.world.add(this._missile);
			}
			
			super.update();
		}	
	}

}