package worlds.levelsInfo 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import worlds.GameWorld;
	import worlds.IntroWorld;
	import worlds.levels.interfaces.ILevel;
	import worlds.levels.World7;
	import entities.allies.*;
	import entities.points.*;
	import meta.GraphicConstants;
	import worlds.WorldInfo;
	
	/**
	 * ...
	 * @author mc
	 */
	public class World7Info extends WorldInfo 
	{
		private var _info:Text;
		private var _contText:Text;
		
		private var _elderOneMap:Spritemap;
		private var _elederOneText:Text;
		
		public function World7Info() 
		{
			super();
			
			_info = new Text(grs("world7Info_l"));
			_info.size = 25;
			_info.x = (FP.width - _info.width) / 2;
			_info.y = 100;
			this.addGraphic(_info);
			
			_elderOneMap = new Spritemap(GraphicConstants.ELDER_ONE_SPRITE, ElderOne.MAP_WIDTH, ElderOne.MAP_HEIGHT);
			_elderOneMap.add(ElderOne.PLAY_ROTATE, [0, 1, 2, 3, 4, 5], ElderOne.ROTATE_FPS, true);
			_elderOneMap.x = (FP.width - _elderOneMap.width) / 2;
			_elderOneMap.y = _info.y + _info.size + 50;
			this.addGraphic(_elderOneMap);
			
			_elederOneText = new Text(grs("elederOne_l1") + ElderOne.VALUE + grs("elederOne_l2"));
			_elederOneText.size = 20;
			_elederOneText.x = (FP.width - _elederOneText.width) / 2;
			_elederOneText.y = _elderOneMap.y + _elderOneMap.height + 10;
			this.addGraphic(_elederOneText);
			
			_contText = new Text(grs("clicToCont_l"));
			_contText.size = 20;
			_contText.x = (FP.width - _contText.width) / 2;
			_contText.y = 400;
			this.addGraphic(_contText);
		}
		
		override public function begin():void
		{			
			super.begin();
			
			_elderOneMap.play(ElderOne.PLAY_ROTATE);
		}
		
		override public function update():void
		{
			super.update();
			
			if (Input.mousePressed)
			{
				// Handle contitions for going to next world.
				this.removeAll();
				
				var world7:ILevel = new World7;
				world7.initWorld();
				
				FP.world = world7 as GameWorld;
			}
		}
		
	}

}