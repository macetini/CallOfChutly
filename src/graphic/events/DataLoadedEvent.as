package graphic.events
{
	import flash.events.Event;
	
	/**
	 * 
	 * Data loaded event.
	 * 
	 * @see graphic.RandomBackground
	 * 
	 * @author Marko Cetinic
	 */
	public class DataLoadedEvent extends Event 
	{
		public static const DATA_LOADED:String = "dataLoaded";
		
		public function DataLoadedEvent(type:String=DATA_LOADED, bubbles:Boolean=true, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}