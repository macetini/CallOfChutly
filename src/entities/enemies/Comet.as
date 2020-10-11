package entities.enemies
{
	import entities.enemies.interfaces.IEnemy;
	import meta.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	import util.*;
	import worlds.*;
	
	/**
	 * Comet enemy entety.
	 * 
	 * @author Marko Cetinic
	 */
	
	public class Comet extends Entity implements IEnemy
	{
		public static const TYPE:String = "comet";
		
		public static const MAX_SPEED:Number = 290;
		
		/**
         * Entity graphic rotation speed.
         */
		public static const SPIN_SPEED:Number = 720;
		
		/**
         * Emitt explosion number of times
         */
		public static const EXPLOSION_SIZE:uint = 100;
		
		/**
         * Explosion emitter trail
         */
		public static const EMITT_TRAIL:String = "trail";
		
		/**
         * Explosion emitter trail size
         */
		public static const EMITT_TRAIL_SIZE:uint = 70;
		
		/**
         * Explosion emitter name
         */
		public static const EMITT_EXPLODE:String = "explode";
		
		/**
         * Emitt explosion size
         */
		public static const EMITT_EXPLODE_SIZE:uint = 10;
		
		public static const IMAGE_RADIUS:uint = 40;
		
		/**
         * Entity weight
         */
		public static var Weight:Number = 15;
		
		/**
         * Hitbox size reduction value.
         */
		protected var _hitBoxSlice:int = 20;
		
		protected var _image:Image;
		
		protected var _currentSpeed:Number;
		protected var _currentSpinSpeed:Number;

		protected var _trailEmitter:Entity;
		protected var _explosionEmitter:Entity;
		
		public function Comet()
		{	
			_image = new Image(GraphicConstants.COMET_IMAGE);
			_image.centerOrigin();
			_image.smooth = true;
			
			this.addGraphic(_image);
			
			//comet trail emitter
			var trailEmitter:Emitter = new Emitter(GraphicConstants.COMET_PARTICLE, EMITT_TRAIL_SIZE, EMITT_TRAIL_SIZE);
			trailEmitter.newType(EMITT_TRAIL, [0, 1, 2, 3]);
			trailEmitter.setMotion(EMITT_TRAIL, 0, 1, 1, 360, 10, 1, Ease.cubeOut);
			trailEmitter.setAlpha(EMITT_TRAIL, 0.5, 0);
			
			_trailEmitter = FP.world.addGraphic(trailEmitter);
			
			//comet explosion emitter
			var explosionEmitter:Emitter = new Emitter(GraphicConstants.RED_PARTICLE, EMITT_EXPLODE_SIZE, EMITT_EXPLODE_SIZE);
			explosionEmitter.newType(EMITT_EXPLODE, [0]);
			explosionEmitter.setAlpha(EMITT_EXPLODE, 1, 0);
			explosionEmitter.setMotion(EMITT_EXPLODE, 0, 100, 1, 360, -40, -0.5, Ease.quadOut);
			explosionEmitter.relative=false;

			_explosionEmitter = FP.world.addGraphic(explosionEmitter);
			
			this.type = TYPE;
		}
		
		override public function removed():void
		{
			super.removed();
			
			FP.world.remove(_trailEmitter);
			FP.world.remove(_explosionEmitter);
		}
		
		//explode after death
		public function die():void
		{
			this.collidable = false;
			_image.visible = false;
			
			SoundUtil.playFireballExplode();
			
			for (var i:uint=0; i < EXPLOSION_SIZE; i++)
				(_explosionEmitter.graphic as Emitter).emit(EMITT_EXPLODE, x, y);
		}
		
		override public function added():void
		{
			this.addGraphic(_image);
			
			this.setHitbox(IMAGE_RADIUS - _hitBoxSlice, IMAGE_RADIUS - _hitBoxSlice, (IMAGE_RADIUS - _hitBoxSlice)/2, (IMAGE_RADIUS - _hitBoxSlice)/2);
			
			if (FP.rand(2) > 0)
			{
				this.x = FP.width + this.halfWidth;
				
				this._currentSpeed = -MAX_SPEED;
				this._currentSpinSpeed = SPIN_SPEED;
				
				this._image.flipped = true;
			}
			else
			{
				this.x = -halfWidth;
				this._currentSpeed = MAX_SPEED;
				this._currentSpinSpeed = -SPIN_SPEED;
			}
			
			y = FP.rand(FP.height - this.height);
			
			super.added();
		}
		
		/**
		 * 
		 * Comet trail emitter.
		 * 
		 * @param	xLocation X coordinate location.
		 * @param	yLocation Y coordinate location.
		 */
		public function emitFireball(xLocation:int, yLocation:int):void
		{
			(_trailEmitter.graphic as Emitter).emit(EMITT_TRAIL, xLocation - _hitBoxSlice, yLocation - _hitBoxSlice);
		}
		
		override public function update():void
		{			
			if (this.collidable)
			{
				x += FP.elapsed * this._currentSpeed;
				
				emitFireball(this.x - this.width + 5, this.y - this.height + 3);
				
				//rotate graphic
				_image.angle += FP.elapsed * this._currentSpinSpeed;
			}

			if (x < -width || x > (FP.width + width))
			{
				FP.world.remove(this);
			}
			
			if (!this.collidable && (_explosionEmitter.graphic as Emitter).particleCount == 0)
			{
				_image.visible = true;
				this.collidable = true;
				
				FP.world.remove(this);
			}
			
			super.update();
		}
	}
}