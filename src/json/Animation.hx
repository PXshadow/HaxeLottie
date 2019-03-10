package json;
class Animation
{
	public function new()
	{
	}
	/**
	*Chars
	*source chars for text layers
	**/
	public var chars:Array<Dynamic> = [];
	/**
	*Assets
	*source items that can be used in multiple places. Comps and Images for now.
	**/
	public var assets:Array<Dynamic> = [];
	/**
	*Layers
	*List of Composition Layers
	**/
	public var layers:Array<Dynamic> = [];
	/**
	*Height
	*Composition Height
	**/
	public var h:Int = 0;
	/**
	*Version
	*Bodymovin Version
	**/
	public var v:String = '';
	/**
	*Width
	*Composition Width
	**/
	public var w:Int = 0;
	/**
	*Frame Rate
	**/
	public var fr:Int = 0;
	/**
	*In Point
	*In Point of the Time Ruler. Sets the initial Frame of the animation.
	**/
	public var ip:Int = 0;
	/**
	*Out Point
	*Out Point of the Time Ruler. Sets the final Frame of the animation
	**/
	public var op:Int = 0;
	/**
	 * Name
	 */
	public var nm:String= '';
}
