package
{
	import com.shader.math.Vec2;
	import com.shader.math.Vec2Const;
	import com.shader.utils.Console;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.utils.Color;
	import starling.events.Event;
	
	public class BouncingBox extends Sprite 
	{
		private var spirit:Image;
		private var angle:Number;
		private var direction:Vec2;
		private var realPos:Vec2;
		private var lastTime:Number;
		public var spriteName:String = "logo";
		public var speed:Number = 1;
			
		public function BouncingBox() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		public function init(e:Event = null):void 
		{
			angle = Math.random() + 0.5;
			
			spirit = new Image(Assets.getAtlas("env").getTexture(spriteName));
			spirit.width = spirit.width >> 2;
			spirit.height = spirit.height >> 2;
			addChild(spirit);
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
			
			// Setup initial values
			realPos = new Vec2(stage.stageWidth >> 1, stage.stageHeight >> 1);
			lastTime = new Date().getTime();
			direction = new Vec2(Math.random(), Math.random());
			direction.normalizeSelf();
			//Main(super).console.log("Directions : "+direction.toString());
			//dispatchEvent(new logEvent(logEvent.HAS_LOG, { content:"Directions : " + direction.toString() }, true));
		}
		
		private function onUpdate(e:Event):void 
		{
			var currentTime:Number = new Date().getTime();
			var dTime:Number = currentTime - lastTime;
			lastTime = currentTime;
			var realW:int = stage.stageWidth - spirit.width;
			var realH:int = stage.stageHeight - spirit.height;
			realPos.addXYSelf(direction.x * speed * dTime * 0.1, direction.y * speed * dTime * 0.1);
			
			spirit.x = Math.floor(realPos.x / realW) % 2 == 0 ? (realPos.x % realW) : realW - (realPos.x % realW);
			spirit.y = Math.floor(realPos.y / realH) % 2 == 0 ? (realPos.y % realH) : realH - (realPos.y % realH);
			
			
		}
		
	}

}