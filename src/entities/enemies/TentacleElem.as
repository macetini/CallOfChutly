package entities.enemies
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.utils.Ease;
	import meta.GraphicConstants;
	
	/**
	 * Tentacle elem, used bay Tentacle class
	 * 
	 * @see Tentacle, FlyingSpaMost
	 * 
	 * @author Marko Cetinic
	 */
	
	public class TentacleElem extends Entity
	{
		public static const TYPE:String = "tentacleElem";
		
		public static const EXPLOSION_SIZE:uint = 10;
		
		protected const EMITT_EXPLODE:String = "explode";
		
		/**
		 * Tentacle elem parent.
		 *
		 * @see Tentacle class
		 *
		 */
		private var _parent:Tentacle;
		
		private var _tentacleRadius:uint;
		
		private var _explosionEmitter:Emitter;
		
		/**
		 * Tentacle element constructor.
		 *
		 * @param parent Tentacle elem parent
		 * @param tentacleRadius Tentacle elem radius.
		 *
		 */
		public function TentacleElem(parent:Tentacle, tentacleRadius:uint)
		{
			super();
			
			this._parent = parent;
			this._tentacleRadius = tentacleRadius;
			
			setHitbox(this._tentacleRadius * 2, this._tentacleRadius * 2, this._tentacleRadius, this._tentacleRadius);
			
			this.type = TYPE;
		}
		
		public function get parent():Tentacle
		{
			return _parent;
		}
		
		public function set parent(value:Tentacle):void
		{
			_parent = value;
		}
		
		public function emitExplosion():void
		{
			if (this.parent.explosionEntity == null)
			{
				this._explosionEmitter = new Emitter(GraphicConstants.RED_PARTICLE, 10, 10);
				this._explosionEmitter.newType(EMITT_EXPLODE, [0]);
				this._explosionEmitter.setAlpha(EMITT_EXPLODE, 1, 0);
				this._explosionEmitter.setMotion(EMITT_EXPLODE, 0, 50, 1, 360, -40, -0.5, Ease.quadOut);
				this._explosionEmitter.relative = false;
				
				this.parent.explosionEntity = FP.world.addGraphic(this._explosionEmitter);
			}
			
			for (var i:uint = 0; i < EXPLOSION_SIZE; i++)
				this._explosionEmitter.emit(EMITT_EXPLODE, x, y);
		}
	}
}