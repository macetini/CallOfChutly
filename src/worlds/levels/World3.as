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
	public class World3 extends GameWorld implements ILevel
	{
		private var _levelNextScore:uint = 5;
		
		public function World3() 
		{
			super();
			
			WeightUtil.singleSpawnArr = [Ship];
			WeightUtil.multySpawnArr = [BluePlanet, GreenPlanet, DeadPlanet, Comet];
		}
		
		public function initWorld():void
		{
			SingleMinSpawnRate = 10.5;
			SingleMaxdSpawnRate = 10.75;
			Comet.Weight = 15;
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