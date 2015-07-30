package object 
{
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite3D;
	import starling.filters.ColorMatrixFilter;
	
	public class Particle extends Sprite3D 
	{
		private var _id:uint;
		private var _typ:uint;
		private var _image:Image;
		private var scale:Number;
		private var spritePool:Array;
		private var tintFilter:ColorMatrixFilter;
		private var _tint:Number;
		
		public var tintColor:uint = 0xffffff;
		
		public function Particle(typ:uint) 
		{
			super();
			
			// initialize array pool
			spritePool = new Array();
			spritePool[0] = ["cloud01", "cloud02", "cloud03"];
			spritePool[1] = ["tree01", "tree02", "tree03", "tree04"];
			spritePool[2] = ["bush01", "bush02", "bush03"];
			spritePool[3] = ["grass01", "grass02", "grass03", "grass04", "grass05"];
			spritePool[4] = ["line"];
			spritePool[5] = ["tree05", "tree06", "tree07", "tree08", "tree09"];
			spritePool[6] = ["bush04", "bush05", "bush06", "bush07"];
			spritePool[7] = ["startline"];
			
			_typ = typ;
			_id = Math.random() * spritePool[_typ].length;
			_image = new Image(Assets.getAtlas("env").getTexture(spritePool[_typ][_id]));
			scale = Math.random() * 0.3 + 0.85; // tree size viriation 15%
			_image.width *= scale;
			_image.height *= scale;
			// Put zero cordinate to tree's root
			_image.x = -_image.width * 0.5;
			_image.y = -_image.height;
			addChild(_image);
			//addChild(new Quad(5, 5, 0xff0000));
			tintFilter = new ColorMatrixFilter();
			//this.filter = tintFilter;
		}
		
		public function get id():uint 
		{
			return _id;
		}
		
		public function set id(value:uint):void 
		{
			_id = value;
			_image = new Image(Assets.getAtlas("env").getTexture(spritePool[_typ][_id]));
		}
		
		public function get tint():Number 
		{
			return _tint;
		}
		
		public function set tint(value:Number):void 
		{
			_tint = value;
			if (value > 0) {
				tintFilter.reset();
				tintFilter.tint(tintColor, value);
			}
		}
		
	}

}