package worlds.levels.interfaces 
{
	
	/**
	 * Level interface is implemented by all playable Worlds
	 * 
	 * @author Marko Cetinic
	 */
	public interface ILevel 
	{
		/**
		 * Called when the world is first created
		 */
		function initWorld():void;
		
		/**
		 * Called called every time new world is created
		 */
		function increaseDifficulty():void;
		
		/**
		 * Called called every time new world is to be initiated
		 */
		function get levelNextScore():uint;
	}
	
}