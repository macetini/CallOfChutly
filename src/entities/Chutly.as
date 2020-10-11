package entities
{
	import entities.allies.*;
	import flash.display.*;
	import meta.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	import util.*;
	import worlds.*;
	
	/**
	 * Player's entity class. Navigated by player around stage.
	 * 
	 * @author Marko Cetinic
	 */
	
	public class Chutly extends Entity
	{
		public static const TYPE:String = "chutly";
		
		public static const MAX_SPEED:Number = 300;
		
		/**
         * Emitt explosion number of times
         */
		public static const EXPLOSION_SIZE:uint = 100;
		public static const LIGHTNING_COLOR:uint = 0xFF0000;
		
		
		//sprites
		public static const PLAY_IDLE:String = "idle";
		public static const PLAY_LEFT:String = "left";
		public static const PLAY_RIGHT:String = "right";
		public static const PLAY_UP:String = "up";
		public static const PLAY_HIT:String = "hit"
		
		public static const PLAY_IDLE_FPS:uint = 6;
		public static const PLAY_LEFT_FPS:uint = 9;
		public static const PLAY_RIGHT_FPS:uint = 9;
		public static const PLAY_UP_FPS:uint = 13;
		public static const PLAY_HIT_FPS:uint = 10;
		
		public static const EMITT_EXPLODE:String = "explode";
		public static const EMITT_EXPLODE_SIZE:uint = 10;
		public static const EMITT_EXPLODE_COLOR:uint = 0x4BA94C;
		
		public static const MAP_WIDTH:uint = 65;
		public static const MAP_HEIGHT:uint = 92;
		
		/**
         *Hit Time, used to pervent multiple hits in the same time.
         */
		public static const CHUTLY_HIT_TIME:Number = .15;
		
		/**
         *Hit Timer, player invanurable
         */
		protected var _chutly_hit_counter:Number;
		
		protected var _map:Spritemap;
		protected var _explosionEmitter:Emitter;
		
		public function Chutly()
		{
			this._map = new Spritemap(GraphicConstants.CHUTLY_MAP, MAP_WIDTH, MAP_HEIGHT);
			
			this._map.add(PLAY_IDLE, [0, 1, 2], PLAY_IDLE_FPS, true);
			this._map.add(PLAY_LEFT, [3, 4, 5], PLAY_LEFT_FPS, true);
			this._map.add(PLAY_RIGHT, [6, 7, 8], PLAY_RIGHT_FPS, true);
			this._map.add(PLAY_UP, [9, 10, 11], PLAY_UP_FPS, true);
			this._map.add(PLAY_HIT, [12, 13, 14], PLAY_HIT_FPS, true);
			
			this._explosionEmitter = new Emitter(new BitmapData(EMITT_EXPLODE_SIZE, EMITT_EXPLODE_SIZE), EMITT_EXPLODE_SIZE, EMITT_EXPLODE_SIZE);
			this._explosionEmitter.newType(EMITT_EXPLODE, [0]);
			this._explosionEmitter.setAlpha(EMITT_EXPLODE, 1, 0);
			this._explosionEmitter.setMotion(EMITT_EXPLODE, 0, 100, 1, 360, -40, -0.5, Ease.quadOut);
			this._explosionEmitter.setColor(EMITT_EXPLODE, EMITT_EXPLODE_COLOR);
			this._explosionEmitter.relative = false;
			
			this.type = TYPE;
		}
		
		override public function added():void
		{
			super.added();
			
			this.addGraphic(_map);
			this._map.play(PLAY_IDLE);
			
			this._map.centerOrigin();
			
			var hitBoxOffset:int = 20;
			
			var mapWidthOffset:int = MAP_WIDTH - 26;
			var mapHightOffset:int = MAP_HEIGHT - 20;
			
			setHitbox(mapWidthOffset, mapHightOffset, mapWidthOffset/2 + 2, mapHightOffset/2);
			
			this.addGraphic(_explosionEmitter);
		}
		
		/**
		 * Hit the enemy with lightning
		 *
		 * @param target Target to hit.
		 * @param color Lightning color.
		 * @param distance Lightning active distance, 0 no distance.
		 *
		 */
		public function hitWithLightning(target:Entity, color:uint = LIGHTNING_COLOR, distance:uint = 0):void
		{
			var lightning:Lightning;
			
			lightning = new Lightning();
			lightning.init(this, target, [color], distance);
			
			FP.world.add(lightning);
		}
		
		/**
		 * Die handler function. Emitt explosion.
		 *
		 */
		public function die():void
		{
			this.collidable = false;
			this._map.visible = false;
			
			SoundUtil.playPlayeDieSound();
			
			for (var i:uint = 0; i < EXPLOSION_SIZE; i++)
			{
				this._explosionEmitter.emit(EMITT_EXPLODE, x, y);
			}
		}
		
		/**
		 * Hit handler function. Initate hit counter.
		 *
		 */
		public function hit():void
		{
			_chutly_hit_counter = CHUTLY_HIT_TIME;
		}
		
		override public function update():void
		{
			var moveUp:Boolean = false;
			var moveDown:Boolean = false;
			var moveLeft:Boolean = false;
			var moveRight:Boolean = false;
			
			var xInput:int = 0;
			var yInput:int = 0;
			
			var hit:Boolean = false;
			if (this._chutly_hit_counter > 0)
			{
				this._chutly_hit_counter -= FP.elapsed;
				hit = true;
			}
			
			var xOffset:int = 10;
			
			if (Input.pressed(Key.RIGHT) || Input.check(Key.RIGHT))
			{
				moveRight = true;
				
				if (this.x  + _map.width/2 - xOffset >= FP.stage.width)
					this.x = FP.stage.width - _map.width/2 + xOffset;
				else
					this.x -= MAX_SPEED * FP.elapsed * --xInput;
			}
			
			if (Input.pressed(Key.LEFT) || Input.check(Key.LEFT))
			{
				moveLeft = true;
				
				if (this.x - _map.width/2 + xOffset <= 0)
					this.x = _map.width/2 - xOffset;
				else
					this.x += MAX_SPEED * FP.elapsed * --xInput;
			}
			
			var yOffset:int = 5;
			
			if (Input.pressed(Key.UP) || Input.check(Key.UP))
			{
				moveUp = true;
				
				if (this.y <= _map.height/2 - yOffset)
					this.y = _map.height/2 - yOffset;
				else
					this.y += MAX_SPEED * FP.elapsed * --yInput;
			}
			
			if (Input.pressed(Key.DOWN) || Input.check(Key.DOWN))
			{
				moveDown = true;
				
				if (this.y + _map.height/2 - yOffset >= FP.stage.height)
					this.y = FP.stage.height - _map.height/2 + yOffset;
				else
					this.y -= MAX_SPEED * FP.elapsed * --yInput;
			}
			
			if (hit)
				this._map.play(PLAY_HIT);
			else if (moveLeft)
				this._map.play(PLAY_LEFT);
			else if (moveRight)
				this._map.play(PLAY_RIGHT);
			else if (moveUp || moveDown)
				this._map.play(PLAY_UP);
			else
				this._map.play(PLAY_IDLE);
			
			if (!this.collidable && _explosionEmitter.particleCount == 0)
			{
				FP.world.removeAll();
				FP.world = new GameOverWorld;
			}
			
			super.update();
		}
	}
}