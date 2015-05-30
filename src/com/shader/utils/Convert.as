package com.shader.utils 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Convert 
	{
		
		public static function leadingZero(val:Number, places:uint):String
		{
			var result:String = val.toString();
			for(var i:int = result.length; i < places; i++)
			{
				result = '0' + result;
			}
			return result;
		}
		
		public static function uint2hex(dec:uint):String 
		{
			var digits:String = "0123456789ABCDEF";
			var hex:String = '';
		 
			while (dec > 0) {
				var next:uint = dec & 0xF;
				dec >>= 4;
				hex = digits.charAt(next) + hex;
			}
			if (hex.length == 0) hex = '0'
			if (hex.length == 1) hex = "0" + hex;
			return hex;
		}
	}

}