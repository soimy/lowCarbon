package lowCarbon
{
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.utils.Color;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Shen Yiming
	 */
	public class Game extends Sprite 
	{
		private var quad:Quad;
		private var angle:Number;
		public var speed:Number = 0.1;
			
		public function Game() 
		{
			//super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		public function init(e:Event = null):void 
		{
			angle = Math.random() + 0.5;
			
			quad = new Quad(50, 50, Color.RED);
			quad.x = stage.stageWidth - quad.width >> 1;
			quad.y = stage.stageHeight - quad.height >> 1;
			quad.setVertexColor(0, Color.OLIVE);
			quad.setVertexColor(1, Color.RED);
			quad.setVertexColor(2, Color.YELLOW);
			quad.setVertexColor(3, Color.BLUE);
			addChild(quad);
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
			
		}
		
		private function onUpdate(e:Event):void 
		{
			var currentTime:Number = new Date().getTime();
			var realW:uint = stage.stageWidth - quad.width;
			var realH:uint = stage.stageHeight - quad.height;
			
			quad.x = Math.floor(currentTime * speed / realW) % 2 == 0 ? (currentTime * speed % realW) : realW - (currentTime * speed % realW);
			quad.y = Math.floor(currentTime * angle * speed / realH) % 2 == 0 ? (currentTime * angle * speed % realH) : realH - (currentTime * angle * speed % realH);
			
		}
		
	}

}