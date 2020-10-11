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
	 
	public class GreenPlanet extends Planet
	{	
		public static const VALUE:int = 4;
		
		public static var Weight:Number = 5.0;
		
		public function GreenPlanet() 
		{
			super();
						
			_image = new Image(GraphicConstants.PLANET_GREEN);
			_image.centerOrigin();
		}
		
		override public function added():void
		{
			this.graphic = _image;
			
			super.added();
		}
		
	}

}