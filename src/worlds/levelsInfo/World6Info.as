package worlds.levelsInfo 
{
	import entities.allies.*;
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
	import worlds.levels.World6;
	import worlds.WorldInfo;
	
	/**
	 * ...
	 * @author mc
	 */
	public class World6Info extends WorldInfo 
	{
		private var _info:Text;
		
		private var _shildStarMap:Spritemap;
		private var _shildStarText:Text;
		
		private var _lightningStarMap:Spritemap;
		private var _lightningText:Text;
		
		private var _contText:Text;
		
		public function World6Info() 
		{
			super();
			
			_info = new Text(grs("world6Info_l"));
			_info.size = 25;
			_info.x = (FP.width - _info.width) / 2;
			_info.y = 130;
			this.addGraphic(_info);
			
			_shildStarMap = new Spritemap(GraphicConstants.SHILD_STAR_MAP, ShieldStar.MAP_SIZE, ShieldStar.MAP_SIZE);
			_shildStarMap.add(ShieldStar.PLAY_TWINKLE, [0, 1, 2, 3, 4, 5, 6, 7], ShieldStar.PLAY_TWINKLES_FPS, true);
			_shildStarMap.x = (FP.width - _shildStarMap.width) / 4;
			_shildStarMap.y = _info.y + 70;
			this.addGraphic(_shildStarMap);
			
			_shildStarText = new Text(grs("shildStar_l"));
			_shildStarText.size = 20;
			_shildStarText.x = (FP.width - _shildStarMap.width) / 7;
			_shildStarText.y = _info.y + 130;
			this.addGraphic(_shildStarText);
						
			_lightningStarMap = new Spritemap(GraphicConstants.LIGHTNING_STAR_MAP, LightningStar.MAP_SIZE, LightningStar.MAP_SIZE);
			_lightningStarMap.add(LightningStar.PLAY_TWINKLE, [0, 1, 2, 3, 4, 5], LightningStar.PLAY_TWINKLE_FPS, true);
			_lightningStarMap.x = FP.width - 220;
			_lightningStarMap.y = _shildStarMap.y - 12;
			this.addGraphic(_lightningStarMap);
			
			_lightningText = new Text(grs("lightning_l"));
			_lightningText.size = _shildStarText.size;
			_lightningText.x = FP.width - 280;
			_lightningText.y = _shildStarText.y;
			this.addGraphic(_lightningText);
			
			_contText = new Text(grs("clicToCont_l"));
			_contText.size = 20;
			_contText.x = (FP.width - _contText.width) / 2;
			_contText.y = 400;			
			this.addGraphic(_contText);
		}
		
		override public function begin():void
		{
			super.begin();
			
			_shildStarMap.play(ShieldStar.PLAY_TWINKLE);
			_lightningStarMap.play(LightningStar.PLAY_TWINKLE);
		}
		
		override public function update():void
		{
			super.update();
			
			if (Input.mousePressed)
			{
				// Handle contitions for going to next world.
				this.removeAll();
				
				var world6:ILevel = new World6;
				world6.initWorld();
				
				FP.world = world6 as GameWorld;
			}
		}
		
	}

}