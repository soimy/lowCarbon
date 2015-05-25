package 
{
	import com.sammyjoeosborne.spriter.SpriterMCFactory;
	import flash.filesystem.File;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.animation.Juggler;
	import starling.display.Sprite;
	import com.sammyjoeosborne.spriter.SpriterMC;
	
	/**
	 * ...
	 * @author Shen Yiming
	 */
	public class Game extends Sprite 
	{
		// Setup SpriterMC
		public var _hero:SpriterMC;
		private var _juggler:Juggler;
		public var globalSpeed:Number = 0.1;
		
		public function Game() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_juggler = new Juggler();
			
			var scmlFile:File = File.applicationDirectory.resolvePath("assets/qiche.scml");
			_hero = SpriterMCFactory.createSpriterMC("qiche", scmlFile.nativePath, Assets.getAtlas("hero"), onSpriterReady);
			_hero.name = "qiche01";
			_hero.playbackSpeed = 0.5;
			
			
			this.addChild(_hero);
			_juggler.add(_hero);
			_hero.play();
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onSpriterReady(e:Event):void 
		{
			var spriterMC:SpriterMC = e.target as SpriterMC;
			trace("SpriterMC Ready : " + spriterMC.spriterName);
			_hero.width *= 0.25;
			_hero.height *= 0.25;
			_hero.x = stage.stageWidth * 0.5;
			_hero.y = stage.stageHeight * 0.5;
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			_juggler.advanceTime(e.passedTime * globalSpeed);
		}
		
	}

}