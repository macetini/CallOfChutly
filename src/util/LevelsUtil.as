package util
{
	import flash.display.Loader;
	import graphic.events.ContentEndEvent;
	import graphic.NiceMovieClipAsset;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import worlds.GameOverWorld;
	import meta.*;
	import worlds.IntroWorld;
	import worlds.levels.interfaces.ILevel;
	import worlds.NextLevelWorld;
	import worlds.levels.*;
	import worlds.levelsInfo.*;
	
	/**
	 * Levels Util Class contains level helper methods.
	 * 
	 * @author Marko Cetinic
	 */
	
	public final class LevelsUtil
	{
		public static const LEVELS:Array = [World1, World2, World3, World4, World5, World6, World7, World8, World9, World10, World11, World12, World13, World14, World15];
		public static const LEVELS_INFO:Array = [World1Info, World2Info, World3Info, World4Info, World5Info, World6Info, World7Info];
		
		public static const LEVELS_PER_WORLD:uint = 4;
		
		protected static var _loader:Loader;
		
		/**
		*
		* Creates new NextLevelWorld that is (if necessery) shown to user.
		* 
		*/
		public static function nextLevelInfo():void
		{
			FP.world.removeAll();
			FP.world = new NextLevelWorld();
			
			if (GameVariables.Level < LEVELS.length * LEVELS_PER_WORLD)
				GameVariables.Level++;
		}
		
		protected static function contentEndHandler(e:ContentEndEvent):void
		{
			(e.target as NiceMovieClipAsset).removeEventListener(ContentEndEvent.CONTENT_END, contentEndHandler);
			
			SoundUtil.unMuteEffects();
			SoundUtil.unMuteMusic();
			
			FP.stage.removeChild(e.target.content);
			Input.mouseReleased = false;
			
			quit();
		}
		
		/**
		*
		* Creates new level (World class). If player reaches last level then End movie animation is loaded.
		* 
		*/
		private static function selectLevel():void
		{
			if (GameVariables.Level < LEVELS.length * LEVELS_PER_WORLD)
				var level:ILevel = new LEVELS[uint(GameVariables.Level / LEVELS_PER_WORLD)];
			else
			{
				SoundUtil.muteEffects();
				SoundUtil.muteMusic();
				
				FP.world.active = false;
				var imc:NiceMovieClipAsset = new NiceMovieClipAsset(GraphicConstants.END_MOVIE_CLIP);
				imc.addEventListener(ContentEndEvent.CONTENT_END, contentEndHandler);
				imc.load(true);
				
				return;
			}
			
			if (GameVariables.Level % LEVELS_PER_WORLD == 0)
				level.initWorld();
			
			level.increaseDifficulty();
			
			if (GameVariables.NextLevelScore < GameVariables.ScoreCap)
				GameVariables.NextLevelScore += level.levelNextScore;
			
			FP.world = level as World;
		}
		
		/**
		*
		* Selects new level or new level info.
		* 
		*/
		public static function nextLevel():void
		{
			GameVariables.LastWorld = returnCurrentWorldClass();
			
			FP.world.removeAll();
			
			if (GameVariables.Level % LEVELS_PER_WORLD == 0 && uint(GameVariables.Level / LEVELS_PER_WORLD) < LEVELS_INFO.length)
				FP.world = new LEVELS_INFO[GameVariables.Level / LEVELS_PER_WORLD];
			else
				selectLevel();
		}
		
		/**
		*
		* Returns world index.
		* 
		*/
		public static function get WorldIndex():uint
		{
			return uint(GameVariables.Level / LEVELS_PER_WORLD) + 1;
		}
		
		/**
		*
		* Returns level index.
		* 
		*/
		public static function get LevelIndex():uint
		{
			return GameVariables.Level % LEVELS_PER_WORLD + 1;
		}
		
		/**
		*
		* Returns current world class.
		* 
		*/
		public static function returnCurrentWorldClass():Class
		{
			return LEVELS[uint(GameVariables.Level / LEVELS_PER_WORLD)];
		}
		
		/**
		*
		* Restarts level (duh..)
		* 
		*/
		
		public static function restartLevel():void
		{
			FP.world.removeAll();
			FP.world = new GameVariables.LastWorld;
		}
		
		/**
		*
		* Quits game
		* 
		*/
		
		public static function quit():void
		{
			GameVariables.Level = 0;
			GameVariables.Score = 0;
			GameVariables.ScoreCap = GameConstants.INIT_SCORE_CAP;
			GameVariables.NextLevelScore = GameConstants.INIT_NEXT_LEVEL_SCORE;
			
			FP.world.removeAll();
			FP.world = new IntroWorld;
		}
	}
}