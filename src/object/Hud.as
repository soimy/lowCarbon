package object 
{
	import starling.events.Event;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class Hud extends Sprite 
	{
		public static const POSITION_LEFT:uint = 0;
		public static const POSITION_RIGHT:uint = 1;
		public static const POSITION_TOP:uint = 2;
		public static const POSITION_BOTTOM:uint = 3;
		
		private var _text:String = "000000";
		private var _textField:TextField;
		private var _icon:Image;
		private var _margin:int = 10;
		private var _baseline:int = 0;
		private var _textSize:uint = 64;
		private var _textFont:String;
		private var _placement:uint;
		
		public function Hud(icon:Texture, pos:uint) 
		{
			super();
			_icon = new Image(icon);
			_placement = pos;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//_icon.x = -_icon.width * 0.5;
			//_icon.y = -_icon.height * 0.5;
			addChild(_icon);
			
			_textFont = Assets.getFont("badabb").name;
			_textField = new TextField(stage.stageWidth * 0.5, _textSize+50, _text, _textFont, _textSize, 0xffffff);
			//_textField.border = true;
			addChild(_textField);
			textFieldPlacement(_placement);
		}
		
		private function textFieldPlacement(pos:uint):void 
		{
			
			_textField.width = _text.length * _textSize + 50;
			_textField.height = _textSize + 50;
			_textField.width = _textField.textBounds.width + 50;
			_textField.height = _textField.textBounds.height + 50;
			
			switch (pos) 
			{
				case 0:
					_icon.x = -_icon.width;
					_icon.y = -_icon.height * 0.5;
					_textField.hAlign = HAlign.RIGHT;
					_textField.vAlign = VAlign.CENTER;
					_textField.y = -_textField.height * 0.5 + _baseline;
					_textField.x = -_icon.width - _margin - _textField.width;
					break;
				case 1:
					_icon.x = 0;
					_icon.y = -_icon.height * 0.5;
					_textField.hAlign = HAlign.LEFT;
					_textField.vAlign = VAlign.CENTER;
					_textField.y = -_textField.height * 0.5 + _baseline;
					_textField.x = _icon.width + _margin;
					break;
				case 2:
					_icon.x = -_icon.width * 0.5;
					_icon.y = -_icon.height;
					_textField.hAlign = HAlign.CENTER;
					_textField.vAlign = VAlign.BOTTOM;
					_textField.y = -_icon.height - _margin - _textField.height + _baseline;
					_textField.x = -_textField.width * 0.5;
					break;
				case 3:
					_icon.x = -_icon.width * 0.5;
					_icon.y = 0;
					_textField.hAlign = HAlign.CENTER;
					_textField.vAlign = VAlign.TOP;
					_textField.y = _icon.height  + _margin + _baseline;
					_textField.x = -_textField.width * 0.5;
					break;
				default:
			}
		}
		
		public function get text():String 
		{
			return _text;
		}
		
		public function set text(value:String):void 
		{
			_text = value;
			if (_textField) {
				_textField.text = _text;
				textFieldPlacement(_placement);
			}
		}
		
		public function set textSize(value:uint):void 
		{
			_textSize = value;
			if (_textField) {
				_textField.fontSize = _textSize;
				textFieldPlacement(_placement);
			}
		}
		
		public function get textSize():uint 
		{
			return _textSize;
		}
		
		public function get textFont():String 
		{
			return _textFont;
		}
		
		public function set textFont(value:String):void 
		{
			_textFont = value;
			if (_textField) {
				_textField.fontName = _textFont;
				textFieldPlacement(_placement);
			}
		}
		
		public function set margin(value:uint):void 
		{
			_margin = value;
		}
		
		public function set baseline(value:int):void 
		{
			_baseline = value;
			if (_textField) {
				textFieldPlacement(_placement);
			}
		}
		
	}

}