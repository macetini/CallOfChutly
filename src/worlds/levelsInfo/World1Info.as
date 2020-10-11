package worlds.levelsInfo
{
	import entities.points.planets.*;
	import entities.Chutly;
	import entities.enemies.*;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import meta.GraphicConstants;
	import worlds.GameWorld;
	import worlds.levels.interfaces.ILevel;
	import worlds.levels.World1;
	import worlds.WorldInfo;
	
	/**
	 * ...
	 * @author mc
	 */
	public class World1Info extends WorldInfo
	{
		private var _moveChutlyText:Text;
		private var _chutlyMap:Spritemap;
		private var _keyboardImage:Image;
		
		private var _escImageText:Text;
		private var _escKeyImage:Image;
		
		private var _consumeInfo:Text;
		
		private var _cometImage:Image;
		private var _avoidText:Text;
		
		private var _bluePlanetImage:Image;
		private var _eatText:Text;
		
		private var _contText:Text;
		
		public function World1Info()
		{
			super();
			
			_moveChutlyText = new Text(grs("moveChutly_l"));
			_moveChutlyText.size = 30;
			_moveChutlyText.x = 60;
			_moveChutlyText.y = 35;
			this.addGraphic(_moveChutlyText);
			
			_chutlyMap = new Spritemap(GraphicConstants.CHUTLY_MAP, Chutly.MAP_WIDTH, Chutly.MAP_HEIGHT);
			_chutlyMap.add(Chutly.PLAY_IDLE, [0, 1, 2], Chutly.PLAY_IDLE_FPS, true);
			_chutlyMap.x = (FP.width - Chutly.MAP_WIDTH) / 2 - 200;
			_chutlyMap.y = 90;
			this.addGraphic(_chutlyMap);
			
			_keyboardImage = new Image(GraphicConstants.KEYBOARD_IMAGE);
			_keyboardImage.x = _chutlyMap.x + _chutlyMap.width + 40;
			_keyboardImage.y = _chutlyMap.y + 10;
			this.addGraphic(_keyboardImage);
			
			_escImageText = new Text(grs("pauseInfo_l"));
			_escImageText.size = _moveChutlyText.size;
			_escImageText.x = _moveChutlyText.x + 280;
			_escImageText.y = _moveChutlyText.y;
			this.addGraphic(_escImageText);
			
			_escKeyImage = new Image(GraphicConstants.ESC_KEY_IMAGE);
			_escKeyImage.x = _escImageText.x + _escImageText.width / 2 - _escKeyImage.width / 2;
			_escKeyImage.y = _keyboardImage.y;
			this.addGraphic(_escKeyImage);			
			
			_consumeInfo = new Text(grs("consume_l"));
			_consumeInfo.size = 25;
			_consumeInfo.x = _moveChutlyText.x;
			_consumeInfo.y = _moveChutlyText.y + 185;
			this.addGraphic(_consumeInfo);
			
			_bluePlanetImage = new Image(GraphicConstants.PLANET_BLUE);
			_bluePlanetImage.x = _chutlyMap.x;
			_bluePlanetImage.y = 270;;
			this.addGraphic(_bluePlanetImage);
			
			_eatText = new Text(grs("eat_l1") + BluePlanet.VALUE + grs("eat_l2"));
			_eatText.size = 20;
			_eatText.x = _chutlyMap.x + _bluePlanetImage.width + 40;
			_eatText.y = _bluePlanetImage.y + 8;
			this.addGraphic(_eatText);
			
			_cometImage = new Image(GraphicConstants.COMET_IMAGE);
			_cometImage.x = _bluePlanetImage.x + _bluePlanetImage.width / 2;
			_cometImage.y = _bluePlanetImage.y + _bluePlanetImage.height + 30;
			_cometImage.originX = _cometImage.width/2;
			_cometImage.originY = _cometImage.height/2;
			this.addGraphic(_cometImage);
			
			_avoidText = new Text(grs("avoid_l"));
			_avoidText.size = 20;
			_avoidText.x = _cometImage.x + _cometImage.width - 7;
			_avoidText.y = _bluePlanetImage.y + _bluePlanetImage.height + 10;
			this.addGraphic(_avoidText);
			
			_contText = new Text(grs("clicToCont_l"));
			_contText.size = 20;
			_contText.x = (FP.width - _contText.width) / 2;
			_contText.y = 400;
			this.addGraphic(_contText);
		}
		
		override public function begin():void
		{
			super.begin();
			
			_chutlyMap.play(Chutly.PLAY_IDLE);
		}
		
		override public function update():void
		{
			super.update();
			
			_cometImage.angle += FP.elapsed * Comet.SPIN_SPEED;
			
			if(Input.mousePressed)
			{
				// Handle contitions for going to next world.
				this.removeAll();
				
				var world1:ILevel = new World1;
				world1.initWorld();
				
				FP.world = world1 as GameWorld;
			}
		}
	}
}