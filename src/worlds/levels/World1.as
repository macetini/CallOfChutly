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
	public class World1 extends GameWorld implements ILevel
	{
		private var _levelNextScore:uint = 5;
		
		public function World1() 
		{
			super();
			
			WeightUtil.singleSpawnArr = [];
			WeightUtil.multySpawnArr = [BluePlanet, Comet];
		}
		
		public function initWorld():void
		{
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