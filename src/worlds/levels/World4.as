package worlds.levels 
{
	import entities.allies.*;
	import entities.enemies.*;
	import entities.points.*;
	import entities.points.planets.*;
	import util.WeightUtil;
	import worlds.GameWorld;
	import worlds.levels.interfaces.ILevel;
	
	/**
	 * Level World
	 * @author Marko Cetinic
	 */
	public class World4 extends GameWorld implements ILevel
	{
		private var _levelNextScore:uint = 5;
		
		public function World4() 
		{
			super();
			
			WeightUtil.singleSpawnArr = [Ship, Life];
			WeightUtil.multySpawnArr = [BluePlanet, GreenPlanet, DeadPlanet, Comet];
		}
		
		public function initWorld():void
		{
			SingleMinSpawnRate = 2;
			SingleMaxdSpawnRate = 2.75;			
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