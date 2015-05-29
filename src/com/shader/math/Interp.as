package com.shader.math 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Interp 
	{
		
		public static function remap(min:Number, max:Number, percent:Number):Number
		{
			return min + percent * (max - min);
		}
		
		public static function linstep(min:Number, max:Number, x:Number):Number 
		{
			return x > max ? 1 : (x < min ? 0 : (x - min) / (max - min));
		}
		
	}

}