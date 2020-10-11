package entities.hud 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import UI.NiceTextEnt;
	import util.ResourcesUtil;
	
	/**
	 * 
	 * Entity yes/no dialog.
	 * 
	 * @author Marko Cetinic
	 */
	
	public class ConfirmDialogEntity extends Entity 
	{
		public static const TEXT_SIZE:int = 35;
		
		public static const CONFIRM_ENT_TYPE:String = "confirmEnt";
		public static const DECLINE_ENT_TYPE:String = "declineEnt";
		
		protected var _text:NiceTextEnt;
		
		protected var _confirmEntity:NiceTextEnt;
		protected var _declineEntity:NiceTextEnt;
		
		public var func:Function;
		
		/**
		 * 
		 * ConfirmDialogEntity constructor.
		 *
		 * @param text Dialog text
		 * @param func Function to be executed if user clicks yes.
		 *
		 */
		
		public function ConfirmDialogEntity(text:String, func:Function) 
		{
			//store function
			this.func = func;
			
			_text = new NiceTextEnt(text);
			_text.textGraphic.size = TEXT_SIZE;
			_text.y = FP.height / 2;
			_text.x = (FP.width - _text.textGraphic.width) / 2;
			
			FP.world.add(_text);
			
			_confirmEntity = new NiceTextEnt(grs("confirm_l"));
			_confirmEntity.textGraphic.size = TEXT_SIZE;
			_confirmEntity.type = CONFIRM_ENT_TYPE;
			_confirmEntity.y = _text.y + _text.textGraphic.height + 10;
			_confirmEntity.x = FP.width/2 - _confirmEntity.textGraphic.width - 20;
			_confirmEntity.setHitbox(_confirmEntity.textGraphic.width, _confirmEntity.textGraphic.height);
			
			FP.world.add(_confirmEntity);
			
			_declineEntity = new NiceTextEnt(grs("decline_l"));
			_declineEntity.textGraphic.size = TEXT_SIZE;
			_declineEntity.type = DECLINE_ENT_TYPE;
			_declineEntity.y = _text.y + _text.textGraphic.height + 10;
			_declineEntity.x = FP.width/2 + 20;
			_declineEntity.setHitbox(_declineEntity.textGraphic.width, _declineEntity.textGraphic.height);
			
			FP.world.add(_declineEntity);
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
		
		override public function removed():void
		{
			FP.world.remove(_text);
			FP.world.remove(_confirmEntity);
			FP.world.remove(_declineEntity);
			
			super.removed();
		}
	}

}