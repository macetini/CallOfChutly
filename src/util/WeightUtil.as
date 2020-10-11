package util
{
	import entities.allies.*;
	import entities.points.*;
	import entities.enemies.*;
	import entities.points.planets.*;
	
	import net.flashpunk.FP;
	
	/**
	 * Weight util class. Containes helper methods necessery for entity spawning.
	 * 
	 * @author Marko Cetinic
	 */
	public final class WeightUtil
	{
		/**
		 * Entites that can be spawned if allready present on screen.
		 */
		public static var multySpawnArr:Array = [BluePlanet, GreenPlanet, DeadPlanet, Comet];
		
		/**
		 * Entites that can't be spawned if allready present on screen.
		 */
		public static var singleSpawnArr:Array = [ShieldStar, LightningStar, Ship, Life, FlyingSpaMonst, ElderOneChain];
		
		/**
		 * 
		 * Entity timout update. If entity has defined Timeout than it cant be spawned until timeout has finished.
		 * 
		 * @param spawnArr Array of enteties.
		 * @param elapsed Elapsed time since the last frame.
		 */
		public static function updateTimeOut(spawnArr:Array, elapsed:Number):void
		{
			for each (var spawnElem:Class in spawnArr)
				if (spawnElem.TimeOutCounter != undefined)
					if (spawnElem.TimeOutCounter > 0)
					
						spawnElem.TimeOutCounter -= elapsed;
					else
						spawnElem.TimeOutCounter = 0;
		}
		
		/**
		 * 
		 * Returne new spawn based on etities Weight. The higer the weight higher the chances of spawn.
		 * 
		 * @param spawnArr Array of enteties.
		 */
		
		protected static function returnSpawn(spawnArr:Array):Class
		{
			var total:Number = 0.0;
			
			var localSpawnArr:Array = new Array;
			
			for each (var spawnElem:Class in spawnArr)
				if (spawnElem.TimeOutCounter == undefined || (spawnElem.TimeOutCounter != undefined && spawnElem.TimeOutCounter <= 0))
					localSpawnArr.push(spawnElem);
			
			for each (spawnElem in localSpawnArr)
				total += spawnElem.Weight;
			
			var thresh:int = FP.rand(total - 1);
			
			var i:int = 0;
			for (i = 0; i < localSpawnArr.length; i++)
			{
				thresh -= localSpawnArr[i].Weight;
				
				if (thresh <= 0)
					break;
			}
			
			return localSpawnArr[i];
		}
		
		/**
		 * 
		 * Returne new multy spawn.
		 * 
		 */
		
		public static function returnMultySpawn():Class
		{
			return returnSpawn(multySpawnArr);
		}
		
		/**
		 * 
		 * Returne new single spawn.
		 * 
		 */
		
		public static function returnSingleSpawn():Class
		{
			return returnSpawn(singleSpawnArr);
		}
	}
}