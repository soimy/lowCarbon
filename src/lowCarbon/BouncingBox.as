package lowCarbon
{
	import com.shader.math.Vec2;
	import com.shader.math.Vec2Const;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.utils.Color;
	import starling.events.Event;
	
	
	/**
	 * ...
	 * @author Shen Yiming
	 */
	public class BouncingBox extends Sprite 
	{
		private var spirit:Image;
		private var angle:Number;
		private var direction:Vec2;
		public var speed:Number = 0.1;
			
		public function BouncingBox() 
		{
			//super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		public function init(e:Event = null):void 
		{
			angle = Math.random() + 0.5;
			
			spirit = new Image(Assets.getTexture("Texture_bush01"));
			addChild(spirit);
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
			
		}
		
		private function onUpdate(e:Event):void 
		{
			var currentTime:Number = new Date().getTime();
			var realW:uint = stage.stageWidth - spirit.width;
			var realH:uint = stage.stageHeight - spirit.height;
			
			spirit.x = Math.floor(currentTime * speed / realW) % 2 == 0 ? (currentTime * speed % realW) : realW - (currentTime * speed % realW);
			spirit.y = Math.floor(currentTime * angle * speed / realH) % 2 == 0 ? (currentTime * angle * speed % realH) : realH - (currentTime * angle * speed % realH);
			
		}
		
	}

}