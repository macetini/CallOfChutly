package UI
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import util.SoundUtil;
	
	/**
	 *
	 * Nice text entity, entity for NiceText graphic.
	 *
	 * @see UI.NiceText
	 *
	 * @author Marko Cetinic
	 */
	public class NiceTextEnt extends Entity
	{
		protected var _niceText:NiceText;
		
		public function NiceTextEnt(text:String, x:Number = 0, y:Number = 0, options:Object = null, h:Number = 0)
		{
			_niceText = new NiceText(text, x, y, options, h);
			
			this.graphic = _niceText;
		}
		
		/**
		 *
		 * Nice Text graphic getter.
		 *
		 */
		public function get textGraphic():NiceText
		{
			return this.graphic as NiceText;
		}
		
		/**
		 *
		 * Nice Text graphic setter.
		 *
		 * @param niceText New text to set.
		 */
		
		public function set textGraphic(niceText:NiceText):void
		{
			_niceText = niceText;
			this.graphic = _niceText;
		}
		
		override public function update():void
		{
			var niceTextEnt:NiceTextEnt = FP.world.collidePoint(this.type, FP.world.mouseX, FP.world.mouseY) as NiceTextEnt;
			
			if (niceTextEnt != null)
				_niceText.mouseOver();
			else
				_niceText.mouseNotOver();
			
			if (Input.mouseReleased && _niceText.mouseOverFlag)
				SoundUtil.playBlip1();
			
			super.update();
		}
	}
}