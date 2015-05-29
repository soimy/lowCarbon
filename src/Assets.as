package 
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author Shen Yiming
	 */
	public class Assets 
	{
		
		[Embed(source = "../assets/spritesheet_env.png")]
		public static const AtlasTexture_env:Class;
		
		[Embed(source = "../assets/spritesheet_env.xml", mimeType = "application/octet-stream")]
		public static const AtlasXml_env:Class;
		
		[Embed(source = "../assets/spritesheet_hero.png")]
		public static const AtlasTexture_hero:Class;
		
		[Embed(source = "../assets/spritesheet_hero.xml", mimeType = "application/octet-stream")]
		public static const AtlasXml_hero:Class;
		
		[Embed(source = "../assets/font/badabb.png")]
		public static const Font_badabb:Class;
		
		[Embed(source = "../assets/font/badabb.fnt", mimeType = "application/octet-stream")]
		public static const FontXml_badabb:Class;
		
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:Dictionary = new Dictionary();
		private static var gameFonts:Dictionary = new Dictionary();
		
		public static function getAtlas(name:String):TextureAtlas
		{
			if(gameTextureAtlas[name] == undefined){
				var tex:Texture = getTexture("AtlasTexture_"+name);
				var xml:XML = XML(new Assets["AtlasXml_"+name]());
				gameTextureAtlas[name] = new TextureAtlas(tex, xml);
			}
			return gameTextureAtlas[name];
		}
		
		public static function getTexture(name:String):Texture 
		{
			if (gameTextures[name] == undefined) {
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
		
		public static function getFont(name:String):BitmapFont 
		{
			if (gameFonts[name] == undefined) {
				var tex:Texture = getTexture("Font_" + name);
				var xml:XML = XML(new Assets["FontXml_" + name]());
				gameFonts[name] = new BitmapFont(tex, xml);
				TextField.registerBitmapFont(gameFonts[name]); // this is important
			}
			return gameFonts[name];
		}
	}

}