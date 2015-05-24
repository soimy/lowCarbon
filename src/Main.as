package
{
	import BouncingBox;
	import com.shader.utils.Console;
	import com.shader.utils.Stats;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	import flash.utils.getTimer;
	import flash.ui.Keyboard;
	import flash.desktop.NativeApplication;
	import flash.external.ExternalInterface;
	import starling.core.StatsDisplay;
	
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Shen Yiming
	 */
	
	[SWF(width="500",height="500",frameRate="60",backgroundColor="#000000")]
	
	public class Main extends Sprite
	{
		private var _starling:Starling;
		private var stats:Stats;
		public var console:Console;
		
		// Settings 
		public var isDiag:Boolean;
		public var sampleRate:Number = 100; // in ms
		public var wheelLength:Number = 3;
		public var baseSpeed:Number = 5;
		
		// variable for speed evaluating
		private var dTimePool:Array = new Array(10000, 10000, 10000);
		private var currentSpeed:Number = 5;
		private var currentWalt:Number;
		public var _walt:Number;
		private var speed_lastTime:Number = 0;
		private var speed_cooldownRate:Number = 3; // speed reduce 3 km/h per second
		
		// variable for timer coding
		private var lastTime:Number = 0;
		private var startTime:Number;
		private var resultWaitStartTime:Number;
		
		// XML Param
		private var settings:XML;
		
		public function Main():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// XML Param Phraser
			var settingsLoader:URLLoader = new URLLoader();
			var xmlFile:File = File.applicationDirectory.resolvePath("settings.xml");
			settingsLoader.load(new URLRequest(xmlFile.nativePath));
			settingsLoader.addEventListener(Event.COMPLETE, processXML);
			
			// initialize game variables
			lastTime = getTimer();
			speed_lastTime = getTimer();
			//overAllEnergy = 0;
			//currentStage = 0;
			_walt = 0;
			//Mouse.hide();
		}
		
		private function processXML(e:Event):void
		{
			settings = new XML(e.target.data);
			
			isDiag = settings.isDiag[0] == "true";
			sampleRate = Number(settings.sampleRate[0]);
			wheelLength = Number(settings.wheelLength[0]);
			
			//addEventListener(Event.ENTER_FRAME, onUpdate);
			init();
		}
		
		private function init():void
		{
			
			// Add status panel
			stats = new Stats();
			addChild(stats);
			// Add debug log panel
			console = new Console();
			console.maxLines = 10;
			console.textColor = 0xF7F73C;
			console.x = 80;
			console.y = 10;
			console.width = stage.stageWidth - 90;
			console.height = stage.stageHeight - 20;
			addChild(console);
			// if isDiag is true, show the stats and console
			stats.visible = console.visible = isDiag;
			
			diagSerialPort();
			stage.addEventListener(KeyboardEvent.KEY_UP, onKey);
			this.addEventListener(Event.ENTER_FRAME, onUpdate);
			setTimeout(startApp, 100);
		}
		
		private function onUpdate(e:Event):void 
		{
			// TODO Auto-generated method stub
            var time:Number = getTimer();
            var dtime:Number = time - lastTime;
            
			if ( dtime > sampleRate) {
				lastTime = time; // Reset timer
				onFixUpdate();
			}
		}
		
		private function onFixUpdate():void 
		{
			// Do the speed cooldown 
			var cooldownT:Number = getTimer() - speed_lastTime;
            cooldownT = cooldownT > dTimePool[0] ? (cooldownT-dTimePool[0]) : 0;
            if ( currentSpeed > 0 ){
                currentSpeed -= cooldownT/1000 * speed_cooldownRate;
                currentSpeed = currentSpeed > baseSpeed ? currentSpeed : baseSpeed;
                //currentWalt = currentSpeed/3.6 * bikeWaltConstant;
            }
			
			if(_starling)
				BouncingBox(_starling.root).speed = currentSpeed / baseSpeed;
		}
		
		private function diagSerialPort():void
		{
			if (ExternalInterface.available)
			{
				try
				{
					console.log("Adding callback...");
					ExternalInterface.addCallback("toFlash", inputFunc);
				}
				catch (error:SecurityError)
				{
					console.log("A SecurityError occurred: " + error.message);
				}
				catch (error:Error)
				{
					console.log("An Error occurred: " + error.message + "\n");
				}
			}
			else
			{
				console.log("External interface is not available for this container.");
			}
		
		}
		
		private function inputFunc(str:String):void
		{
			console.log("external send (length:" + str.length + "): " + str + "\n");
			calcSpeed();
		}
		
		private function onKey(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ESCAPE || e.keyCode == Keyboard.Q)
			{
				console.log("Escape pressed, exiting programe");
				NativeApplication.nativeApplication.exit(0);
			}
			else if (e.keyCode == Keyboard.D)
			{
				stats.visible = !stats.visible;
				console.visible = !console.visible;
			}
			else if (e.keyCode == Keyboard.SPACE)
			{
				calcSpeed();
				//console.log("Space pressed, recalculating speed");
			}
		}
		
		private function calcSpeed():void
		{
			var time:Number = getTimer();
			var currentDtime:Number = time - speed_lastTime;
			speed_lastTime = time;
			dTimePool.pop();
			dTimePool.unshift(currentDtime);
			//trace(dTimePool.toString());
			var interval:Number = (dTimePool[0] + dTimePool[1] + dTimePool[2]) / 3
			currentSpeed = 1000 / interval * wheelLength * 3.6;
			if (currentSpeed < baseSpeed)
				currentSpeed = baseSpeed;
			//currentWalt = currentSpeed/3.6 * bikeWaltConstant;
			console.log("CurrentSpeed: " + currentSpeed);
		}
		
		public function startApp():void
		{
			_starling = new Starling(BouncingBox, stage);
			//_starling.showStats = true;
			_starling.start();
		}
	
	}

}