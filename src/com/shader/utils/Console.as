package com.shader.utils 
{
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Console extends TextField 
	{
		public function Console() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}

		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
		}
		

		
	}

}