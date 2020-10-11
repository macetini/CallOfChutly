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
	
	public class BluePlanet extends Planet
	{		
		public static const VALUE:int = 2;
		
		public static var Weight:Number = 15.0;
		
		public function BluePlanet() 
		{
			super();
			
			_image = new Image(GraphicConstants.PLANET_BLUE);
			_image.centerOrigin();
		}
		
		override public function added():void
		{
			this.graphic = _image;
			
			super.added();
		}
		
	}

}