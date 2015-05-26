package 
{
	import com.sammyjoeosborne.spriter.SpriterMCFactory;
	import flash.filesystem.File;
	import starling.display.Image;
	import starling.display.Quad;
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
		public var cloud:SpriterMC;
		public var treebg:SpriterMC;
		public var tree:SpriterMC;
		public var fg:SpriterMC;
		private var _juggler:Juggler;
		public var globalSpeed:Number = 1;
		
		public function Game() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_juggler = new Juggler();
			
			var bgSky:Quad = new Quad(1080,1300);
			bgSky.setVertexColor(0, 0x76d6de);
			bgSky.setVertexColor(1, 0x76d6de);
			bgSky.setVertexColor(2, 0xb1b26c);
			bgSky.setVertexColor(3, 0xb1b26c);
			addChild(bgSky);
			
			var bgGround:Image = new Image(Assets.getAtlas("env").getTexture("bg"));
			bgGround.width *= 2;
			bgGround.height *= 2;
			addChild(bgGround);
			
			var scmlFile:File = File.applicationDirectory.resolvePath("assets/open_cloud.scml");
			cloud = SpriterMCFactory.createSpriterMC("cloud", scmlFile.nativePath, Assets.getAtlas("env"), onSpriterReady);
			cloud.name = "cloud01";
			cloud.playbackSpeed = 0.01;
			
			scmlFile = File.applicationDirectory.resolvePath("assets/open_treebg.scml");
			treebg = SpriterMCFactory.createSpriterMC("treebg", scmlFile.nativePath, Assets.getAtlas("env"), onSpriterReady);
			treebg.name = "treebg01";
			treebg.playbackSpeed = 0.05;
			
			this.addChild(cloud);
			this.addChild(treebg);
			_juggler.add(cloud);
			_juggler.add(treebg);
			cloud.play();
			treebg.play();
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onSpriterReady(e:Event):void 
		{
			var spriterMC:SpriterMC = e.target as SpriterMC;
			trace("SpriterMC Ready : " + spriterMC.spriterName);
			//spriterMC.width *= 0.5;
			//spriterMC.height *= 0.5;
			//spriterMC.x = 0;
			//spriterMC.y = 0;
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			_juggler.advanceTime(e.passedTime * globalSpeed);
		}
		
	}

}