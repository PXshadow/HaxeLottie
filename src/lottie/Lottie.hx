package lottie;

import motion.Actuate;
import lottie.Controller.TransformPoint;
import json.properties.MultiDimensional;
import json.properties.MultiDimensionalKeyframed;
import lottie.Controller.TransformType;
import json.helpers.Transform;
import json.Animation;
import haxe.Json;
class Lottie
{
    private static var frameRate:Int = 60;
    public var grouped:Bool = false;
    public var map:Map<String,Controller> = new Map<String,Controller>();
    private var setX:Int = 0;
    private var setY:Int = 0;
    private var finish:LottieType->Void;
    private var lottie:LottieType;
    private var index:Int = -1;

    public function new(data:String,finish:LottieType->Void)
    {
        this.finish = finish;
        lottie = {draw:[],animation:[],fps:60};
        var data:Animation = Json.parse(data);
        trace("inital");
        parseAnimation(data);
    }
    public function parseAnimation(data:Animation)
    {
        //render
        //setStage(data.w,data.h);
        parseLayers(data.layers);
        trace("index " + index);
        finish(lottie);
    }
    public function parseLayers(array:Array<Dynamic>)
    {
        for (layer in array)
        {
            trace("layer");
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
        /*var controller = new Controller();
        controller.create();
        map.set(obj.nm,controller);*/
        index ++;
        var data:json.layers.Shape = obj;
        //points
        parsePoints(obj);
        //transform
        //controller.transform = parseTransform(data.ks,lottie.draw.length);
        //shape
        var shapeArray:Array<Dynamic> = obj.shapes;
        for (shape in shapeArray) 
        {
            parseShapes(shape.it);
        }
    }
    public function parseShapes(arrayDynamic:Dynamic)
    {
        var array:Array<Dynamic> = arrayDynamic;
        if(array == null)return;
        //trace("array " + array);
        lottie.draw[index] = [];
        for(obj in array)
        {
            //trace("ty " + obj.ty);
            switch(obj.ty)
		    {
			    case "sh":
			    //shape
                //trace("ks " + obj.ks);
                lottie.draw[index].unshift(DrawCommand.Vert(obj.ks.k.i,obj.ks.k.o,obj.ks.k.v,obj.ks.k.c));
			    //controller.drawArray.unshift({type:0,data:{vert:obj.ks}});
			    case "rc":
			    //rect
                //trace("rect");
                case "el":
			    //ellipse
                //trace("ellipse");
			    case "sr":
			    //star

			    case "fl":
			    //fill
                if(obj.c.a == 1)
                {

                }else{
                    /*controller.drawArray.unshift({type:4,
                    data:{
                    color:getPercentRGB(obj.c.k[0],obj.c.k[1],obj.c.k[2]),
                    alpha:1
                    }});*/
                }
			    case "gf":
			    //gFill
                var array:Array<Float> = obj.g.k.k;
                var color:Array<UInt> = [];
                var ratio:Array<Int> = [];
                var alpha:Array<Float> = [];
                for(i in 0...Std.int(array.length/4))
                {
                    ratio.push(Std.int(array[i] * 255));
                    color.push(getPercentRGB(array[i + 1],array[i + 2],array[i + 3]));
                    alpha.push(1);
                }
                lottie.draw[index].unshift(DrawCommand.GradientFill(color,ratio,alpha,obj.t));
			    case "gs":
			    //gStroke

			    case "st":
			    //stroke
                lottie.draw[index].unshift(
                    DrawCommand.Stroke(obj.lc,obj.lj,obj.ml,getPercentRGB(obj.c.k[0], obj.c.k[1], obj.c.k[2]),obj.o.k / 100)
                );
			    case "mm":
			    //merge
			
			    case "tm":
			    //trim
			
			    case "gr":
			    //group
                //trace("group " + obj);
                //var controller = new Controller();
                index ++;
                trace("group");
                parseShapes(obj.it);
                case "tr":
                //trace("tr");
                parseTransform(obj);
		    }
        }
    }
    //when layer/item pops into and then out of existance
    public function parsePoints(obj:Dynamic)
    {
        //if(obj.ip != null) controller.inPoint = Math.floor(obj.ip);
        //if(obj.op != null) controller.outPoint = Math.floor(obj.op);
    }
    public function parseTransform(obj:Dynamic):TransformType
    {
        var anchor:TransformPoint = {x:0,y:0,z:0};
        var scale:TransformPoint = {x:1,y:1,z:1};
        var pos:TransformPoint = {x:0,y:0,z:0};
        var data:Dynamic = obj.a;
        var alpha:Float = 1;
        if(data.a == 1)
        {
            //animated anchor

        }else{
            anchor = parseDimension(data);
            
        }
        data = obj.p;
        if(data.a == 1)
        {
            //animated pos
            trace("animated 1");
        }else{
            pos = parseDimension(data);
        }
        data = obj.s;
        if(data.a == 1)
        {
            //parseDimensionAnimation(data,controller,{scaleX:0,scaleY:0},0.01);
        }else{
            scale = point100(parseDimension(data));
        }
        data = obj.o;
        
        if(data.a == 1)
        {
            //animated opacity
            trace("animated 3");
        }else{
            alpha = parseValue(data)/100;
        }
        var trans:TransformType = {pos: pos,scale: scale,anchor: anchor,rotation: 0,alpha:alpha};
        return trans;
    }
    private static function parseDimensionAnimation(data:Dynamic,controller:Controller,property:Dynamic,multiply:Float=1)
    {
        //animated scale
        var frame:Array<json.properties.OffsetKeyframe> = data.k;
        trace("frame length " + frame.length);
        for(i in 0...frame.length - 1)
        {
            var delay = frame[i].t/frameRate;
            var scaleX:Float = frame[i].e[0]/100;
            var scaleY:Float = frame[i].e[1]/100;
            var duration:Float = (frame[i + 1].t - frame[i].t)/frameRate;
            //trace("scale " + scaleX + " y " + scaleY + " delay " + delay + " duration " + duration);
            var valueArray:Array<Float> = frame[i].e;
            var field:Array<String> = Reflect.fields(property);
            for(j in 0...valueArray.length)
            {
                if(field[j] != null)
                {
                    Reflect.setField(property,field[j],valueArray[j] * multiply);
                }
            }
            Reflect.copy(property);
            trace("prop " + property + " delay " + delay + " duration " + duration);
            controller.animationArray.push({delay:delay,duration:duration,property:Reflect.copy(property)});
        }
    }
    private static function point100(value:TransformPoint):TransformPoint
    {
        if(value.x != null) value.x /= 100;
        if (value.y != null) value.y /= 100;
        if (value.z != null) value.z /= 100;
        return value;
    }
    private static function parseValue(data:Dynamic):Float
    {
        return data.k;
    }
    private static function parseDimension(data:Dynamic):TransformPoint
    {
        if(data.k == null)
        {
            var pX:Float = 0;
            var pY:Float = 0;
            if(data.x != null)
            {
                if(data.x.a == 1)
                {
                    //animated x
                }else{
                    pX = data.x.k;
                }
            }
            if(data.y != null)
            {
                if(data.y.a == 1)
                {
                    //animated y
                }else{
                    pY = data.y.k;
                }
            }
            return {x:pX,y:pY,z:0};
        }else{
            return {x:data.k[0],y:data.k[1],z:data.k[2]};
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