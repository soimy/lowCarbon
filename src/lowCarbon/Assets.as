package lowCarbon 
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Shen Yiming
	 */
	public class Assets 
	{
		
		[Embed(source = "../../assets/spritesheet_env.png")]
		public static const textureEnv:Class;
		
		[Embed(source = "../../assets/spritesheet_hero.png")]
		public static const textureHero:Class;
		
		private static var gameTextures:Dictionary = new Dictionary();
		
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