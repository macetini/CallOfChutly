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
	public class World2 extends GameWorld implements ILevel
	{
		private var _levelNextScore:uint = 5;
		
		public function World2() 
		{
			super();
			
			WeightUtil.singleSpawnArr = [];
			WeightUtil.multySpawnArr = [BluePlanet, GreenPlanet, DeadPlanet, Comet];
		}
		
		public function initWorld():void
		{
			GameVariables.ScoreCap = 40;
			Comet.Weight = 20;
		}
		
		public function increaseDifficulty():void
		{
		}
		
		public function get levelNextScore():uint
		{
			return _levelNextScore;
		}
	}

}