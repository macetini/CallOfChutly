package entities.hud 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import UI.NiceText;
	import util.*;
	import meta.*;
	import UI.NiceTextEnt;
	import worlds.GameWorld;
	
	/**
	 * 
	 * Options dialog.
	 * 
	 * @see GameWorld Class
	 * 
	 * @author Marko Cetinic
	 */
	
	public class OptionsDialogEntity extends Entity 
	{
		public static const OPTIONS_ENTITY_TYPE:String = "optionEntity";
		
		public static const MUTE_MUSIC_TEXT_ENT_TYPE:String = "muteMusicEntity";
		public static const MUTE_EFFECTS_TEXT_ENT_TYPE:String = "muteEffectsEntity";
		
		public static const RESTART_LEVEL_ENT_TYPE:String = "restartLevelEntity";
		public static const QUIT_ENT_TYPE:String = "quitEntity";
		
		/**
		 * 
		 * Text size
		 *
		 */
		public static const TEXT_SIZE:int = 30;
				
		private var _pausedText:NiceTextEnt;
		private var _levelText:NiceTextEnt;
		
		private var _muteMusicEntity:NiceTextEnt;
		private var _muteEffectsEntity:NiceTextEnt;
		
		private var _restartLevelEntity:NiceTextEnt;
		private var _quitGameEntity:NiceTextEnt;
		
		protected var _confirmDialogEntity:ConfirmDialogEntity;
		
		public function OptionsDialogEntity() 
		{
			super();
			
			this.type = OPTIONS_ENTITY_TYPE;
			
			_pausedText = new NiceTextEnt(grs("pausedText_l"));
			_pausedText.textGraphic.size = TEXT_SIZE + 10;
			_pausedText.x = (FP.width - _pausedText.textGraphic.width) / 2;
			_pausedText.y = (FP.height - TEXT_SIZE * 5) / 2 - 65;
			
			FP.world.add(_pausedText);
			
			_levelText = new NiceTextEnt(grs("levelText_l1") + LevelsUtil.LevelIndex + "/" + LevelsUtil.LEVELS_PER_WORLD + grs("levelText_l2") + LevelsUtil.WorldIndex);
			_levelText.textGraphic.size = TEXT_SIZE;
			_levelText.x = (FP.width - _levelText.textGraphic.width) / 2;
			_levelText.y = _pausedText.y + _pausedText.textGraphic.height + 10;
			
			FP.world.add(_levelText);
			
			if(GameVariables.MuteMusic)
				_muteMusicEntity = new NiceTextEnt(grs("muteMusic_l1"));
			else
				_muteMusicEntity = new NiceTextEnt(grs("muteMusic_l2"));
				
			_muteMusicEntity.textGraphic.size = TEXT_SIZE;
			_muteMusicEntity.type = MUTE_MUSIC_TEXT_ENT_TYPE;
			_muteMusicEntity.x = (FP.width - _muteMusicEntity.textGraphic.width) / 2;
			_muteMusicEntity.y = _levelText.y + _levelText.textGraphic.height + 10;
			_muteMusicEntity.setHitbox(_muteMusicEntity.textGraphic.width, _muteMusicEntity.textGraphic.height);
			
			FP.world.add(_muteMusicEntity);
		
			if (GameVariables.MuteEffects)
				_muteEffectsEntity = new NiceTextEnt(grs("muteEffects_l1"));
			else
				_muteEffectsEntity = new NiceTextEnt(grs("muteEffects_l2"));
				
			_muteEffectsEntity.textGraphic.size = TEXT_SIZE;
			_muteEffectsEntity.type = OptionsDialogEntity.MUTE_EFFECTS_TEXT_ENT_TYPE;
			_muteEffectsEntity.x = (FP.width - _muteEffectsEntity.textGraphic.width) / 2;
			_muteEffectsEntity.y = _muteMusicEntity.y + _muteMusicEntity.textGraphic.height + 10;
			_muteEffectsEntity.setHitbox(_muteMusicEntity.textGraphic.width, _muteMusicEntity.textGraphic.height);
			
			FP.world.add(_muteEffectsEntity);
			
			_restartLevelEntity = new NiceTextEnt(grs("restartLevel_l"));
			_restartLevelEntity.textGraphic.size = TEXT_SIZE;
			_restartLevelEntity.type = RESTART_LEVEL_ENT_TYPE;
			_restartLevelEntity.x = (FP.width - _restartLevelEntity.textGraphic.width) / 2;
			_restartLevelEntity.y = _muteEffectsEntity.y + _muteEffectsEntity.textGraphic.height + 10;
			_restartLevelEntity.setHitbox(_restartLevelEntity.textGraphic.width, _restartLevelEntity.textGraphic.height);
			
			FP.world.add(_restartLevelEntity);
			
			_quitGameEntity = new NiceTextEnt(grs("quitGame_l1"));
			_quitGameEntity.textGraphic.size = TEXT_SIZE;
			_quitGameEntity.type = QUIT_ENT_TYPE;
			_quitGameEntity.x = (FP.width - _quitGameEntity.textGraphic.width) / 2;
			_quitGameEntity.y = _restartLevelEntity.y + _restartLevelEntity.textGraphic.height + 10;
			
			_quitGameEntity.setHitbox(_quitGameEntity.textGraphic.width, _quitGameEntity.textGraphic.height);
			
			FP.world.add(_quitGameEntity);
		}
		
		/**
		 * 
		 * ResourcesUtil helper function
		 *
		 * @param resourceName resource key.
		 * 
		 * @see ResourceUtil
		 * 
		 * @return string from resource bundle
		 *
		 */
		public function grs(resourceName:String):String
		{
			return ResourcesUtil.grs(resourceName);
		}
		
		/**
		 *
		 * Mute music acessor.
		 * 
		 * @see SoundIconDialogEntity
		 * 
		 * @return muteMusicEntity
		 *
		 */
		public function get muteMusicEntity():NiceTextEnt 
		{
			return _muteMusicEntity;
		}
		
		/**
		 *
		 * Mute music acessor.
		 * 
		 * @see SoundIconDialogEntity
		 *
		 */
		public function set muteMusicEntity(value:NiceTextEnt):void 
		{
			_muteMusicEntity = value;
		}
		
		/**
		 *
		 * Mute effects acessor.
		 * 
		 * @see SoundIconDialogEntity
		 * 
		 * @return NiceTextEnt
		 *
		 */
		public function get muteEffectsEntity():NiceTextEnt 
		{
			return _muteEffectsEntity;
		}
		
		/**
		 *
		 * Mute effects acessor.
		 * 
		 * @see SoundIconDialogEntity
		 *
		 */
		public function set muteEffectsEntity(value:NiceTextEnt):void 
		{
			_muteEffectsEntity = value;
		}
		
		override public function removed():void 
		{				
			FP.world.remove(_pausedText);
			FP.world.remove(_levelText);
			
			FP.world.remove(_muteMusicEntity);
			FP.world.remove(_muteEffectsEntity);
			
			FP.world.remove(_restartLevelEntity);
			FP.world.remove(_quitGameEntity);

			super.removed();
		}
		
		/**
		 *
		 * Restart level text click handler
		 * 
		 * @see GameWorld
		 *
		 */
		protected function checkForRestartLevelClick():void
		{
			if (Input.mouseReleased)
			{
				var restartLevelEntity:Entity = FP.world.collidePoint(OptionsDialogEntity.RESTART_LEVEL_ENT_TYPE, FP.world.mouseX, FP.world.mouseY);
				
				if (restartLevelEntity != null)
				{
					GameVariables.Pause = false;
					LevelsUtil.restartLevel();
				}
			}
		}
		
		/**
		 *
		 * Quit game text click handler. Initiates ConfirmDialogEntity
		 *
		 */
		protected function checkForRestartGameClick():void
		{
			if (Input.mouseReleased)
			{
				var restartGameEntity:Entity = FP.world.collidePoint(OptionsDialogEntity.QUIT_ENT_TYPE, FP.world.mouseX, FP.world.mouseY);
				
				if (restartGameEntity != null)
				{
					FP.world.remove(this);
					
					_confirmDialogEntity = new ConfirmDialogEntity(grs("confirmDialog_l"), LevelsUtil.quit);
					FP.world.add(_confirmDialogEntity);
				}
			}
		}
		
		/**
		 *
		 * Confirms game quit, exit to Intro World
		 * 
		 *
		 */
		protected function checkForConfirmGameRestart():void
		{
			if (Input.mouseReleased)
			{
				var confirmEntity:Entity = FP.world.collidePoint(ConfirmDialogEntity.CONFIRM_ENT_TYPE, FP.world.mouseX, FP.world.mouseY);
				
				if (confirmEntity != null)
				{
					GameVariables.Pause = false;
					_confirmDialogEntity.func();
				}
			}
		}
		
		/**
		 *
		 * Declines game quit, removes options dialog
		 * 
		 *
		 */
		protected function checkForDeclineGameRestart():void
		{
			if (Input.mouseReleased)
			{
				var declineEntity:Entity = FP.world.collidePoint(ConfirmDialogEntity.DECLINE_ENT_TYPE, FP.world.mouseX, FP.world.mouseY);
				
				if (declineEntity != null)
				{
					GameVariables.Pause = false;
					FP.world.remove(_confirmDialogEntity);
				}
			}
		}
		
		override public function update():void
		{			
			checkForRestartLevelClick();
			checkForRestartGameClick();
			
			checkForConfirmGameRestart();
			checkForDeclineGameRestart();
			
			super.update();
		}
	}

}