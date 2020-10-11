package entities.points.planets 
{
	import entities.points.Planet;
	import meta.GraphicConstants;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Derived class from Planet class
	 * 
	 * @see entities.points.Planet
	 * 
	 * @author Marko Cetinic
	 */
	 
	public class DeadPlanet extends Planet
	{		
		public static const VALUE:int = -2;
		
		public static var Weight:Number = 5.0;
				
		public function DeadPlanet() 
		{
			super();
			
			_image = new Image(GraphicConstants.PLANET_DEAD);
			_image.centerOrigin();
		}
		
		override public function added():void
		{
			this.graphic = _image;
			
			super.added();
		}
		
	}

}