package worlds.levelsInfo 
{
	import entities.enemies.*;
	import entities.Chutly;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import meta.GraphicConstants;
	import worlds.GameWorld;
	import worlds.levels.interfaces.ILevel;
	import worlds.levels.World5;
	import worlds.WorldInfo;
	
	/**
	 * ...
	 * @author mc
	 */
	public class World5Info extends WorldInfo 
	{
		private var _info1:Text;
		private var _info2:Text;
		
		private var _flyingSpaMonstMap:Spritemap;
		private var _target:Entity;
		private var _tenticle:Tentacle;
		
		private var _contText:Text;
		
		public function World5Info() 
		{
			super();
			
			_info1 = new Text(grs("world5Info_l1"));
			_info1.size = 24;
			_info1.x = (FP.width - _info1.width) / 2;
			_info1.y = 100;
			
			this.addGraphic(_info1);
			
			_info2 = new Text(grs("world5Info_l2"));
			_info2.size = _info1.size;
			_info2.x = (FP.width - _info2.width) / 2;
			_info2.y = _info1.y + _info1.size + 10;
			
			this.addGraphic(_info2);
			
			_flyingSpaMonstMap = new Spritemap(GraphicConstants.FLYING_SPAGETTY_MONSTER_MAP, FlyingSpaMonst.MAP_WIDTH, FlyingSpaMonst.MAP_HEIGHT);
			_flyingSpaMonstMap.add(FlyingSpaMonst.PLAY_FLOAT, [0, 1, 2], FlyingSpaMonst.FLOAT_FPS, true);
			_flyingSpaMonstMap.play(FlyingSpaMonst.PLAY_FLOAT);
			_flyingSpaMonstMap.x = (FP.width - _flyingSpaMonstMap.width) / 2;
			_flyingSpaMonstMap.y = _info2.y + 85;
			
			this.addGraphic(_flyingSpaMonstMap);
			
			_target = new Entity;
			_target.width = Chutly.MAP_WIDTH;
			_target.height = Chutly.MAP_WIDTH;
			_target.x = Input.mouseX;
			_target.y = Input.mouseY;
			this.add(_target);
			
			_tenticle = new Tentacle(_target, 200);
			_tenticle.x = _flyingSpaMonstMap.x + _flyingSpaMonstMap.width / 2 - 10
			_tenticle.y = _flyingSpaMonstMap.y + _flyingSpaMonstMap.height / 2 - 15;
			this.add(_tenticle);			
			
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
				
				var world5:ILevel = new World5;
				world5.initWorld();
				
				FP.world = world5 as GameWorld;
			}
			
			_target.x = Input.mouseX;
			_target.y = Input.mouseY;
		}
		
	}

}