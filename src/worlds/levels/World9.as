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
	public class World9 extends GameWorld implements ILevel
	{
		private var _levelNextScore:uint = 5;
		
		public function World9() 
		{
			super();

			WeightUtil.singleSpawnArr = [Ship, Life, FlyingSpaMonst, ShieldStar, LightningStar, ElderOneChain];
			WeightUtil.multySpawnArr = [BluePlanet, GreenPlanet, DeadPlanet, Comet];
		}
		
		public function initWorld():void
		{
			Life.Timeout += 2;
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