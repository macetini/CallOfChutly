package graphic
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.SoundTransform;
	import mx.core.MovieClipAsset;
	import net.flashpunk.*;
	import graphic.events.ContentEndEvent;
	import meta.*;
	import graphic.events.DataLoadedEvent;
	import net.flashpunk.utils.Input;
	
	/**
	 * 
	 * Load movie clip asset.
	 * 
	 * @author Marko Cetinic
	 */

    public class NiceMovieClipAsset extends EventDispatcher
    {
		/**
		 * Dispatched when a movie clip ends
		 *
		 * @eventType ContentEndEvent.CONTENT_END
		 */
		
		[Event(name="contentEnd",type="graphic.events.ContentEndEvent")]		
		
		public var content:MovieClip = null;
		
		protected var _addToStage:Boolean = false;
		protected var _asset:Class;
		
		protected var _loader:Loader;

        /**
         * Constructor of NiceMovieClipAsset class.
		 * 
		 * @param asset Clipp asset class
		 * 
         */
        public function NiceMovieClipAsset(asset:Class)
        {	
			super();
			
			_asset = asset;
		}
		
        /**
         * 
		 * Start loading clip.
		 * 
		 * @param addToStage Add clip to stage once loaded.
		 * 
		 * @see loaderCompleate
		 * 
         */
		public function load(addToStage:Boolean):void
		{
			_addToStage = addToStage;

			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleate);
			_loader.loadBytes(new _asset);
		}
		
		/**
         * 
		 * Stop Clip playing
		 * 
         */
		
		public function stop():void
		{
			if (content != null)
			{
				FP.stage.removeEventListener(MouseEvent.MOUSE_UP, contentClickedHandler);
				content.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);				
				
				content.stop();
				
				var muteTransform:SoundTransform = new SoundTransform();
                muteTransform.volume = 0;
                content.soundTransform = muteTransform;
				
				this.dispatchEvent(new ContentEndEvent);
			}
		}
		
		/**
         * 
		 * Clip asset loaded.
		 * 
		 * @see load
		 * 
         */
		protected function loaderCompleate(e:Event):void
		{
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, loaderCompleate);
			
			content = e.target.content;
			
			content.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			FP.stage.addEventListener(MouseEvent.MOUSE_UP, contentClickedHandler);
			
			if(_addToStage)
				FP.stage.addChild(content);
		}
		/**
         * 
		 * Click on stage handler while playing. Stops the Clip
		 * 
		 * @see stop
		 * 
         */
		
		protected function contentClickedHandler(e:MouseEvent):void
		{
			stop();
		}

        protected function enterFrameHandler(e:Event):void
        {
            if (content.currentFrame == content.totalFrames)
			{
				this.dispatchEvent(new DataLoadedEvent);
				
				content.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				stop();
			}
        }
    }
}