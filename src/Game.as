package 
{
	import com.greensock.TweenLite;
	import com.sammyjoeosborne.spriter.SpriterMCFactory;
	import events.NavigationEvent;
	import flash.filesystem.File;
	import screen.InGame;
	import screen.Opening;
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
		private var opening:Opening;
		private var inGame:InGame;
		public var currentStage:Object;
		public var currentLvl:uint = 0;
		public var globalSpeed:Number = 1;
		public var inGame_timeout:Number = 10000;
		public var stopReset:Boolean = false;
		
		public function Game() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destory);
		}
		
		private function destory(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destory);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeLvl); 
			
			var bgSky:Quad = new Quad(1080,1300);
			bgSky.setVertexColor(0, 0x76d6de);
			bgSky.setVertexColor(1, 0x76d6de);
			bgSky.setVertexColor(2, 0xb1b26c);
			bgSky.setVertexColor(3, 0xb1b26c);
			addChild(bgSky);
			
			opening = new Opening();
			opening.globalSpeed = globalSpeed;
			addChild(opening);
			currentStage = opening;
			opening.play();
			
			inGame = new InGame();
			//inGame.globalSpeed = globalSpeed;
			//inGame.timeOut = inGame_timeout;
			inGame.visible = false;
			//addChild(inGame);
		}

		
		public function syncSpeed(_speed:Number):void 
		{
			globalSpeed = _speed;
			currentStage.globalSpeed = _speed;
		}
				
		private function onChangeLvl(e:NavigationEvent):void 
		{
			changeLevel(e.params.lvl);
		}
		
		public function changeLevel(_lvl:uint):void 
		{
			if (currentLvl == _lvl) return;
			
			var nextLvl:Object;
			currentLvl = _lvl;
			switch (_lvl) 
			{
				case 0:
					nextLvl = opening;
					inGame.stop();
					break;
				case 1:
					nextLvl = inGame;
					opening.stop();
					inGame.timeOut = inGame_timeout;
					inGame.stopReset = stopReset;
					//inGame.reset();
					break;
				case 2:
				default:
			}
			TweenLite.to(currentStage, 1, { y:stage.stageHeight, onComplete:onChangeLvlTweened, onCompleteParams:[nextLvl] } );
		}
		
		private function onChangeLvlTweened(_nextLvl:Object):void 
		{
			removeChild(currentStage as Sprite);
			currentStage.visible = false;
			addChild(_nextLvl as Sprite);
			currentStage = _nextLvl;
			currentStage.visible = true;
			//currentStage.alpha = 0;
			currentStage.y = stage.stageHeight;
			TweenLite.to(currentStage, 1, 
				{ 
					y:0,
					//alpha:1,
					onComplete:function ():void
					{
						if (currentStage == inGame)
							inGame.reset();
						currentStage.play();
					}
				} 
			);
			//currentStage.play();
		}
	}

}