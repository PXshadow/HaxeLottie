package json.properties;

/**
 * ...
 * @author 
 */
class ShapePropKeyFrame 
{

	public function new() 
	{
	}
	/**
	 * end value
	 */
	public var e:Array<ShapeProp> = [];
	/**
	 * start value
	 */
	public var s:Array<ShapeProp> = [];
	/**
	 * time
	 */
	public var t:Float = 0;
	/**
	 * curve in value
	 */
	public var i:Array<Array<Float>> = [];
	/**
	 * curve out value
	 */
	public var o:Array<Array<Float>> = [];
	/**
	 * name used for caching
	 */
	public var nm:Float = 0;
	
}