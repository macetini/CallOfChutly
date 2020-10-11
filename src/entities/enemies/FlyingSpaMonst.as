package entities.enemies 
{
	import entities.enemies.interfaces.IEnemy;
	import meta.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	
	/**
	 * ...
	 * @author mc 
	 * */
	
	public class FlyingSpaMonst extends Entity implements IEnemy
	{
		public static const TYPE:String  = "flyingSpaMonst";
		
		public static const MAX_SPEED:Number = 200;
		
		public static const PLAY_FLOAT:String = "float";
		
		public static const FLOAT_FPS:uint = 13;
		
		public static const MAP_WIDTH:uint = 140;
		public static const MAP_HEIGHT:uint = 123;
		
		/**
         * Entity weight
         */
		public static var Weight:Number = 10;

		protected var _map:Spritemap;
		
		protected var _currentSpeed:Number;
		
		/**
         * Tenticle entity.
		 * 
		 * @see Tenticle class.
         */
		protected var _tentacle:Tentacle;
		
		/**
         * Target to be hit by tenticle entity.
		 * 
         */
		protected var _target:Entity = null; 
		
		/**
         * Tenticle entity.
		 * 
		 * @see Tenticle length.
         */
		protected var _tenticleLength:uint = 230;
		
		/**
         * Dead flag.
		 * 
		 * @see Update()
         */
		protected var _dead:Boolean = false;
		
		public function FlyingSpaMonst() 
		{
			_map = new Spritemap(GraphicConstants.FLYING_SPAGETTY_MONSTER_MAP, MAP_WIDTH, MAP_HEIGHT);
			_map.add(PLAY_FLOAT, [0, 1, 2], FLOAT_FPS, true);
						
			this.type = TYPE;
		}
		
		public function get tentacle():Tentacle 
		{
			return _tentacle;
		}
		
		public function set tentacle(value:Tentacle):void 
		{
			_tentacle = value;
		}
			
		public function set target(target:Entity):void
		{
			this._target = target;
			
			this._tentacle = new Tentacle(this._target, this._tenticleLength);
			
			this._tentacle.x = this.x + this._map.width/2 - 10;
			this._tentacle.y = this.y + this._map.height / 2 - 15;
			
			FP.world.add(this._tentacle);
		}
		
		public function get target():Entity
		{
			return this._target;
		}
		
		override public function removed():void
		{	
			super.removed();
			
			if (this._tentacle != null)
			{
				FP.world.remove(this._tentacle);
				
				if (this.tentacle.explosionEntity != null)
					FP.world.remove(this.tentacle.explosionEntity);
			}
		}
		
		/**
         * Call when the entity is to be destroyed
         */
		public function die():void
		{
			this._dead = true;
			this.collidable = false;
			this._tentacle.collidableSetter = false;
			this._tentacle.visible = false;
		}
		
		override public function added():void
		{
			this.addGraphic(_map);
			
			this._map.play(PLAY_FLOAT);			
								
			this.setHitbox(100, 83);
			
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
			
			if (FP.rand(2) > 0)
				this.x = -5;
			else
				this.x = FP.width - 125;
			
			super.added();
		}
		
		override public function update():void
		{
			super.update();
			
			if (this._dead)
			{
				if (this._map.scale <= 0)
					FP.world.remove(this);
				else
					this._map.scale -= 0.05;
			}
			
			this.y += FP.elapsed * this._currentSpeed;
			
			if (this.y < -this._map.height || this.y > (FP.height + this._map.height))
				FP.world.remove(this);
			
			if (this._target != null && this._tentacle != null)
			{
				this._tentacle.x = this.x + this._map.width/2 - 10;
				this._tentacle.y = this.y + this._map.height / 2 - 15;
			}
		}
	}

}