package worlds.levelsInfo
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import worlds.GameWorld;
	import worlds.levels.interfaces.ILevel;
	import worlds.levels.World3;
	import meta.*;
	import entities.allies.*;
	import entities.enemies.*;
	import worlds.WorldInfo;
	
	/**
	 * ...
	 * @author mc
	 */
	public class World3Info extends WorldInfo
	{		
		private var _info:Text;
		private var _contText:Text;
		
		private var _shipMap:Spritemap;
		private var _missleMap:Spritemap;
		
		private var _shipInfo1:Text;
		private var _shipInfo2:Text;
		
		private var _theta:Number;
		private var _r:Number;
		
		public function World3Info()
		{
			super();
			
			_theta = 0;
			_r = 150;
			
			_info = new Text(grs("world3Info_l"));
			_info.size = 25;
			_info.x = 50;
			_info.y = 50;
			this.addGraphic(_info);
			
			_shipMap = new Spritemap(GraphicConstants.SHIP_MAP, Ship.MAP_WIDTH, Ship.MAP_HEIGHT);
			_shipMap.add(Ship.PLAY_SPIN, [0, 1, 2], Ship.PLAY_SPIN_FPS, true);
			_shipMap.x = (FP.width - _shipMap.width) / 2
			_shipMap.y = _info.y + _info.height + 75;
			this.addGraphic(_shipMap);
			
			_missleMap = new Spritemap(GraphicConstants.MISSILE_MAP, Missile.MAP_WIDTH, Missile.MAP_HEIGHT);
			_missleMap.add(Missile.PLAY_FLY, [0, 1, 2, 3], Missile.PLAY_FLY_FPS, true);
			_missleMap.x = _shipMap.x + _r;
			_missleMap.y = _shipMap.y;
			this.addGraphic(_missleMap);
			
			_shipInfo1 = new Text(grs("shipInfo_l1"));
			_shipInfo1.size = 20;
			_shipInfo1.x = (FP.width - _shipInfo1.width) / 2;
			_shipInfo1.y = _shipMap.y + 75;
			this.addGraphic(_shipInfo1);
			
			_shipInfo2 = new Text(grs("shipInfo_l2"));
			_shipInfo2.size = 20;
			_shipInfo2.x = (FP.width - _shipInfo2.width) / 2;
			_shipInfo2.y = _shipInfo1.y + _shipInfo1.height + 10;
			this.addGraphic(_shipInfo2);
			
			_contText = new Text(grs("clicToCont_l"));
			_contText.size = 20;
			_contText.x = (FP.width - _contText.width) / 2;
			_contText.y = 400;
			this.addGraphic(_contText);
		}
		
		override public function begin():void
		{
			super.begin();
			
			_shipMap.play(Ship.PLAY_SPIN);
			_missleMap.play(Missile.PLAY_FLY);
		}
		
		override public function update():void
		{
			super.update();
			
			if (Input.mousePressed)
			{
				// Handle contitions for going to next world.
				this.removeAll();
				
				var world3:ILevel = new World3;
				world3.initWorld();
				
				FP.world = world3 as GameWorld;
			}
			
			var h:Number = _shipMap.x + 50;
			var k:Number = _shipMap.y + 40;
			
			var step:Number = 2 * Math.PI;
			
			if (_theta >= 0)
				_theta -= Math.PI / 180;
			else
				_theta = 2 * Math.PI;
				
			_missleMap.angle = uint(_theta * 180 / Math.PI);
			
			_missleMap.x = h + _r * Math.cos(_theta);
			_missleMap.y = k - _r * 0.5 * Math.sin(_theta);
		}
	}
}