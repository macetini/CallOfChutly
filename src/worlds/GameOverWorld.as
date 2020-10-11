package worlds 
{
	import meta.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	import util.SoundUtil;
	import util.ResourcesUtil;
	
	/**
	 * Game over world. Shown when player dies. Restart the level when player clicks.
	 *
	 * @author Marko Cetinic
	 */
	
	public class GameOverWorld extends World 
	{
		private var _gameOverText:Text;
		private var _info:Text;
		private var _scoreText:Text;
		
		private var _tryAgainText:Text;
		
		private var _sadChutly:Image;
		
		public function GameOverWorld() 
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
			SoundUtil.playGroan();
			
			_gameOverText = new Text(grs("gameOver_l"));
			_gameOverText.size = 75;

			_gameOverText.x = (FP.width - _gameOverText.width) / 2;
			_gameOverText.y = 30;
			
			this.addGraphic(_gameOverText);
			
			_sadChutly = new Image(GraphicConstants.CHUTLY_SAD);
			_sadChutly.x = (FP.width - 100)/2;
			_sadChutly.y = 125;
			this.addGraphic(_sadChutly);
			
			_info = new Text(grs("gameOveInfo_l"));
			_info.size = 30;
			_info.x =  (FP.width - _info.width) / 2;
			_info.y = 230;
			this.addGraphic(_info);
			
			_scoreText = new Text(grs("score_l") + GameVariables.Score);
			_scoreText.size = 50;
			
			_scoreText.x = (FP.width - _scoreText.width) / 2;
			_scoreText.y = 290;
			
			this.addGraphic(_scoreText);
			
			_tryAgainText = new Text(grs("clicToCont_l"));
			_tryAgainText.size = 40;
			
			_tryAgainText.x = (FP.width - _tryAgainText.width) / 2;
			_tryAgainText.y = 380;
			
			this.addGraphic(_tryAgainText);
			
			super.begin();
		}
		
		override public function update():void
		{
			//restart level
			if(Input.mousePressed)
			{
				// Handle contitions for going to next world.
				this.removeAll();
				FP.world = new GameVariables.LastWorld;
			}
			
			super.update();
		}
		
	}

}