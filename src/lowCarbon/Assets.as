package lowCarbon 
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author Shen Yiming
	 */
	public class Assets 
	{
		
		[Embed(source = "../../assets/spritesheet_env.png")]
		public static const AtlasTexture_env:Class;
		
		[Embed(source = "../../assets/spritesheet_env.xml", mimeType = "application/octet-stream")]
		public static const AtlasXml_env:Class;
		
		[Embed(source = "../../assets/spritesheet_hero.png")]
		public static const AtlasTexture_hero:Class;
		
		[Embed(source = "../../assets/spritesheet_hero.xml", mimeType = "application/octet-stream")]
		public static const AtlasXml_hero:Class;
		
		[Embed(source = "../../assets/env/bush02.png")]
		public static const Texture_bush01:Class;
		
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:Dictionary = new Dictionary();
		
		private static function getAtlas(name:String):TextureAtlas
		{
			if(gameTextureAtlas[name] == undefined){
				var tex:Texture = getTexture(name);
				var xml:XML = XML(new Assets[name]());
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
		
	}

}