package;
import haxe.Json;
import json.Animation;
import json.properties.ShapeKeyframed;
import json.properties.ShapeProp;
import json.properties.ShapePropKeyFrame;
import json.shapes.Ellipse;
import json.shapes.Fill;
import json.shapes.GFill;
import json.shapes.GStroke;
import json.shapes.Group;
import json.shapes.Merge;
import json.shapes.Shape;
import json.shapes.Star;
import json.shapes.Stroke;
import json.shapes.Trim;
import json.sources.Chars;
import openfl.Assets;
import openfl.display.CapsStyle;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;

/**
 * ...
 * @author 
 */
class Lottie 
{
	public var layerArray:Array<openfl.display.Shape> = [];
	public function new(path:String) 
	{
		var data:Animation = Json.parse(Assets.getText(path));
		if(data.assets != null) for (asset in data.assets)
		{
			
		}
		if(data.chars != null) for (char in data.chars)
		{
			char = cast(char, Chars);
		}
		if (data.layers != null) for (layer in data.layers)
		{
			//type
			trace("layer " + layer.ty);
			switch(layer.ty)
			{
				case 4:
				//shape
				parseShape(layer);
			}
		}
	}
	private function parseShape(shapeClass:Group)
	{
		if (shapeClass.shapes != null) parseTypeArray(shapeClass.shapes);
		if (shapeClass.it != null) parseTypeArray(shapeClass.it);
	}
	private function parseTypeArray(array:Array<Dynamic>)
	{
		array.reverse();
		for (i in 0...array.length)
		{
			var shape = new openfl.display.Shape();
			shape.cacheAsBitmap = true;
			layerArray[i] = shape;
			parseType(array[i],i);
		}
	}
	private function parseType(data:Dynamic,index:Int=0)
	{
		switch(data.ty)
		{
			case "sh":
			//shape
			trace("shape");
			var e:Shape = data;
			//initalize shape
			var shape = layerArray[index];
			shape.cacheAsBitmap = true;
			shape.graphics.lineStyle(2, 0xFFFFFF);
			//set render
			var prop:json.properties.Shape = e.ks;
			if (prop.k[0] != null)
			{
				for (i in 0...prop.k.length)
				{
					var value:ShapePropKeyFrame = prop.k[i];
				}
			}else{
				var vert:json.properties.ShapeProp = prop.k;
				renderVert(vert,shape);
			}
			case "rc":
			//rect
			trace("rect");
			case "el":
			//ellipse
			var e:Ellipse = data;
			trace("circle");
			case "sr":
			//star
			var e:Star = data;
			case "fl":
			//fill
			var e:Fill = data;
			trace("fill");
			case "gf":
			//gFill
			var e:GFill = data;
			
			case "gs":
			//gStroke
			var e:GStroke = data;
			case "st":
			//stroke
			var shape = layerArray[index];
			var e:Stroke = data;
			var cap:CapsStyle = data.lc;
			if (e.lc == 1) cap = CapsStyle.SQUARE;
			if (e.lc == 0) cap = CapsStyle.ROUND;
			var join:JointStyle = data.lj;
			var miter:Int = data.ml;
			shape.graphics.lineStyle(e.w.k, Color.rgbFloatToInt(e.c.k[0], e.c.k[1], e.c.k[2]), e.o.k / 100, false, LineScaleMode.NORMAL, cap, join, miter);
			case "mm":
			//merge
			var e:Merge = data;
			case "tm":
			//trim
			var e:Trim = data;
			case "gr":
			//group
			var group:Group = data;
			parseShape(group);
		}
	}
	private function renderVert(v:ShapeProp,shape:openfl.display.Shape)
	{
		shape.x = 300;
		shape.y = 300;
		trace("render " + v);
		for (x in 0...v.i.length)
		{
			//shape.graphics.cubicCurveTo(0, 0, 0, 0, v[x][0], v[x][1]);
			var aX = v.v[x][0];
			var aY = v.v[x][1];
			var cX = v.i[x][0];
			var cY = v.i[x][1];
			var cX2 = v.o[x][0];
			var cY2 = v.o[x][1];
			if (x == 0) shape.graphics.moveTo(aX, aY);
			if (cX == 0) cX = aX;
			if (cY == 0) cY = aY;
			if (cX2 == 0) cX2 = aX;
			if (cY2 == 0) cY2 = aY;
			shape.graphics.cubicCurveTo(cX, cY, cX2, cY2, aX, aY);
		}
	}
	
}