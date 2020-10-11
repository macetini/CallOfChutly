package entities.enemies
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import meta.GameVariables;
	
	/**
	 * Tentacle Class used by FlyinfSpaMonst. Draws sinus wave tentacle.
	 *
	 * @author Marko Cetinic
	 */
	
	public class Tentacle extends Entity
	{	
		public static const TYPE:String = "tentacle";
		public static const TENTICLE_COLOR:uint = 0xCDBE7A;
		
		/**
         * Used by children tenticle elem.
		 * 
		 * @see TentacleElem
         */
		public var explosionEntity:Entity;
		
		protected var _target:Entity;
		
		protected var _distance:int;
		protected var _maxDistance:int;
		
		protected var _speed:int;
		
		protected var _waveHeight:int;
		protected var _maxWaveHeight:int;
		
		protected var _waveLenght:int;
		protected var _maxWaveLenght:int;
		
		protected var _tentacleRadius:int;
		
		/**
         * Tentacle growt direction. +1 to grow out, -1 to shrink
		 * 
		 * @see changeGrowthDirection()
         */
		protected var _growthDirection:int;
		
		protected var _tentacleArr:Array;
		
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
		 * @param target Tearget to hit with tentacle.
		 * @param distance Tentacle distance.
		 * @param speed Tentcle creation speed.
		 * @param tentacleRadius Tentacle elem radius.
		 * @param waveHeight Amplitude or Wave height.
		 * @param waveLength Period or Wave length.
		 *
		 */
		public function Tentacle(target:Entity, distance:int, speed:int=2, tentacleRadius:int=3, waveHeight:int=6, waveLenght:int=20)
		{
			this._target = target;
			
			this._speed = speed;
			
			this._maxDistance = distance;
			this._maxDistance = _maxDistance / _speed;
			this._distance = 0;
			
			this._waveHeight = waveHeight;
			this._maxWaveHeight = this._waveHeight;
			
			this._waveLenght = waveLenght;
			this._maxWaveLenght = this._waveLenght;
			
			this._tentacleRadius = tentacleRadius;
						
			this._growthDirection = 1;
			
			this.type = TYPE;
		}
		
		override public function removed():void
		{
			super.removed();
			
			for each(var tenticleElem:TentacleElem in _tentacleArr)
				FP.world.remove(tenticleElem);
		}
		
		/**
		 * Set tentacle elements collidable setter
		 *
		 * @param collidable value
		 *
		 */
		public function set collidableSetter(value:Boolean):void
		{
			this.collidable = value;
			
			for each(var tenticleElem:TentacleElem in _tentacleArr)
				tenticleElem.collidable = value;
		}
		
		/**
		 * Change the growth direction of tentacle
		 */
		public function changeGrowthDirection():void 
		{
			this._growthDirection *= -1;
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
		private function returnSineWavePoint(speed:int, waveHeight:int, waveLength:int, yStartPosition:int):Point
		{
			this._x += speed;
			this._y = (waveHeight * Math.sin(this._x / waveLength)) + yStartPosition;
			
			var followX:int = this._target.x;// + this._target.halfWidth;
			var followY:int = this._target.y;// + this._target.halfHeight;
			
			var deltaX:int = followX - this.x;
			var deltaY:int = followY - this.y;
			
			//rotatation bering (follow the target)
			var bearing:int = Math.atan2(deltaY, deltaX) * 180 / Math.PI;
			
			var rotation:Number = bearing * Math.PI / 180;
			
			var rX:int = Math.cos(rotation) * (this._x - this.x) - Math.sin(rotation) * (this._y - this.y) + this.x;
			var rY:int = Math.sin(rotation) * (this._x - this.x) + Math.cos(rotation) * (this._y - this.y) + this.y;
			
			return new Point(rX, rY);
		}
		
		override public function render():void
		{
			//if paused don't update
			if (GameVariables.Pause)
			{
				super.render();
				return;
			}
			
			var tenticleElem:TentacleElem;
			
			//remove all tenticle entites from the last render
			for each(tenticleElem in _tentacleArr)
				FP.world.remove(tenticleElem);
			
			_tentacleArr = new Array;
			
			//New sinus wave point
			var sineWavePoint:Point;
			
			//Draw new tentacle
			for (var theta:Number = 0; theta < this._distance; theta += 1)
			{
				sineWavePoint = returnSineWavePoint(this._speed, this._waveHeight, this._waveLenght, this.y);
				
				Draw.circlePlus(sineWavePoint.x, sineWavePoint.y, this._tentacleRadius, TENTICLE_COLOR, 1, true, 1);
				
				//Add tentacle entitys for collision detection.
				if (theta % (this._tentacleRadius * 2) == 0)
				{	
					tenticleElem = new TentacleElem(this, this._tentacleRadius);
					tenticleElem.collidable = this.collidable;
					
					tenticleElem.x = sineWavePoint.x;
					tenticleElem.y = sineWavePoint.y;
			
					_tentacleArr.push(tenticleElem);
			
					FP.world.add(tenticleElem);
				}
			}

			//If players X position smaller than max distance start shrinking the tentacle
			if (this._distance >= this._maxDistance || this._distance < 0)
				changeGrowthDirection();
			
			if (this._distance < 0)
			{
				this._waveHeight = Math.random() * this._maxWaveHeight + this._maxWaveHeight - 3;
				this._waveLenght = Math.random() * this._maxWaveLenght + this._maxWaveLenght - 2;
			}
			
			this._distance += this._growthDirection;
			
			//helpers for returnSineWavePoint function
			this._x = this.x;
			this._y = this.y;
			
			super.render();
		}
	}
}