package worlds.levels 
{
	import entities.allies.*;
	import entities.enemies.*;
	import entities.points.*;
	import entities.points.planets.*;
	import util.WeightUtil;
	import worlds.GameWorld;
	import worlds.levels.interfaces.ILevel;
	import meta.GameVariables;
	
	/**
	 * Level World
	 * @author Marko Cetinic
	 */
	public class World6 extends GameWorld implements ILevel 
	{
		private var _levelNextScore:uint = 5;
		
		public function World6() 
		{
			super();
			
			WeightUtil.singleSpawnArr = [Ship, Life, FlyingSpaMonst, ShieldStar, LightningStar];
			WeightUtil.multySpawnArr = [BluePlanet, GreenPlanet, DeadPlanet, Comet];
		}
		
		public function initWorld():void
		{
			GameVariables.ScoreCap = 100;
		}
		
		public function increaseDifficulty():void 
		{
			BluePlanet.Weight--;
		}
		
		public function get levelNextScore():uint 
		{
			return _levelNextScore;
		}
		
	}

}