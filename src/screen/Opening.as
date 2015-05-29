package screen
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
	public class Opening extends Sprite 
	{
		// Setup SpriterMC
		private var cloud:SpriterMC;
		private var treebg:SpriterMC;
		private var tree:SpriterMC;
		private var fg:SpriterMC;
		private var hero:SpriterMC;
		private var logo:SpriterMC;
		
		public var globalSpeed:Number = 1;
		
		private var _juggler:Juggler;
		private var _isPlaying:Boolean;
		
		public function Opening() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destory);
		}
		
		private function destory(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destory);
			if (_isPlaying) stop();
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_juggler = new Juggler();
			_isPlaying = false;
			
			
			var bgGround:Image = new Image(Assets.getAtlas("env").getTexture("bg"));
			bgGround.width *= 2;
			bgGround.height *= 2;
			
			var logo:Image = new Image(Assets.getAtlas("env").getTexture("logo"));
			logo.x = 0;
			logo.y = 1400;
			
			var scmlFile:File = File.applicationDirectory.resolvePath("assets/open_cloud.scml");
			cloud = SpriterMCFactory.createSpriterMC("cloud", scmlFile.nativePath, Assets.getAtlas("env"), onSpriterReady);
			cloud.name = "cloud01";
			cloud.playbackSpeed = 0.01;
			
			scmlFile = File.applicationDirectory.resolvePath("assets/open_treebg.scml");
			treebg = SpriterMCFactory.createSpriterMC("treebg", scmlFile.nativePath, Assets.getAtlas("env"), onSpriterReady);
			treebg.name = "treebg01";
			treebg.playbackSpeed = 0.03;
			
			scmlFile = File.applicationDirectory.resolvePath("assets/open_tree.scml");
			tree = SpriterMCFactory.createSpriterMC("tree", scmlFile.nativePath, Assets.getAtlas("env"), onSpriterReady);
			tree.name = "tree01";
			tree.playbackSpeed = 0.05;
			
			scmlFile = File.applicationDirectory.resolvePath("assets/open_bush.scml");
			fg = SpriterMCFactory.createSpriterMC("bush", scmlFile.nativePath, Assets.getAtlas("env"), onSpriterReady);
			fg.name = "bush01";
			fg.playbackSpeed = 0.1;
			
			scmlFile = File.applicationDirectory.resolvePath("assets/qiche.scml");
			hero = SpriterMCFactory.createSpriterMC("hero", scmlFile.nativePath, Assets.getAtlas("hero"), onSpriterReady);
			hero.name = "hero01";
			hero.playbackSpeed = 0.25;
			hero.x = 600;
			hero.y = 960;
			
			
			this.addChild(cloud);
			this.addChild(treebg);
			this.addChild(bgGround);
			this.addChild(tree);
			this.addChild(hero);
			this.addChild(fg);
			this.addChild(logo);
			_juggler.add(cloud);
			_juggler.add(treebg);
			_juggler.add(tree);
			_juggler.add(hero);
			_juggler.add(fg);
			cloud.play();
			treebg.play();
			tree.play();
			hero.play();
			fg.play();
			
			play();
		}
		
		public function play():void 
		{
			if (!_isPlaying) {
				addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
				_isPlaying = true;
			}
		}
		
		public function stop():void 
		{
			if (_isPlaying) {
				removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
				_isPlaying = false;
			}
		}
		
		private function onSpriterReady(e:Event):void 
		{
			var spriterMC:SpriterMC = e.target as SpriterMC;
			trace("SpriterMC Ready : " + spriterMC.spriterName);
			if (spriterMC.spriterName == "hero") {
				spriterMC.width *= 0.75;
				spriterMC.height *= 0.75;
			}
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			var speed:Number = globalSpeed < 1 ? 1 : globalSpeed;
			_juggler.advanceTime(e.passedTime * speed);
		}
		
	}

}