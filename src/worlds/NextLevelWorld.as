package worlds
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	import meta.*;
	import util.LevelsUtil;
	import util.SoundUtil;
	import util.ResourcesUtil;
	
	/**
	 *
	 * Next world World. Created wheny players reachec certain score.
	 *
	 * @author Marko Cetinic
	 */
	
	public class NextLevelWorld extends World
	{
		protected var _successText:Text;
		protected var _angryChutly:Image;
		protected var _info:Text;
		protected var _levelInfo:Text;
		protected var _nextLevelText:Text;
		
		public function NextLevelWorld()
		{
			super();
		}
		
		/**
		 *
		 * ResourcesUtil helper function
		 *
		 * @param resourceName resource key.
		 *
		 * @see ResourceUtil
		 *
		 * @return string from resource bundle
		 *
		 */
		public function grs(resourceName:String):String
		{
			return ResourcesUtil.grs(resourceName);
		}
		
		override public function begin():void
		{
			SoundUtil.playLaugh();
			
			_successText = new Text(grs("success_l"));
			_successText.size = 75;
			_successText.x = (FP.width - _successText.width) / 2;
			_successText.y = 15;
			this.addGraphic(_successText);
			
			_angryChutly = new Image(GraphicConstants.CHUTLY_ANGRY);
			_angryChutly.x = (FP.width - _angryChutly.width) / 2;
			_angryChutly.y = 125;
			this.addGraphic(_angryChutly);
			
			_info = new Text(grs("next_level_info_l"));
			_info.size = 30;
			_info.x = (FP.width - _info.width) / 2;
			_info.y = 250;
			this.addGraphic(_info);
			
			_levelInfo = new Text(grs("levelInfo_l") + LevelsUtil.LevelIndex + "/" + LevelsUtil.LEVELS_PER_WORLD + grs("levelInfo_l2") + LevelsUtil.WorldIndex);
			_levelInfo.size = 30;
			_levelInfo.x = (FP.width - _levelInfo.width) / 2;
			_levelInfo.y = 300;
			this.addGraphic(_levelInfo);
			
			_nextLevelText = new Text(grs("clicToCont_l"));
			_nextLevelText.size = 40;
			
			_nextLevelText.x = (FP.width - _nextLevelText.width) / 2;
			_nextLevelText.y = 380;
			
			this.addGraphic(_nextLevelText);
			
			super.begin();
		}
		
		override public function update():void
		{
			if (Input.mouseReleased)
			{
				// Handle contitions for going to next world.
				Input.mouseReleased = false;
				this.removeAll();
				LevelsUtil.nextLevel();
			}
			
			super.update();
		}
	}

}