package 
{
	import graphic.*;
	import graphic.events.*;
	import meta.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	import util.*;
	import worlds.*;
	
	/**
	 * Entry point for Coin Duder.
	 * 
	 */
	 
	[Frame(factoryClass = "Preloader")]
	
	public class Main extends Engine 
	{
		
		public function Main():void 
		{
			super(640, 480, 60);
					
			var imc:NiceMovieClipAsset = new NiceMovieClipAsset(GraphicConstants.INTRO_MOVIE_CLIP);
			imc.addEventListener(ContentEndEvent.CONTENT_END, contentEndHandler);
			imc.load(true);
		}
		
		override public function init():void 
		{
			super.init();
			
			//HUD
			Text.font = GameConstants.FONT;
			
			GameVariables.BackgroundImage = new RandomBackground;
			GameVariables.BackgroundImage.addEventListener(DataLoadedEvent.DATA_LOADED, randomDataLoadedHandler);
			GameVariables.BackgroundImage.loadDataFromZipFile();
		}
		
		protected function contentEndHandler(e:ContentEndEvent):void
		{	
			(e.target as NiceMovieClipAsset).removeEventListener(ContentEndEvent.CONTENT_END, contentEndHandler);
			
			SoundUtil.loopBackgroundMusic();
			
			FP.stage.removeChild(e.target.content);
			Input.mouseReleased = false;
			FP.world.active = true;
		}

		protected function randomDataLoadedHandler(e:DataLoadedEvent):void
		{
			var bandomBackground:RandomBackground = e.target as RandomBackground;
			
			bandomBackground.removeEventListener(DataLoadedEvent.DATA_LOADED, randomDataLoadedHandler);
			bandomBackground.randomizeContnet();
	
			var introWorld:IntroWorld = new IntroWorld;
			introWorld.active = false;
			FP.world = introWorld;
			//FP.console.enable();
		}
	}
}