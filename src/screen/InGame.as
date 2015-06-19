package screen 
{
	import com.shader.utils.Convert;
	import events.NavigationEvent;
	import object.Hud;
	import object.MovingEnv;
	import object.Score;
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class InGame extends Sprite 
	{
		private var _globalSpeed:Number = 1;
		private var _juggler:Juggler;
		private var _plants:MovingEnv;
		private var _clouds:MovingEnv;
		private var _hud_dist:Hud;
		private var _hud_time:Hud;
		private var _hud_score:Score;
		private var _total_dist:Number = 0;
		private var _total_time:Number = 0;
		private var _time_start:Number;
		private var _time_last:Number;
		private var _isPlaying:Boolean = false;
		
		private var _timeOut:Number = 30000;
		private var _timeOut_start:Number = 0;
		
		public function InGame() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destory);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_juggler = new Juggler();
			
			_clouds = new MovingEnv(new Array(8, -2000));
			_clouds.farClipPlane = 15000;
			//_clouds.nearClipPlane = 0;
			addChild(_clouds);
			
			var bgTree:Image = new Image(Assets.getAtlas("env").getTexture("bgtrees"));
			bgTree.width *= 2;
			bgTree.height *= 2;
			bgTree.y = 760;
			addChild(bgTree);
			
			var bgGround:Image = new Image(Assets.getAtlas("env").getTexture("bg1"));
			bgGround.width *= 2;
			bgGround.height *= 2;
			bgGround.y = stage.stageHeight - bgGround.height;
			addChild(bgGround);
			
			var bgFog:Image = new Image(Assets.getAtlas("env").getTexture("fog"));
			bgFog.width *= 4.3;
			bgFog.height *= 4.3;
			bgFog.y = 800;
			addChild(bgFog);
			
			_plants = new MovingEnv(new Array(0, 0, 60, 1300, 60, 1300, 100, 1300, 10, 1300));
			addChild(_plants);
			
			var bike:Image = new Image(Assets.getAtlas("env").getTexture("bikefront"));
			addChild(bike);
			bike.y = 1720;
			
			_hud_dist = new Hud(Assets.getAtlas("hero").getTexture("icn_dist"), Hud.POSITION_LEFT);
			_hud_dist.x = 1000;
			_hud_dist.y = 1650;
			_hud_dist.textSize = 100;
			addChild(_hud_dist);
			
			_hud_time = new Hud(Assets.getAtlas("hero").getTexture("icn_time"), Hud.POSITION_RIGHT);
			_hud_time.x = 80;
			_hud_time.y = 1650;
			_hud_time.textSize = 100;
			addChild(_hud_time);
			
			_hud_score = new Score();
			_hud_score.y = -570;
			addChild(_hud_score);
			
		}
		
		
		
		private function destory(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destory);
			
		}
		
		public function play():void 
		{
			if (!_isPlaying) {
				_plants.play();
				_clouds.play();
				_time_last = _time_start = new Date().getTime();
				_isPlaying = true;
				
				_hud_score.hide();
			}
		}
		
		public function stop():void 
		{
			if (_isPlaying) {
				_plants.stop();
				_clouds.stop();
				_total_dist = _total_time = 0;
				_isPlaying = false;
			}
		}
		
		public function set globalSpeed(value:Number):void 
		{
			var cT:Number = new Date().getTime();
			if ( _isPlaying ) {
				// Update time and distance
				var dT:Number = cT - _time_last;
				_total_dist += _globalSpeed * dT * 0.00000277; // in M
				_hud_dist.text = _total_dist.toFixed(2).toString();
				_time_last = cT;
				_total_time += dT;
				_hud_time.text = Convert.leadingZero(uint(_total_time / 60000), 2) + ":" + Convert.leadingZero(uint((_total_time / 1000) % 60), 2);
				_hud_score.co2Amount = [ _total_dist * 78.5, _total_dist * 7.85, _total_dist * 23.55, _total_dist * 0.94];
				_hud_score.dist = _total_dist;
				_hud_score.cal = 330 * _total_time / 1800000;
				
			}
			
			// sync sprite speed
			_globalSpeed = value;
			_plants.globalSpeed = _globalSpeed;
			_clouds.globalSpeed = _globalSpeed;
				
			if (_globalSpeed == 0 && _hud_score.y == -570) {
				_hud_score.show();
				_timeOut_start = cT;
				this.stop();
			} else if (_globalSpeed > 0 && _hud_score.y == 300) {
				_hud_score.hide();
				_timeOut_start = 0;
				this.play();
			}
				
			if (_timeOut_start != 0 && cT - _timeOut_start > _timeOut) {
				// Gameover , switch to open screen
				
				dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{lvl:0}, true));	
			}

		}
		
		public function set timeOut(value:Number):void 
		{
			_timeOut = value;
		}
		
	}

}