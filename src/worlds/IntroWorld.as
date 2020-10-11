package worlds
{
	import entities.allies.*;
	import entities.enemies.*;
	import entities.hud.*;
	import entities.points.*;
	import entities.points.planets.*;
	import graphic.*;
	import graphic.events.*;
	import meta.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	import UI.*;
	import util.*;
	
	/**
	 *
	 * Intro world. Shown at the beginning of game.
	 *
	 * @author Marko Cetinic
	 */
	public class IntroWorld extends GameWorld
	{
		public static const TEXT_SIZE:int = 30;
		
		/**
		 *
		 * Low layer used by text dialogs.
		 *
		 */
		public static const LAYER:int = -2550;
		
		public static const NEW_GAME_ENT_TYPE:String = "newGame";
		public static const INTRO_ENT_TYPE:String = "intro";
		
		private var _infoTextEntity:NiceTextEnt;
		private var _levelTextEntity:NiceTextEnt;
		
		private var _muteMusicEntity:NiceTextEnt;
		private var _muteEffectsEntity:NiceTextEnt;
		
		private var _newGameEntity:NiceTextEnt;
		private var _introEntity:NiceTextEnt;
		
		public function IntroWorld()
		{
			super();
			
			WeightUtil.singleSpawnArr = [Ship, Life, FlyingSpaMonst, ShieldStar, LightningStar, ElderOneChain];
			WeightUtil.multySpawnArr = [BluePlanet, GreenPlanet, DeadPlanet, Comet];
		}
		
		override public function begin():void
		{
			this.addGraphic(new Backdrop(GameVariables.BackgroundImage.content));
			
			this._hudSoundIconEntity = new SoundIconEntity;
			this._hudSoundIconEntity.x = FP.width - (_hudSoundIconEntity.graphic as Image).width;
			
			this.add(this._hudSoundIconEntity);
			
			_infoTextEntity = new NiceTextEnt(grs("infoText_l"));
			_infoTextEntity.textGraphic.size = TEXT_SIZE + 10;
			_infoTextEntity.layer = LAYER;
			_infoTextEntity.x = (FP.width - _infoTextEntity.textGraphic.width) / 2;
			_infoTextEntity.y = (FP.height - TEXT_SIZE * 5) / 2 - 65;
			
			this.add(_infoTextEntity);
			
			_muteMusicEntity = new NiceTextEnt(grs("muteMusic_l2"));
			_muteMusicEntity.textGraphic.size = TEXT_SIZE;
			_muteMusicEntity.layer = LAYER;
			_muteMusicEntity.type = OptionsDialogEntity.MUTE_MUSIC_TEXT_ENT_TYPE;
			_muteMusicEntity.x = (FP.width - _muteMusicEntity.textGraphic.width) / 2;
			_muteMusicEntity.y = _infoTextEntity.y + _infoTextEntity.textGraphic.height + 10;
			_muteMusicEntity.setHitbox(_muteMusicEntity.textGraphic.width, _muteMusicEntity.textGraphic.height);
			
			this.add(_muteMusicEntity);
			
			_muteEffectsEntity = new NiceTextEnt(grs("muteEffects_l2"));
			_muteEffectsEntity.textGraphic.size = TEXT_SIZE;
			_muteEffectsEntity.layer = LAYER;
			_muteEffectsEntity.type = OptionsDialogEntity.MUTE_EFFECTS_TEXT_ENT_TYPE;
			_muteEffectsEntity.x = (FP.width - _muteEffectsEntity.textGraphic.width) / 2;
			_muteEffectsEntity.y = _muteMusicEntity.y + _muteMusicEntity.textGraphic.height + 10;
			_muteEffectsEntity.setHitbox(_muteMusicEntity.textGraphic.width, _muteMusicEntity.textGraphic.height);
			
			this.add(_muteEffectsEntity);
			
			_newGameEntity = new NiceTextEnt(grs("newGame_l"));
			_newGameEntity.textGraphic.size = TEXT_SIZE;
			_newGameEntity.layer = LAYER;
			_newGameEntity.type = NEW_GAME_ENT_TYPE;
			_newGameEntity.x = (FP.width - _newGameEntity.textGraphic.width) / 2;
			_newGameEntity.y = _muteEffectsEntity.y + _muteEffectsEntity.height + 10;
			_newGameEntity.setHitbox(_newGameEntity.textGraphic.width, _newGameEntity.textGraphic.height);
			
			this.add(_newGameEntity);
			
			_introEntity = new NiceTextEnt(grs("intro_l"));
			_introEntity.textGraphic.size = TEXT_SIZE;
			_introEntity.layer = LAYER;
			_introEntity.type = INTRO_ENT_TYPE;
			_introEntity.x = (FP.width - _introEntity.textGraphic.width) / 2;
			_introEntity.y = _newGameEntity.y + _newGameEntity.height + 10;
			_introEntity.setHitbox(_introEntity.textGraphic.width, _introEntity.textGraphic.height);
			
			this.add(_introEntity);
		}
		
		//game pause not possible
		override public function pauseUnpauseGame():void
		{
			//super.pauseUnpauseGame();
		}
		
		
		override public function updateMuteMusicTextEntity():void
		{
			super.updateMuteMusicTextEntity();
			
			if (GameVariables.MuteMusic)
				_muteMusicEntity.textGraphic.text = grs("muteMusic_l1");
			else
				_muteMusicEntity.textGraphic.text = grs("muteMusic_l2");
		}
		
		override public function updateMuteEffectTextEntity():void
		{
			super.updateMuteEffectTextEntity();
			
			if (GameVariables.MuteEffects)
				_muteEffectsEntity.textGraphic.text = grs("muteEffects_l1");
			else
				_muteEffectsEntity.textGraphic.text = grs("muteEffects_l2");
		}
		
		/**
		 * Start new game, click handler.
		 */
		
		protected function checkForNewGameClick():void
		{
			if (Input.mouseReleased)
			{
				var newGameEntity:Entity = this.collidePoint(NEW_GAME_ENT_TYPE, FP.world.mouseX, FP.world.mouseY);
				
				if (newGameEntity != null)
					LevelsUtil.nextLevel();
			}
		}
		
		/**
		 * Start Intro animation
		 */
		
		protected function introAnimEndHandler(e:ContentEndEvent):void
		{
			FP.stage.removeChild(e.target.content);
			
			SoundUtil.unMuteMusic();
			
			Input.mouseReleased = false;
			FP.world.active = true;
		}
		
		protected function checkForIntroClick():void
		{
			if (Input.mouseReleased)
			{
				var introEntity:Entity = this.collidePoint(INTRO_ENT_TYPE, FP.world.mouseX, FP.world.mouseY);
				
				if (introEntity != null)
				{
					SoundUtil.muteMusic();
					
					FP.world.active = false;
					
					var introAnim:NiceMovieClipAsset = new NiceMovieClipAsset(GraphicConstants.INTRO_MOVIE_CLIP);
					introAnim.addEventListener(ContentEndEvent.CONTENT_END, introAnimEndHandler);
					introAnim.load(true);
				}
			}
		}
		
		override public function update():void
		{
			checkForNewGameClick();
			checkForIntroClick();
			
			super.update();
		}
	}

}