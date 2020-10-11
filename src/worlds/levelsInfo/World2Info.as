package worlds.levelsInfo 
{
	import entities.points.planets.*;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import worlds.GameWorld;
	import worlds.levels.interfaces.ILevel;
	import worlds.levels.World2;
	import worlds.levels.World3;
	import meta.*;
	import worlds.WorldInfo;
	
	/**
	 * ...
	 * @author mc
	 */
	public class World2Info extends WorldInfo 
	{
		private var _info:Text;
		
		private var _greenPlanet:Image;
		private var _greenPlanetText:Text;
		
		private var _deadPlanet:Image;
		private var _deadPlanetText:Text;
		
		private var _contText:Text;
		
		public function World2Info() 
		{
			super();
			
			_info = new Text(grs("world2Info_l"));
			_info.size = 25;
			_info.x = 50;
			_info.y = 100;
			
			this.addGraphic(_info);
			
			_greenPlanet = new Image(GraphicConstants.PLANET_GREEN);
			_greenPlanet.x = 150;
			_greenPlanet.y = _info.y + 100;
			
			this.addGraphic(_greenPlanet);
			
			_greenPlanetText = new Text(grs("greenPlanet_l1") + GreenPlanet.VALUE + grs("greenPlanet_l2"));
			_greenPlanetText.size = 20;
			_greenPlanetText.x = _greenPlanet.x + _greenPlanet.width + 20;
			_greenPlanetText.y = _greenPlanet.y + 7;
			
			this.addGraphic(_greenPlanetText);
			
			_deadPlanet = new Image(GraphicConstants.PLANET_DEAD);
			_deadPlanet.x = _greenPlanet.x + 5;
			_deadPlanet.y = _info.y + _greenPlanet.height + 130;
			
			this.addGraphic(_deadPlanet);
			
			_deadPlanetText = new Text(grs("deadPlanet_l1") + DeadPlanet.VALUE + grs("deadPlanet_l2"));
			_deadPlanetText.size = 20;
			_deadPlanetText.x = _deadPlanet.x + _deadPlanet.width + 17;
			_deadPlanetText.y = _info.y + 170;
			
			this.addGraphic(_deadPlanetText);
			
			_contText = new Text(grs("clicToCont_l"));
			_contText.size = 20;
			_contText.x = (FP.width - _contText.width) / 2;
			_contText.y = 400;
			
			this.addGraphic(_contText);
		}
		
		override public function update():void
		{
			super.update();
			
			if(Input.mousePressed)
			{
				// Handle contitions for going to next world.
				this.removeAll();
				
				var world2:ILevel = new World2;
				world2.initWorld();
				
				FP.world = world2 as GameWorld;
			}
		}
		
	}

}