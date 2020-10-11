package UI 
{
	import flash.filters.*;
	import net.flashpunk.graphics.*;
	import util.SoundUtil;
	
	/**
	 * 
	 * Nice text class. Containes broder.
	 * 
	 * @author Marko Cetinic
	 */
	public class NiceText extends Text
	{
		/**
		 * Default Text Color
		 */
		public static const COLOR:uint = 0xFFfFFF;
		
		/**
		 * Mouse Over Text Color
		 */
		public static const HOVER_COLOR:uint = 0x00FF00;
		
		/**
		 * Outline color (border)
		 */
		public static const OUTLINE_COLOR:uint = 0xFF0000;

		/**
		 * Outline strength (border strength)
		 */
		public static const OUTLINE_STRENGTH:uint = 5;
		
		/**
		 * Mouse over flag.
		 */
		public var mouseOverFlag:Boolean = false;
		
		private var _outlineFilter:GlowFilter;
		
		public function NiceText(text:String, x:Number = 0, y:Number = 0, options:Object = null, h:Number = 0)
		{
			_outlineFilter = new GlowFilter(OUTLINE_COLOR, 1, OUTLINE_STRENGTH, OUTLINE_STRENGTH, OUTLINE_STRENGTH * 4);
			
			super(text, x, y, options, h);
		}
		
		override public function updateTextBuffer():void
		{			
			super.updateTextBuffer();
			
			_outlineFilter.blurX = _outlineFilter.blurY = OUTLINE_STRENGTH;
			_outlineFilter.strength = OUTLINE_STRENGTH * 4;
			_outlineFilter.color = OUTLINE_COLOR;
			_field.filters = [_outlineFilter];
		}
		
		override public function set text(value:String):void
		{
			super.text = value;
			updateColorTransform();
		}
		
		/**
		 * Mouse over handler Change color.
		 */
		public function mouseOver():void
		{
			if (!mouseOverFlag)
			{
				SoundUtil.playBlip2();
				mouseOverFlag = true;
			}
			
			_color = HOVER_COLOR;
			updateColorTransform();
		}
		
		/**
		 * Mouse not over handler Change color back.
		 */
		public function mouseNotOver():void
		{
			_color = COLOR;
			mouseOverFlag = false;
			updateColorTransform();
		}
	}

}