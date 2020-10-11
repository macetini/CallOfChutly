package meta
{
	import adobe.utils.CustomActions;
	
	/**
	 * 
	 * Global Graphic constants (Assets)
	 * 
	 * @author Marko Cetinic
	 */
	
	public final class GraphicConstants 
	{
		//font
		
		[Embed(source = '../../assets/fonts/Sniglet.otf', embedAsCFF = "false", fontFamily = 'snig')]
		public static const SINGLET_FONT:Class;
		
		//Movie Clips
		
		[Embed(source="../../assets/anim/intro_anim.swf", mimeType="application/octet-stream")]
		public static const INTRO_MOVIE_CLIP:Class;
		
		[Embed(source="../../assets/anim/end_anim.swf", mimeType="application/octet-stream")]
		public static const END_MOVIE_CLIP:Class;
		
		//Background slices
		
		[Embed(source="../../assets/space_slices/space_slices.zip", mimeType="application/octet-stream")]
		public static const SPACE_SLICES_ZIP:Class;
		
		//images
		
		[Embed(source = "../../assets/images/mute_all.png")]
		public static const HUD_MUTE_ALL:Class;
		
		[Embed(source = "../../assets/images/un_mute_2.png")]
		public static const HUD_UNMUTE:Class;
		
		[Embed(source = "../../assets/images/hud_mute_music.png")]
		public static const HUD_MUTE_MUSIC:Class;
		
		[Embed(source = "../../assets/images/keyboard.png")]
		public static const KEYBOARD_IMAGE:Class;
		
		[Embed(source = "../../assets/images/esc_key.png")]
		public static const ESC_KEY_IMAGE:Class;
		
		[Embed(source="../../assets/images/comet.png")]
		public static const COMET_IMAGE:Class;
		
		[Embed(source = "../../assets/images/hud_heart_full.png")]
		public static const HUD_HEART_FULL:Class;
		
		[Embed(source = "../../assets/images/hud_heart_empty.png")]
		public static const HUD_HEART_EMPTY:Class;
		
		[Embed(source = "../../assets/images/hud_coins.png")]
		public static const BRONZE_COIN:Class;
		
		[Embed(source = "../../assets/images/chutly_sad.png")]
		public static const CHUTLY_SAD:Class;
		
		[Embed(source = "../../assets/images/chutly_angry.png")]
		public static const CHUTLY_ANGRY:Class;
		
		[Embed(source = "../../assets/images/red_particle.png")]
		public static const RED_PARTICLE:Class;
		
		[Embed(source="../../assets/images/white_particle.png")]
		public static const WHITE_PARTICLE:Class;
		
		[Embed(source="../../assets/images/planets/plan_blue.png")]
		public static const PLANET_BLUE:Class;
		
		[Embed(source="../../assets/images/planets/plan_green.png")]
		public static const PLANET_GREEN:Class;
		
		[Embed(source="../../assets/images/planets/plan_dead.png")]
		public static const PLANET_DEAD:Class;
		
		//sprites
		
		[Embed(source="../../assets/spritemaps/comet_sprite.png")]
		public static const COMET_PARTICLE:Class;
		
		[Embed(source="../../assets/spritemaps/chutly_sprite.png")]
		public static const CHUTLY_MAP:Class;
		
		[Embed(source="../../assets/spritemaps/ship_sprite.png")]
		public static const SHIP_MAP:Class;
		
		[Embed(source="../../assets/spritemaps/missile_sprite.png")]
		public static const MISSILE_MAP:Class;
		
		[Embed(source="../../assets/spritemaps/lightning_star_sprite.png")]
		public static const LIGHTNING_STAR_MAP:Class;
		
		[Embed(source="../../assets/spritemaps/shild_star_sprite.png")]
		public static const SHILD_STAR_MAP:Class;
		
		[Embed(source="../../assets/spritemaps/fly_spa_monster.png")]
		public static const FLYING_SPAGETTY_MONSTER_MAP:Class;
		
		[Embed(source = "../../assets/spritemaps/elder_one_sprite.png")]
		public static const ELDER_ONE_SPRITE:Class;
	}

}