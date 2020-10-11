package entities.points
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	/**
	 * Elder one chain entity contains array of ElederOne elements.
	 * 
	 * @author Marko Cetinic
	 */
	
	public class ElderOneChain extends Entity
	{		
		public static const SPEED:uint = 4;
		public static const ROTATION:uint = 35;
	
		/**
         * Entity weight
         */
		public static var Weight:uint = 7;
		
		protected var _elderOneArr:Array;
		protected var _elderOneCount:uint = 5;
		
		public function ElderOneChain()
		{
			_elderOneArr = new Array();
			
			var chainLength:int = this._elderOneCount * ElderOne.MAP_WIDTH;
			
			var elderOne:ElderOne;
		
			//Create elder one from one of 4 random corners.
			var randCorner:uint = Math.random() * 4;
		
			for (var i:uint = 0; i < this._elderOneCount; i++)
			{
				switch (randCorner)
				{
					case 0: 
						elderOne = new ElderOne(this, SPEED, ROTATION, -(chainLength - i * ElderOne.MAP_WIDTH), 0);
						break;
					case 1: 
						elderOne = new ElderOne(this, SPEED, -ROTATION, -(chainLength - i * ElderOne.MAP_WIDTH), FP.height - ElderOne.MAP_HEIGHT);
						break;
					case 2: 
						elderOne = new ElderOne(this, -SPEED, -ROTATION, FP.width + chainLength - i * ElderOne.MAP_WIDTH, FP.height - ElderOne.MAP_HEIGHT);
						break;
					case 3: 
						elderOne = new ElderOne(this, -SPEED, ROTATION, FP.width + chainLength - i * ElderOne.MAP_WIDTH, 0);
						break;
				}
				
				this._elderOneArr.push(elderOne);
			}
		}
		
		override public function added():void
		{
			super.added();
			
			for each (var elderOne:ElderOne in _elderOneArr)
				FP.world.add(elderOne);
		}
		
		public function removeElderOne():void
		{
			var elderOne:ElderOne = this._elderOneArr.pop();
			FP.world.remove(elderOne);
			
			if (this._elderOneArr.length == 0)
				FP.world.remove(this);
		}
	}
}