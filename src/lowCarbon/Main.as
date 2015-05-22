package lowCarbon
{
	import com.shader.utils.Stats;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.utils.setTimeout;
	import flash.ui.Keyboard;
	import flash.desktop.NativeApplication;
	import flash.external.ExternalInterface;
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
			
			if (ExternalInterface.available) {
                try {
                    debugMC.serialDebug.appendText("Adding callback...\n");
                    ExternalInterface.addCallback("toFlash", inputFunc);
                } catch (error:SecurityError) {
                    debugMC.serialDebug.appendText("A SecurityError occurred: " + error.message + "\n");
                } catch (error:Error) {
                    debugMC.serialDebug.appendText("An Error occurred: " + error.message + "\n");
                }
            } else {
                debugMC.serialDebug.appendText("External interface is not available for this container.\n");
            }
			
		}
		
		private function onKey(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ESCAPE)
				NativeApplication.nativeApplication.exit(0);
		}
		
		public function startApp():void 
		{
			_starling = new Starling(BouncingBox, stage);
			//_starling.showStats = true;
			_starling.start();
		}
		
	}
	
}