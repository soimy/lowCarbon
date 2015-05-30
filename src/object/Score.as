package object 
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Score extends Sprite 
	{
		private var _co2Amount:Array;
		private var _cal:Number;
		private var _dist:Number;
		
		private var _score_cal:Hud;
		private var _score_dist:Hud;
		private var _score_co2:Vector.<Hud>;
		private var _score_tips:Vector.<Image>;
		
		public function Score() 
		{
			super();
			
			_co2Amount = new Array();
			_score_co2 = new Vector.<Hud>();
			_score_tips = new Vector.<Image>();
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var bg:Quad = new Quad(stage.stageWidth, 900, 0x000000);
			bg.alpha = 0.5;
			addChild(bg);
			
			_score_cal = new Hud(Assets.getAtlas("hero").getTexture("finalscore01"), Hud.POSITION_RIGHT);
			addChild(_score_cal);
			_score_cal.textSize = 120;
			_score_cal.baseline = 20;
			_score_cal.text = "000000"
			_score_cal.x = stage.stageWidth * 0.5 -_score_cal.width * 0.5;
			_score_cal.y = 200;
			
			
			_score_dist = new Hud(Assets.getAtlas("hero").getTexture("finalscore02"), Hud.POSITION_RIGHT);
			addChild(_score_dist);
			_score_dist.textSize = 120;
			_score_dist.baseline = 10;
			_score_dist.text = "000000"
			_score_dist.x = stage.stageWidth * 0.5 - _score_dist.width * 0.5;
			_score_dist.y = 380;
			
			
			var margin:Number = 180;
			var space:Number = (stage.stageWidth - margin * 2) / 3;
			for (var i:int = 0; i < 4; i++) 
			{
				var icon:Image = new Image(Assets.getAtlas("hero").getTexture("icn_score0" + (i + 1)));
				icon.x = margin + space * i- icon.width * 0.5;
				icon.y = 600;
				addChild(icon);
				
				var tips:Image = new Image(Assets.getAtlas("hero").getTexture("tips0" + (i + 1)));
				tips.x = margin + space * i - tips.width * 0.5;
				tips.y = 570;
				addChild(tips);
				tips.visible = false;
				_score_tips.push(tips);
				
				var score:Hud = new Hud(Assets.getAtlas("hero").getTexture("co2"), Hud.POSITION_RIGHT);
				score.margin = -10;
				addChild(score);
				score.textSize = 64;
				score.text = "000";
				score.x = margin + space * i - score.width * 0.5 + 10;
				score.y = 840;
				_score_co2.push(score);
			}
		}
		
		public function set co2Amount(value:Array):void
		{
			_co2Amount = value;
			for (var i:int = 0; i < _co2Amount.length; i++) 
			{
				_score_co2[i].text = uint(_co2Amount[i]).toString() + "g";
			}
		}
		
		public function set cal(value:Number):void 
		{
			_cal = value;
			_score_cal.text = uint(_cal).toString() + " CAL";
		}
		
		public function set dist(value:Number):void 
		{
			_dist = value;
			_score_dist.text = value.toFixed(2).toString() + " KM";
		}
		
		public function hide():void 
		{
			TweenLite.to(this, 0.5, 
				{ 
					y: -650, 
					onComplete:function ():void 
					{
						toggleTips(false);
					}
				}
			);
		}
		
		public function show():void 
		{
			TweenLite.to(this, 0.5, 
				{ 
					y: 300, 
					onComplete:function ():void 
					{
						toggleTips(true);
					},
					ease: Back.easeOut
				}
			);
		}
		
		private function toggleTips(_visible:Boolean):void 
		{
			for (var i:int = 0; i < _score_tips.length; i++) 
			{
				_score_tips[i].visible = _visible;
				if (_visible) {
					TweenLite.from(_score_tips[i], 0.5, { 
						alpha:0, 
						y:"-30", 
						ease: Cubic.easeOut, 
						delay: 0.25*i
					});
				}
			}
		}
	}

}