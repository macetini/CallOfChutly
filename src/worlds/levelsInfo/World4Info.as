package worlds.levelsInfo 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import meta.GraphicConstants;
	import worlds.GameWorld;
	import worlds.levels.interfaces.ILevel;
	import worlds.levels.World4;
	import worlds.WorldInfo;
	
	/**
	 * ...
	 * @author mc
	 */
	public class World4Info extends WorldInfo
	{
		private var _info:Text;
		private var _contText:Text;
		
		private var _lifeImage:Image;
		private var _lifeText:Text;
		
		public function World4Info() 
		{
			super();
			
			_info = new Text(grs("world4Info_l"));
			_info.size = 25;
			_info.x = 100;
			_info.y = 100;
			this.addGraphic(_info);
			
			_lifeImage = new Image(GraphicConstants.HUD_HEART_FULL);
			_lifeImage.x = (FP.width - _lifeImage.width) / 2;
			_lifeImage.y = 200;
			this.addGraphic(_lifeImage);
			
			_lifeText = new Text(grs("life_l"));
			_lifeText.size = 20;
			_lifeText.x = (FP.width - _lifeText.width) / 2;
			_lifeText.y = _lifeImage.y + _lifeImage.height + 10;
			this.addGraphic(_lifeText);
			
			_contText = new Text(grs("clicToCont_l"));
			_contText.size = 20;
			_contText.x = (FP.width - _contText.width) / 2;
			_contText.y = 400;
			
			this.addGraphic(_contText);
		}
		
		override public function update():void
		{
			super.update();
			
			if (Input.mousePressed)
			{
				// Handle contitions for going to next world.
				this.removeAll();
			
				var world4:ILevel = new World4;
				world4.initWorld();
				
				FP.world = world4 as GameWorld;
			}
		}
		
	}

}