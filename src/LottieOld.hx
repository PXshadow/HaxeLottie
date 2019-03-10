package;

import haxe.Json;
import lime.math.ColorMatrix;
import openfl.Assets;
import openfl.Lib;
import openfl.display.CapsStyle;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.Shape;
import openfl.geom.Point;
import openfl.Vector;
class LottieOld 
{
	var data:Dynamic = null;
	var version:String = "";
	var inital:Float = 0;
	var end:Float = 0;
	var framerate:Float = 60;
	var width:Int = 0;
	var height:Int = 0;
	
	public function new(path:String) 
	{
		Assets.loadText(path).onComplete(function(string:String)
		{
			data = Json.parse(string);
			try {
			parse();
			}catch (e:Dynamic)
			{
				trace("error " + e);
			}
			parse();
		});
		//color.redMultiplier = 0.3;
		//color.blueMultiplier = 0.91;
		//color.greenMultiplier = 0.02;
		trace("color: " + Color.rgbFloatToInt(0.3, 0.91, 0.02));
	}
	private function parse()
	{
		//animation
		version = data.v;
		width = data.w;
		height = data.h;
		inital = data.ip;
		end = data.ep;
		framerate = data.fr;
		//layer
		parseLayer();
	}
	private function parseLayer()
	{
		var layerArray:Array<Dynamic> = data.layers;
		for (l in layerArray)
		{
			var shapes:Array<Dynamic> = l.shapes[0].it;
			var shape = new ShapeAnimation();
			shape.cacheAsBitmap = true;
			shape.graphics.lineStyle(3, 0xFFFFFF);
			//shape.graphics.drawCircle(20, 20, 20);
			Lib.current.addChild(shape);
			trace("shapes length " + shapes.length);
			shapes.reverse();
			//object layer
			var object:ObjectType = 
			{
			name:l.nm,
			type:Std.parseInt(l.ty),
			transform:parseTransform(l.ks),
			autoOrient:(l.ao == 1 ? true : false),
			index:l.ind,
			blendMode:l.bm,
			inital:l.ip,
			end:l.op,
			strech:l.sr,
			start:l.sr,
			shape:null
			};
			//anchor
			shape.aX = object.transform.anchor.value[0];
			shape.aY = object.transform.anchor.value[1];
			//opacity
			shape.opacity = object.transform.opacity.value[0] / 100;
			//scale
			shape.sX = object.transform.scale.value[0] / 100;
			shape.sY = object.transform.scale.value[1] / 100;
			//rotation
			shape.rot = object.transform.rotation.value[0] / 100;
			//pos
			//shape.pX = object.transform.pos.value[0];
			//shape.pY = object.transform.pos.value[1];
			//parse
			for (data in shapes)
			{
				switch(data.ty)
				{
					case "sh":
					//shape	
					parseShape(data, shape);
					case "tr":
					//trime
					parseTrim(data, shape);
					case "st":
					//stroke
					parseStroke(data, shape);
					case "fl":
					//fill
					parseStroke(data, shape);
					case "tr":
					//transform
					trace("tr");
					parseTransformShape(data, shape);
				}
			}
			object.shape = shape;
		}
		//trace("layers " + layerArray);
	}
	private function parseShapeTransform(data:Dynamic):TransformShapeType
	{
		trace("data transform " + data);
		return {opacity:parseDimension(data.o), rotation:parseDimension(data.r),pos:parseDimension(data.p),anchor:parseDimension(data.a),scale:parseDimension(data.s)};
	}
	private function parseLayerTransform(data:Dynamic):TransformLayerType
	{
		
	}
	private function parseDimension(data:Dynamic):Dimension
	{
		var value:Array<Int> = [];
		if (Std.is(data.k,Int)) 
		{
			value = [data.k];
		}else{
			value = data.k;
		}
		return {animated:(data.a == 1 ? true : false), value:value};
	}
	private function parseShape(data:Dynamic,shape:ShapeAnimation)
	{
		//data.ks.k
		trace("parse shape");
		var vert = data.ks.k;
		if (Std.is(data.ks.k, Array))
		{
			renderVert(vert, shape);
		}else{
			renderVert([vert], shape);
		}
	}
	private function renderVert(vert:Array<Dynamic>,shape:ShapeAnimation)
	{
		for (k in vert)
		{
			var i:Array<Array<Float>> = k.i;
			var o:Array<Array<Float>> = k.o;
			var v:Array<Array<Float>> = k.v;
			if (i == null || o == null || v == null)
			{
				var s = k.s;
				var e = k.e;
				if (s != null)
				{
					
				}
				if ( e != null)
				{
					
				}
			}else{
				shape.x = 300;
				shape.y = 300;
				for (x in 0...i.length)
				{
					//shape.graphics.cubicCurveTo(0, 0, 0, 0, v[x][0], v[x][1]);
					var aX = v[x][0];
					var aY = v[x][1];
					var cX = i[x][0];
					var cY = i[x][1];
					var cX2 = o[x][0];
					var cY2 = o[x][1];
					if (x == 0) shape.graphics.moveTo(aX, aY);
					if (cX == 0) cX = aX;
					if (cY == 0) cY = aY;
					if (cX2 == 0) cX2 = aX;
					if (cY2 == 0) cY2 = aY;
					shape.graphics.cubicCurveTo(cX, cY, cX2, cY2, aX, aY);
				}
			}
		}
	}
	private function parseTrim(data:Dynamic, shape:ShapeAnimation)
	{
		
	}
	private function parseStroke(data:Dynamic, shape:ShapeAnimation)
	{
		trace("data " + data);
		var color = Color.rgbFloatToInt(data.c.k[0], data.c.k[1], data.c.k[2]);
		var opacity = data.o.k / 100;
		var stroke = data.w.k;
		var cap:CapsStyle = data.lc;
		if (data.lc == 1) cap = CapsStyle.SQUARE;
		if (data.lc == 0) cap = CapsStyle.ROUND;
		var join:JointStyle = data.lj;
		var miter:Int = data.ml;
		shape.graphics.lineStyle(stroke, color, opacity, false, LineScaleMode.NORMAL, cap, join, miter);
	}
	private function parseFill(data:Dynamic, shape:ShapeAnimation)
	{
		
	}
	//"ks":{"o":{"a":0,"k":100},"r":{"a":0,"k":0},"p":{"a":0,"k":[250,250,0]},"a":{"a":0,"k":[250,250,0]},"s":{"a":0,"k":[100,100,100]}}
}
//nm ty ks
/*typedef ObjectType = {name:String, type:Int, transform:ObjectTransFormType, autoOrient:Bool, index:Int, blendMode:Int, inital:Int, end:Int, strech:Int, start:Int, shape:Shape}
//a p s o 
typedef ObjectTransFormType {anchor:Dimension, pos:Dimension, scale:Dimension, rotation:Float, opacity:Dimension, px:ValueType, py:ValueType}
//ks
typedef Dimension = {animated:Bool, value:Array<Int>}
typedef DimensionKey = {animated:Bool, value:Array<OfffsetKeyFrame>}
typedef OffsetKeyFrame = {}
typedef ValueType = {animated:Bool, modifier:String, index:String,animated:Bool}
//a k x ix ti to
typedef KeyFrame = {animated:Bool, keyframe:Array<KeyFrameProp>,exp:String,index:String,tangentIn:Array<Int>,tangentOut:Array<Int>}
//e s t i o nm
typedef KeyFrameProp = {end:Array<ShapeProp>, start:Array<ShapeProp>, time:Int, curveIn:Array<Point>, curveOut:Array<Point>, name:Int}
//c i o v
typedef ShapeProp = {closed:Bool,curveIn:Array<Point>,curveOut:Array<Point>,curveVertices:Array<Point>}*/
//"shapes":[{"ty":"gr","it":[{"ind":0,"ty":"sh","ks":{"a":0,"k":{"i":[[0,0],[0,0],[0,0]],"o":[[0,0],[0,0],[0,0]],"v":[[-167.614,16.761],[-68.75,116.193],[167.614,-116.193]],"c":false}},"nm":"Trazado 1","mn":"ADBE Vector Shape - Group"},{"ty":"tm","s":{"a":1,"k":[{"i":{"x":[0.667],"y":[1]},"o":{"x":[0.333],"y":[0]},"n":["0p667_1_0p333_0"],"t":0,"s":[0],"e":[100]},{"t":24}],"ix":1},"e":{"a":0,"k":0,"ix":2},"o":{"a":0,"k":0,"ix":3},"m":1,"ix":2,"nm":"Recortar trazados 1","mn":"ADBE Vector Filter - Trim"},{"ty":"st","c":{"a":0,"k":[0.3,0.91,0.02,1]},"o":{"a":0,"k":100},"w":{"a":0,"k":42},"lc":1,"lj":1,"ml":10,"nm":"Trazo 1","mn":"ADBE Vector Graphic - Stroke"},{"ty":"tr","p":{"a":0,"k":[253.614,247.648],"ix":2},"a":{"a":0,"k":[0,0],"ix":1},"s":{"a":0,"k":[100,100],"ix":3},"r":{"a":0,"k":0,"ix":6},"o":{"a":0,"k":100,"ix":7},"sk":{"a":0,"k":0,"ix":4},"sa":{"a":0,"k":0,"ix":5},"nm":"Transformar"}],"nm":"Grupo 1","np":3,"mn":"ADBE Vector Group"}],"ip":0,"op":66,"st":0,"bm":0,"sr":1}]