package lowCarbon
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.utils.setTimeout;
	import flash.ui.Keyboard;
	import flash.desktop.NativeApplication;
	import starling.core.StatsDisplay;
	
	import starling.core.Starling;
	
	
	/**
	 * ...
	 * @author Shen Yiming
	 */
	
	[SWF(width="500", height="500", frameRate="60", backgroundColor="#000000")]
	public class Main extends Sprite 
	{
		private var _starling:Starling;
		private var stats:Stats;
		
		public function Main():void 
		{
			stats = new Stats();
			addChild(stats);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			setTimeout(startApp, 100);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKey);
		}
		
		private function onKey(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ESCAPE)
				NativeApplication.nativeApplication.exit(0);
			else if(e.keyCode == Keyboard.UP){
				Game(_starling.root).speed += 0.1;
			}
			else if(e.keyCode == Keyboard.DOWN){
				Game(_starling.root).speed -= 0.1;
			}
		}
		
		public function startApp():void 
		{
			_starling = new Starling(Game, stage);
			//_starling.showStats = true;
			_starling.start();
			
		}
		
	}
	
}