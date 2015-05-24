package com.shader.utils 
{
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Console extends TextField 
	{
		public var maxLines:uint = 10;
		
		public function Console() 
		{
			super();
			addEventListener(flash.events.Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(flash.events.Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			//addEventListener(logEvent.HAS_LOG, onHasLog);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.multiline = true;
			this.wordWrap = true;
			this.antiAliasType = 'advanced';
			this.mouseEnabled = false;
			this.selectable = false;
			var format:TextFormat = new TextFormat();
			format.font = '_sans';
			format.size = 13;
			this.defaultTextFormat = format;
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			//removeEventListener(logEvent.HAS_LOG, onHasLog);
		}
		
		public function log(txt:String):void 
		{
			if (this.numLines >= maxLines) this.text = '';
			this.appendText(txt+"\n");
		}
		
	}

}