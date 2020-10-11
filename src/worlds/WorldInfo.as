package worlds 
{
	import net.flashpunk.World;
	import util.ResourcesUtil;
	
	/**
	 * Worlds info base class.
	 * 
	 * @see worlds.levels.World*
	 * 
	 * @author Marko Cetinic
	 */
	public class WorldInfo extends World 
	{
		
		public function WorldInfo() 
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
		
	}

}