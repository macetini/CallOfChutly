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
	public class World5 extends GameWorld implements ILevel
	{
		private var _levelNextScore:uint = 5;
		
		public function World5() 
		{
			super();
			
			WeightUtil.singleSpawnArr = [Ship, Life, FlyingSpaMonst];
			WeightUtil.multySpawnArr = [BluePlanet, GreenPlanet, DeadPlanet, Comet];
		}
		
		public function initWorld():void
		{
		}
		
		public function increaseDifficulty():void
		{
			Comet.Weight++;
		}
		
		public function get levelNextScore():uint
		{
			return _levelNextScore;
		}		
		
	}

}