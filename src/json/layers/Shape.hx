package json.layers;

/**
 * ...
 * @author 
 */
class Shape 
{

	public function new() 
	{
	}
	/**
	 * type
	 */
	public var ty:Float = 0;
	/**
	 * transform
	 */
	public var ks:Dynamic;
	/**
	 * auto orient
	 */
	public var ao:Float = 0;
	/**
	 * blend mode
	 */
	public var bm:Float = 0;
	/**
	 * 3d layer
	 */
	public var ddd:Float = 0;
	/**
	 * index
	 */
	public var ind:Float = 0;
	/**
	 * class layer name
	 */
	public var cl:String = "";
	/**
	 * layer html id
	 */
	public var ln:String = "";
	/**
	 * in point, inital frame of layer
	 */
	public var ip:Float = 0;
	/**
	 * out point, final frame of the layer
	 */
	public var op:Float = 0;
	/**
	 * start time
	 */
	public var st:Float = 0;
	/**
	 * name
	 */
	public var nm:Float = 0;
	/**
	 * has masks
	 */
	public var hasMask:Float = 0;
	/**
	 * mask properties
	 */
	public var maskProperties:Array<Dynamic> = [];
	/**
	 * effects
	 */
	public var ef:Array<Dynamic> = [];
	/**
	 * stretch
	 */
	public var sr:Float = 0;
	/**
	 * Layer parent
	 */
	public var parent:Float = 0;
	/**
	 * items [shape,rect,ellipse,star,fill,gFill,gStroke,stroke,merge,trim,group,roundedCorners]
	 */
	public var shapes:Array<Dynamic> = [];
	
}