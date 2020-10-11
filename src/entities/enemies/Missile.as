package entities.enemies
{
	import entities.Chutly;
	import entities.enemies.interfaces.IEnemy;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import meta.GraphicConstants;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Ease;
	import util.SoundUtil;
	
	/**
	 * Homing missle.
	 * 
	 * @see Ship class
	 * 
	 * @author Matt McFarland
	 */
	public class Missile extends Entity implements IEnemy
	{
		public static const TYPE:String = "missle";
		
		/**
         * Emitt explosion number of times
         */
		public static const EXPLOSION_SIZE:uint = 100;
		
		public static const EMITT_EXPLODE:String = "explode";
		
		public static const PLAY_FLY:String = "fly";
		public static const PLAY_FLY_FPS:uint = 12;
		
		public static const MAP_WIDTH:uint = 30;
		public static const MAP_HEIGHT:uint = 73;
		
		public static const EMITT_EXPLOSION_SIZE:uint = 10;
		
		//We'll be setting our turn speed to 100 pixels per second, and our velocity to 200 missiles per second.
		public static const TURN_SPEED:Number = 100;
		public static const MAX_SPEED:Number = 500;
		public static const MIN_SPEED:Number = 230;
		public static const DEACCELERATE:Number = 10;
		
		public static var Speed:Number = MAX_SPEED;
		
		//We'll be converting degrees to radians, and since we dont need to do that every frame we'll juse use
		//the RAD constant.  You can find this in FP.RAD as well, but FP.RAD is erronously set to -180 not 180.
		public static const RAD:Number = Math.PI / 180;
		//We'll set the lifespan of the missle to 2 seconds, and we'll be using a timer to test it.
		public static const LIFE:Number = 1.8;
		protected var _lifeTimer:Number = 0;
		//To get the missiles to follow their trajectories and turn at angles we'll need some maths.
		//I do not understand the mathematics to a degree which I am comfortable with explaining.
		protected var _vx:Number;
		protected var _vy:Number;
		protected var _angle:Number;
		protected var _targetDir_x:Number;
		protected var _targetDir_y:Number;
		
		protected var _map:Spritemap;
		
		//We'll be storing the target entity as a variable within the missile.  This allows us to easily recognize
		//our missiles target.
		protected var _target:Entity;
		
		protected var _explosionEmitter:Emitter;
		
		//The Constructor will create a missile pointing at a 90 degree angle,
		//it's x and y parameters are set when the missile is created by the player
		//and it uses a white rectangle for it's graphic.
		public function Missile(x:Number, y:Number)
		{
			//image = Image.createRect(8, 8);
			
			_map = new Spritemap(GraphicConstants.MISSILE_MAP, MAP_WIDTH, MAP_HEIGHT);
			_map.add(PLAY_FLY, [0, 1, 2, 3], PLAY_FLY_FPS, true);
			_map.centerOrigin();
			
			super(x, y);
			
			_angle = 90;
			
			_explosionEmitter = new Emitter(GraphicConstants.WHITE_PARTICLE, EMITT_EXPLOSION_SIZE, EMITT_EXPLOSION_SIZE);
			
			// Define our particles
			_explosionEmitter.newType(EMITT_EXPLODE, [0]);
			_explosionEmitter.setAlpha(EMITT_EXPLODE, 1, 0);
			_explosionEmitter.setMotion(EMITT_EXPLODE, 0, 100, 1, 360, -40, -0.5, Ease.quadOut);
			_explosionEmitter.relative = false;
			
			addGraphic(new Graphiclist(_map, _explosionEmitter));
			
			this.type = TYPE;
		}
		
		override public function added():void
		{
			super.added();
			
			var hitBoxSize:int = 40;
			this.setHitbox(hitBoxSize, hitBoxSize, hitBoxSize/2, hitBoxSize/2);
			
			_map.play(PLAY_FLY);
		}
		
		//The update method runs every frame.  We'll be making sure we have a target, and propel the
		//missile forward.
		override public function update():void
		{
			if (this.collidable)
			{
				//Find out if we need a target or not.  if the missiles target:entity is null then we'll run
				//the getNewTarget function. Otherwise, we'll run the chaseTarget function to do some maths
				//to adjust the angle of the missile.
				if (!_target)
					getNewTarget();
				if (_target)
					turnTowardsTarget();
				//Update the movement.
				//This code here moves the missile forward at the angle it is facing
				
				if (Speed > MIN_SPEED)
					Speed -= DEACCELERATE;
				
				_vx = Speed * Math.sin(_angle * RAD) * FP.elapsed;
				_vy = Speed * Math.cos(_angle * RAD) * FP.elapsed;
				x += _vx;
				y += _vy;
				//This code rotates the images angle to the angle property of the missile
				//image.angle = angle;
				_map.angle = _angle;
				
				//here we test the timer and see if the missiles life has expended.
				_lifeTimer += FP.elapsed;
				if (_lifeTimer > LIFE)
					die();
			}
			
			if (!this.collidable && _explosionEmitter.particleCount == 0)
			{
				_map.visible = true;
				this.collidable = true;
				
				FP.world.remove(this);
			}
		}
		
		/**
		 * Gets a new target and stores it as a variable
		 */
		private function getNewTarget():void
		{
			//the get new target function simply makes the target property of the missile = to the
			//nearest enemy.  Once the missile has a target, it will chase that one and avoid all other
			//enemies.  The missile essentially has locked on to a new target.
			_target = world.nearestToEntity(Chutly.TYPE, this);
		}
		
		//The turnTowardsTarget method tells the missile to turn either left or right at its turnspeed.
		//we'll be using maths to determine which way the missile should turn, and the goal is to
		//make the missile turn toward its target.  
		private function turnTowardsTarget():void
		{
			//make vector pointing from missile to target
			_targetDir_x = (_target.x - x);
			_targetDir_y = (_target.y - y);
			
			//rotate missile 90 deg from (x,y) to (y,-x)
			//then if the dot product says its perpendicular, it actually means its parallel
			//if the line from missile to target is parallel with the angle of the missile,
			//the missile is pointing at the target//
			
			if (_vy * _targetDir_x - _vx * _targetDir_y > 0)
				_angle += TURN_SPEED * FP.elapsed;
			else
				_angle -= TURN_SPEED * FP.elapsed;
		}
		
		//The detonate function will create a new explosion object, and then remove the missile from the
		//world.
		public function die():void
		{
			if (this.world && _map.visible)
			{
				SoundUtil.playFireballExplode();
				
				this.collidable = false;
				_map.visible = false;
				
				for (var i:uint = 0; i < EXPLOSION_SIZE; i++)
					_explosionEmitter.emit(EMITT_EXPLODE, x, y);
			}
		}
	}

}