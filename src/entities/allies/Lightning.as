package entities.allies
{
	import flash.geom.*;
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	
	/**
	 * Dynamic Lightning effect entity.
	 *
	 * @author Marko Cetinic
	 */
	
	public class Lightning extends Entity
	{		
		/**
         * Graphic Y coordinate offset from source Y coordinate
         */
		public static const SOURCE_Y_OFFSET:int = -23;
		
		/**
         * Graphic X coordinate offset from source X coordinate
         */
		public static const SOURCE_X_OFFSET:int = 0;
		
		protected var _source:Entity;
		protected var _target:Entity;
		
		protected var _colors:Array;
		
		protected var _distance:uint;
		
		protected var _points:Array;
		
		protected var _vib:Number;
		
		protected var _quantity:int;
		
		protected var _size:Number;
		
		public function Lightning()
		{
			_points = new Array;
		}
		
		/**
		 * Init function, call when wish to initiate lightning effect.
		 *
		 * @param source Lighting origin.
		 * @param target Target to hit
		 * @param colors Array of colors
		 * @param distance Maximum distance, if origin and target distance is greater than passed, then lightning effect stops. Set to 0 if no maximum distance present.
		 * @param vibration Lightning path offset i.e. vibration
		 * @param quantity Quantity of points
		 * @param size Size of points
		 *
		 */
		public function init(source:Entity, target:Entity, colors:Array, distance:uint=0, vibration:Number = 3, quantity:int = 2, size:Number = 10):Lightning
		{
			this._source = source;
			this._target = target;
			this._colors = colors;
			this._distance = distance;
			this._vib = vibration;
			this._quantity = quantity;
			this._size = size;
			
			return this;
		}

		override public function render():void
		{	
			super.render();
			
			//render effect if source entity present at world
			if (this._source.world != null && this._target.world != null)
			{
				//if distance between source and target greater tha _distance var then remove effect
				if ((this._distance > 0 && FP.distance(this._source.x, this._source.y, this._target.x, this._target.y) > this._distance))
				{
					FP.world.remove(this);
					return;
				}
				
				var distance:Number = FP.distance(this._source.x + SOURCE_X_OFFSET, this._source.y + SOURCE_Y_OFFSET, this._target.x, this._target.y);
				var angle:Number = FP.angle(this._source.x + SOURCE_X_OFFSET, this._source.y + SOURCE_Y_OFFSET, this._target.x, this._target.y) * FP.RAD;
				var pointcount:int = int(distance / this._size);
				
				this._points.length = 0;
				
				var p:int;
				
				this._points.push(new Point(this._source.x + SOURCE_X_OFFSET, this._source.y + SOURCE_Y_OFFSET));
				
				//create points along straight line between source and target
				for (p = 1; p < pointcount; p++)
				{
					this._points.push(new Point(this._source.x + SOURCE_X_OFFSET + Math.cos(angle) * p * this._size, this._source.y + SOURCE_Y_OFFSET + Math.sin(angle) * p * this._size));
				}
				this._points.push(new Point(this._target.x, this._target.y));
				
				//create multiple lines of points
				for (var q:int = 0; q < this._quantity; q++)
				{
					//add random value to the points (vibration)
					for (p = 1; p < pointcount; p++)
					{
						this._points[p].x += this._vib * -0.5 + Math.random() * this._vib * 2;
						this._points[p].y += this._vib * -0.5 + Math.random() * this._vib * 2;
					}
					
					//draw lightning
					var color:uint = this._colors[FP.rand(this._colors.length)];
					for (p = 1; p < pointcount + 1; p++)
					{
						Draw.line(this._points[p - 1].x, this._points[p - 1].y, this._points[p].x, this._points[p].y, color);
					}
				}
				
			}
			else
				FP.world.remove(this);
		
		}
	}
}