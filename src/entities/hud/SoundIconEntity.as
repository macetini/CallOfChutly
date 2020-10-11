package entities.hud
{
	import net.flashpunk.FP
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import meta.*;
	import net.flashpunk.utils.Input;
	import worlds.GameWorld;
	import util.SoundUtil;
	
	/**
	 * 
	 * Upper right corner sound icon.
	 * 
	 * @author Marko Cetinic
	 */
	
	public class SoundIconEntity extends Entity
	{
		public static const MUTE_SOUND_ICON_ENT_TYPE:String = "muteIcon";
		
		public function SoundIconEntity()
		{
			super();
			
			this.type = MUTE_SOUND_ICON_ENT_TYPE;
			
			updateSoundIconImage();
			
			this.setHitbox((this.graphic as Image).width, (this.graphic as Image).height);
		}

		/**
		* 
		* <p>Update icon image, based on GameVariables.MuteLevel.</p>
		* 
		* <p>0 - mute all</p>
		* <p>1 - mute music</p>
		* <p>2 - unmute</p>
		* 
		*/
		public function updateSoundIconImage():void
		{
			if (GameVariables.MuteLevel > 2)
				GameVariables.MuteLevel = 0;
			
			switch (GameVariables.MuteLevel)
			{
				case 0: 
					this.graphic = new Image(GraphicConstants.HUD_MUTE_ALL);
					break;
				case 1: 
					this.graphic = new Image(GraphicConstants.HUD_MUTE_MUSIC);
					break;
				case 2: 
					this.graphic = new Image(GraphicConstants.HUD_UNMUTE);
					break;
			}
		}
		
		/**
		* 
		* Click on icon handler. Click increments GameVariables.MuteLevel.
		* 
		* @see updateSoundIconImage()
		* 
		*/
		protected function soundIconClicked():void
		{
			SoundUtil.playBlip1();
			
			if (GameVariables.MuteLevel < 2)
				GameVariables.MuteLevel++;
			else
				GameVariables.MuteLevel = 0;
			
			switch (GameVariables.MuteLevel)
			{
				case 0: 
					SoundUtil.muteEffects();
					SoundUtil.muteMusic();
					break;
				case 1: 
					SoundUtil.unMuteEffects();
					SoundUtil.muteMusic();
					break;
				case 2: 
					SoundUtil.unMuteEffects();
					SoundUtil.unMuteMusic();
					break;
			}
			
			updateSoundIconImage();
			
			(FP.world as GameWorld).updateMuteMusicTextEntity();
			(FP.world as GameWorld).updateMuteEffectTextEntity();
		}
		
		protected function checkForSoundIconClick():void
		{
			if (Input.mouseReleased)
			{
				var hudSoundIconEntity:Entity = FP.world.collidePoint(SoundIconEntity.MUTE_SOUND_ICON_ENT_TYPE, FP.world.mouseX, FP.world.mouseY);
				
				if (hudSoundIconEntity != null)
					soundIconClicked();
			}
		}
		
		override public function update():void
		{
			checkForSoundIconClick();
			
			super.update();
		}
	}

}