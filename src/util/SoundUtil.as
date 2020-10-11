package util
{
	import flash.media.Sound;
	import net.flashpunk.Sfx;
	import meta.*;
	
	public final class SoundUtil
	{
		/**
		 * Resource Util contains helper methods for resource bundles.
		 *
		 * @author Marko Cetinic
		 */
		
		/**
		 * Default sound volumn
		 */
		public static var DEFAULT_VOLUMN:Number = 1.0;
		
		/**
		 * Local sound sfx variable.
		 */
		private static var _loopSfx:Sfx = null;
		
		/**
		 * Mute music.
		 */
		public static function muteMusic():void
		{
			if (GameConstants.DEBUG)
				trace("\nMute Music");
			
			GameVariables.MuteMusic = true;
			stopLoop();
		}
		
		/**
		 * Un Mute music.
		 */
		public static function unMuteMusic():void
		{
			if (GameConstants.DEBUG)
				trace("\nUnmute Music");
			
			GameVariables.MuteMusic = false;
			resumeLoop();
		}
		
		/**
		 * Mute effects.
		 */
		public static function muteEffects():void
		{
			if (GameConstants.DEBUG)
				trace("\nMute Effects");
			
			GameVariables.MuteEffects = true;
		}
		
		/**
		 * Unmute effects.
		 */
		public static function unMuteEffects():void
		{
			if (GameConstants.DEBUG)
				trace("\nUnmute Effects");
			
			GameVariables.MuteEffects = false;
		}
		
		/**
		 * Play sound.
		 * 
		 * @param sound Sound asset class
		 * @param sound volumn
		 * 
		 */
		public static function playSound(sound:Class, vol:Number = 0):void
		{
			if (GameVariables.MuteEffects)
				return;
			
			if (vol == 0)
				vol = DEFAULT_VOLUMN;
			
			var sfx:Sfx = new Sfx(sound);
			
			if (sfx != null)
				sfx.play(vol);
		}
		
		/**
		 * Loop sound.
		 * 
		 * @param sound Sound to be looped
		 * 
		 */
		public static function loopSound(sound:Class):void
		{
			if (GameVariables.MuteMusic)
				return;
			
			if (_loopSfx != null)
				return;
			
			var vol:Number = DEFAULT_VOLUMN - 0.3;
			
			_loopSfx = new Sfx(sound);
			
			if (_loopSfx != null)
				_loopSfx.loop(vol);
		}
		
		/**
		 * Stop(pause) loop sound.
		 * 
		 */
		public static function stopLoop():void
		{
			if (GameConstants.DEBUG)
				trace("\nLoop stop");
			
			if (_loopSfx != null)
				_loopSfx.stop();
		}
		
		/**
		 * Resume loop sound.
		 * 
		 */
		public static function resumeLoop():void
		{
			if (GameConstants.DEBUG)
				trace("\nLoop resume");
			
			if (_loopSfx != null)
				_loopSfx.resume();
		}
		
		public static function loopBackgroundMusic():void
		{
			if (GameConstants.DEBUG)
				trace("\nLoop background music");
			
			loopSound(SoundConstants.BACKGROUND_SOUND);
		}
		
		public static function playEat1():void
		{
			if (GameConstants.DEBUG)
				trace("\nPlay eat 1");
			
			playSound(SoundConstants.EAT_1);
		}
		
		public static function playEat2():void
		{
			if (GameConstants.DEBUG)
				trace("\nPlay eat 2");
			
			playSound(SoundConstants.EAT_2);
		}
		
		public static function playEat3():void
		{
			if (GameConstants.DEBUG)
				trace("\nPlay eat 3");
			
			playSound(SoundConstants.EAT_3);
		}
		
		public static function playBurp():void
		{
			if (GameConstants.DEBUG)
				trace("\nPlay Burp");
			
			playSound(SoundConstants.BURP, 0.3);
		}
		
		public static function playShield():void
		{
			if (GameConstants.DEBUG)
				trace("\nPlay Eat Star");
			
			playSound(SoundConstants.SHIELD);
		}
		
		public static function playLightning():void
		{
			if (GameConstants.DEBUG)
				trace("\nPlay Lightning");
			
			playSound(SoundConstants.LIGHTNING);
		}
		
		public static function playSmallLightning():void
		{
			if (GameConstants.DEBUG)
				trace("\nPlay Small Lightning", 0.5);
			
			playSound(SoundConstants.SMALL_LIGHTNING);
		}
		
		public static function playFireballExplode():void
		{
			if (GameConstants.DEBUG)
				trace("\nPlay fireball explode");
			
			playSound(SoundConstants.FIREBALL_EXPLODE, DEFAULT_VOLUMN / 2);
		}
		
		public static function playPlayeDieSound():void
		{
			if (GameConstants.DEBUG)
				trace("\nPlay player die");
			
			playSound(SoundConstants.DIE_SOUND);
		}
		
		public static function playPickUpLifeSound():void
		{
			if (GameConstants.DEBUG)
				trace("\nPlay pick up life");
			
			playSound(SoundConstants.PICK_LIFE_SOUND);
		}
		
		public static function playBlip1():void
		{
			if (GameConstants.DEBUG)
				trace("\nPlay blip 1");
			
			playSound(SoundConstants.BLIP_1);
		}
		
		public static function playBlip2():void
		{
			if (GameConstants.DEBUG)
				trace("\nPlay blip 2");
			
			playSound(SoundConstants.BLIP_2);
		}
		
		public static function playLaugh():void
		{
			if (GameConstants.DEBUG)
				trace("\nPlay Laugh");
			
			playSound(SoundConstants.LAUGHING);
		}
		
		public static function playGroan():void
		{
			if (GameConstants.DEBUG)
				trace("\nPlay Groan");
			
			playSound(SoundConstants.GROAN);
		}
	}
}

