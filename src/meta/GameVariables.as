package meta
{
	/**
	 * 
	 * Global game variables.
	 * 
	 * @author Marko Cetinic
	 */
	
	import graphic.RandomBackground;
	import worlds.GameWorld;

	public final class GameVariables 
	{
		/**
		 * Randomizable random image
		 */
		public static var BackgroundImage:RandomBackground;
		
		/**
		 * Game pause
		 */
		public static var Pause:Boolean = false;
		
		/**
		 * Game mute level
		 * 
		 * <p>0 - mute all</p>
		 * <p>1 - mute music</p>
		 * <p>2 - unmute</p>
		 * 
		 */
		public static var MuteLevel:uint = 2;
		
		/**
		 * Mute music flag
		 */
		public static var MuteMusic:Boolean = false;
		
		/**
		 * Mute effects flag
		 */
		public static var MuteEffects:Boolean = false;
		
		/**
		 * Current level score
		 */
		public static var Score:uint = 0;
		
		/**
		 * Next level score
		 */
		public static var NextLevelScore:uint = GameConstants.INIT_NEXT_LEVEL_SCORE;
		
		/**
		 * Score cap
		 */
		public static var ScoreCap:uint = GameConstants.INIT_SCORE_CAP;
		
		/**
		 * Player health
		 */
		public static var ChutlyHealth:uint = 0;
		
		/**
		 * Current level
		 */
		public static var Level:uint = 0;
		
		/**
		 * Last initiated world
		 */
		public static var LastWorld:Class;
	}
}