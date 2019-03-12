package lottie;

import openfl.display.GradientType;
import json.helpers.Transform;
import json.Animation;
import haxe.Json;
import openfl.display.CapsStyle;
import openfl.display.JointStyle;

class Lottie
{
    public var frameRate:Int = 0;
    public var grouped:Bool = false;
    public var map:Map<String,Controller> = new Map<String,Controller>();

    public function new(string:String)
    {
        var data:Animation = Json.parse(string);
        trace("inital");
        parseAnimation(data);
    }
    public function parseAnimation(data:Animation)
    {
        //render
        //setStage(data.w,data.h);
        parseLayers(data.layers);
    }
    public function parseLayers(array:Array<Dynamic>)
    {
        for (layer in array)
        {
            switch(layer.ty)
            {
                case 0:
                //precomp
                trace("precomp'");
                case 1:
                //solid
                trace("solid");
                case 2:
                //image
                trace("image");
                case 3:
                //null
                trace("null");
                case 4:
                //shape
                parseLayerShape(layer);
                case 5:
                //text

            }
        }
    }
    public function parseLayerShape(obj:Dynamic)
    {
        var controller = new Controller();
        controller.create();
        map.set(obj.nm,controller);
        var data:json.layers.Shape = obj;
        //points
        parsePoints(obj,controller);
        //transform
        parseTransform(data.ks,controller);
        //shape
        var shapeArray:Array<Dynamic> = obj.shapes;
        for (shape in shapeArray) parseShapes(shape.it,controller);

        var iterate = Reflect.copy(map.iterator());
        while(iterate.hasNext())
        {
            var controller = iterate.next();
            openfl.Lib.current.addChildAt(controller.child,0);
            controller.resetTransform();
        }
    }
    public function parseShapes(arrayDynamic:Dynamic,controller:Controller)
    {
        var array:Array<Dynamic> = arrayDynamic;
        if(array == null)return;
        //trace("array " + array);
        for(obj in array)
        {
            trace("ty " + obj.ty);
            switch(obj.ty)
		    {
			    case "sh":
			    //shape
			    controller.drawArray.unshift({type:0,data:{vert:obj.ks}});
			    case "rc":
			    //rect
                var control = new Controller();
                control.create();
                control.setPos(parsePos(obj.p));
                control.setSize(parseDimension(obj.s));
                control.setRotation(parseValue(obj.r));
                //control.grouped = true;
                controller.child.addChild(control.child);
                control.drawArray.unshift({type:1,data:{}});
                map.set(obj.nm,control);
                case "el":
			    //ellipse
                trace("data el " + obj);
                var control = new Controller();
                control.create();
                control.setPos(parsePos(obj.p));
                control.setSize(parseDimension(obj.s));
                //control.grouped = true;
                controller.child.addChild(control.child);
                control.drawArray.unshift({type:2,data:{}});
                map.set(obj.nm,control);
			    case "sr":
			    //star

			    case "fl":
			    //fill
                trace("obj " + obj);
                if(obj.c.a == 1)
                {

                }else{
                    controller.drawArray.unshift({type:4,
                    data:{
                    color:getPercentRGB(obj.c.k[0],obj.c.k[1],obj.c.k[2]),
                    alpha:1
                    }});
                }
			    case "gf":
			    //gFill
                var dataArray:Array<Float> = obj.g.k.k;
                var colorArray:Array<UInt> = [];
                var ratioArray:Array<Int> = [];
                var alphaArray:Array<Float> = [];
                var alpha:Float = 1;
                for(i in 0...Math.floor(dataArray.length/4))
                {
                    ratioArray.push(Math.floor(dataArray[i] * 255));
                    colorArray.push(getPercentRGB(dataArray[i + 1],dataArray[i + 2],dataArray[i + 3]));
                    alphaArray.push(alpha);
                }
                trace("obj " + obj);
                controller.drawArray.unshift({type:5,
                data:{
                color:colorArray,
                ratio:ratioArray, 
                type: obj.t == 1 ? GradientType.LINEAR : GradientType.RADIAL,
                alpha: alphaArray,
                }});
			    case "gs":
			    //gStroke

			    case "st":
			    //stroke
                var color = getPercentRGB(obj.c.k[0], obj.c.k[1], obj.c.k[2]);
		        var opacity = obj.o.k / 100;
		        var stroke = obj.w.k;

		        var cap:CapsStyle = obj.lc;
		        if (obj.lc == 1) cap = CapsStyle.SQUARE;
		        if (obj.lc == 0) cap = CapsStyle.ROUND;
		        var join:JointStyle = obj.lj;
		        var miter:Int = obj.ml;
                controller.drawArray.unshift({type:7,
                data:{
                color:color,
                alpha:opacity,
                stroke:stroke,
                cap:cap,
                join:join,
                miter:miter
                }});
			    case "mm":
			    //merge
			
			    case "tm":
			    //trim
			
			    case "gr":
			    //group
                trace("group");

                case "tr":
                trace("transform " + obj);
		    }
        }
    }
    //when layer/item pops into and then out of existance
    public function parsePoints(obj:Dynamic,controller:Controller)
    {
        if(obj.ip != null) controller.inPoint = Math.floor(obj.ip);
        if(obj.op != null) controller.outPoint = Math.floor(obj.op);
    }
    public function parseTransform(obj:Dynamic,controller:Controller)
    {
        var data:Transform = obj;
        //trace("anchor");
        if(data.a != null)  controller.setAnchor(parseDimension(data.a));
        //trace("pos");
        if (data.p != null) controller.setPos(parsePos(data.p));
        //trace("scale");
        if (data.s != null) controller.setScale(parseDimension(data.s));
        //trace("rotation");
        if (data.r != null) controller.setRotation(parseValue(data.r));
        //trace("opacity");
        if (data.o != null) controller.setOpacity(parseValue(data.o));
        //trace("x");
        if (data.px != null) controller.setPosX(parseValue(data.px));
        //trace("y");
        if (data.py != null) controller.setPosY(parseValue(data.py));
        //not implemented: pz, sk, sa
    }
    public function parseValue(obj:Dynamic):Dynamic
    {
        if(obj.a)
        {
            //animated
            var data:json.properties.ValueKeyframed = obj;
            for(frame in data.k)
            {
                //trace("frame " + frame);
            }
            return {value:0,array:[]};
        }else{
            //not animated
            var data:json.properties.Value = obj;
            trace("data rotation " + data);
            return {value:obj.k,array:[]};
        }
    }
    public function parsePos(obj:Dynamic):Dynamic
    {
        //{ s => true, x => { a => 0, k => 320.6 }, y => { a => 0, k => 74.151 } }
        //trace("parse pos " + obj);
        //trace("obj " + obj);
        trace("a " + obj.a);
        if(obj.a == 1)
        {
            return {x:0,y:0};
        }else{
            if(obj.k != null)
            {
                return {x:obj.k[0],y:obj.k[1]};
            }else{
                return {x:obj.x.k,y:obj.y.k};
            }
        }
    }
    public function parseDimension(obj:Dynamic):Dynamic
    {
        //trace("Dim " + obj);
        if(obj.a != 1)
        {
            //not animated
            var data:json.properties.MultiDimensional;
            return {array:obj.k};
        }else{
            //animated
            var data:json.properties.MultiDimensionalKeyframed;
            return {array:[]};

        }
    }

    public static function getPercentRGB(r:Float, g:Float, b:Float):UInt
	{
		return getRGB(Math.floor(r * 255), Math.floor(g * 255), Math.floor(b * 255));
	}
	public static function getRGB(r:Int, g:Int, b:Int):UInt
	{
		var int:Int = r;
		int = (int << 8) + g;
		int = (int << 8) + b;
		return int;
	}
}