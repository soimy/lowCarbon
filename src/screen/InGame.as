package screen 
{
	import com.sammyjoeosborne.spriter.Animation;
	import com.sammyjoeosborne.spriter.SpriterMC;
	import com.sammyjoeosborne.spriter.SpriterMCFactory;
	import com.shader.utils.Convert;
	import events.NavigationEvent;
	import flash.filesystem.File;
	import object.Hud;
	import object.MovingEnv;
	import object.Score;
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class InGame extends Sprite 
	{
		private var _globalSpeed:Number = 1;
		private var _juggler:Juggler;
		private var _env:Vector.<MovingEnv>;
		private var _current_env:uint = 0;
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
		
		private var minimap:SpriterMC;
		private var lap:Number = 3;
		
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
			
			_clouds = new MovingEnv(new Array(8, -2000)); // only cloud
			_clouds.farClipPlane = 15000;
			//_clouds.nearClipPlane = 0;
			addChild(_clouds);
			_clouds.addToScene();
			
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
			
			_env = new Vector.<MovingEnv>();
			_env.push(new MovingEnv(new Array(
				0, 0, // cloud
				60, 1300, // green tree
				60, 1300, // bush scene1
				100, 1300, // grass
				10, 1300, // line
				0, 0, // red tree
				0, 0, // other bush
				1, 1301 // startline
				)));
			_env.push(new MovingEnv(new Array(
				0, 0, // cloud (amount, heigh in y)
				0, 0, // green tree
				20, 1300, //bush scene1
				100, 1300, // grass
				10, 1300, // line
				60, 1300, // red tree
				30, 1300 // Other bush
				)));
			_env.push(new MovingEnv(new Array(
				0, 0, // cloud (amount, heigh in y)
				5, 1300, // green tree
				60, 1300, //bush scene1
				100, 1300, // grass
				10, 1300, // line
				5, 1300, // red tree
				60, 1300 // Other bush
				)));
			addChild(_env[_current_env]);
			_env[_current_env].addToScene();
			
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
						
			var scmlFile:File = File.applicationDirectory.resolvePath("assets/minimap.scml");
			minimap = SpriterMCFactory.createSpriterMC("minimap", scmlFile.nativePath, Assets.getAtlas("hero"));
			minimap.name = "minimap01";
			minimap.playbackSpeed = 1;
			addChild(minimap);
			minimap.x = 30;
			minimap.y = 1550;
			//_juggler.add(minimap);
			minimap.play();
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			
			_total_dist = _total_time = 0;
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			//var dtime:Number = e.passedTime * _globalSpeed ;
			//_juggler.advanceTime(dtime);
			var animation:Animation = minimap.currentAnimation;
			animation.gotoTime(_total_dist % lap / lap);
			
			var scene_dist:Number = lap / _env.length;
			if (_current_env != Math.floor(_total_dist % lap / scene_dist)) {
				_env[_current_env].stop();
				var display_index:int = this.getChildIndex(_env[_current_env]);
				_current_env = (_current_env + 1) % _env.length;
				this.addChildAt(_env[_current_env], display_index - 1);
				_env[_current_env].play();
			}
		}
		
		
		
		private function destory(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destory);
			
		}
		
		public function play():void 
		{
			if (!_isPlaying) {
				_env[_current_env].play();
				_clouds.play();
				_time_last = _time_start = new Date().getTime();
				_isPlaying = true;
				
				_hud_score.hide();
			}
		}
		
		public function stop():void 
		{
			if (_isPlaying) {
				_env[_current_env].stop();
				_clouds.stop();
				//_total_dist = _total_time = 0;
				_isPlaying = false;
			}
		}
		
		public function reset():void 
		{
				_total_dist = _total_time = 0;
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
			_env[_current_env].globalSpeed = _globalSpeed;
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