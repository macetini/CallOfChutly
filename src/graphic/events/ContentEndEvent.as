package graphic.events 
{
	import flash.events.Event;
	
	/**
	 * 
	 * Content playing ended.
	 * 
	 * @see graphic.NiceMovieClipAsset
	 * 
	 * @author Marko Cetinic
	 */
	public class ContentEndEvent extends Event 
	{
		public static const CONTENT_END:String = "contentEnd";
		
		public function ContentEndEvent(type:String=CONTENT_END, bubbles:Boolean=true, cancelable:Boolean=true) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}