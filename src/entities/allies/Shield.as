package entities.allies
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	
	/**
	 * 
	 * Shield effect entity
	 * 
	 * @author Marko Cetinic
	 * 
	 */
	public class Shield extends Entity
	{
		protected var _target:Entity;
		protected var _color:uint;
		
		protected var _drawCounter:int;
		protected var _vib:Number;
		protected var _step:Number;
		
		protected var _xEllipse:Number;
		protected var _yEllipse:Number;
		
		protected var _xOffset:Number;
		protected var _yOffset:Number;
		
		protected var _pX1:Number;
		protected var _pY1:Number;
		
		protected var _pX2:Number;
		protected var _pY2:Number;
		
		private var _resetCounter:int;
		
		/**
		 * Shield class constructor
		 *
		 * @param target Create shield around target.
		 * @param color Shield color.
		 * @param frames Render after number of frames.
		 * @param xOffset Shield X coordinate offset.
		 * @param yOffset Shield Y coordinate offset.
		 * @param xEllipse Shield X coordinate verticaly. Lower value to squash more.
		 * @param yEllipse Squash Y coordinate horizontaly. Lower value to squash more.
		 * @param vib Shield point vibration value.
		 * @param step Draw point after step degrees.
		 *
		 */
		
		public function Shield(target:Entity, color:uint = 0xFFFFFF, drawCounter:int = 30, xOffset:int=0, yOffset:int=0, xEllipse:Number = 1, yEclipse:Number = 1, vib:int = 2, step:int = 30)
		{
			this._target = target;
			this._color = color;
			
			this._drawCounter = drawCounter;
			this._resetCounter = _drawCounter;
			
			this._xOffset = xOffset;
			this._yOffset = yOffset;
			
			this._xEllipse = xEllipse;
			this._yEllipse = yEclipse;
			
			this._vib = vib;
			this._step = step;
		}
		
		/**
		 * Init function, call when wish to initiate lightning effect.
		 *
		 */
		protected function returnVibOffset():Number
		{
			return this._vib * -0.5 + Math.random() * this._vib * 2;
		}
		
		override public function render():void
		{
			if (this._target.world == null)
				return;
			
			//add offset to shield origin coodinates
			var h:Number = this._target.x + this._xOffset;
			var k:Number = this._target.y + this._yOffset;
			
			//shield radius
			var r:Number = this._target.halfHeight + 15;
			
			//shield circle render step (degrees)
			var step:Number = 2 * Math.PI / this._step;
		
			//shield circle - draw point after step degrees.
			for (var theta:Number = 0; theta <= 360; theta += step)
			{
				//render after counter finishes
				if (_drawCounter >= 0)
					this._drawCounter--;
				else
				{
					this._drawCounter = this._resetCounter;
					
					_pX1 = h + this._xEllipse * r * Math.cos(theta) + returnVibOffset();
					_pY1 = k - this._yEllipse * r * Math.sin(theta) + returnVibOffset();
					
					_pX2 = h + this._xEllipse * r * Math.cos(theta + step) + returnVibOffset();
					_pY2 = k - this._yEllipse * r * Math.sin(theta + step) + returnVibOffset();
				}
				
				Draw.line(_pX1, _pY1, _pX2, _pY2, _color);
			}
			
			super.render();
		}
	}
}