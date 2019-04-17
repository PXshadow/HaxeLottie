package lottie;

import motion.Actuate;
import openfl.geom.Matrix;
import openfl.events.MouseEvent;
import openfl.display.LineScaleMode;
import openfl.display.Sprite;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.DisplayObject;
import openfl.display.CapsStyle;
import openfl.display.JointStyle;

class Controller
{
    public var child:Sprite;
    public var transform:TransformType;
    public var inPoint:Int = 0;
    public var outPoint:Int = 0;
    public var animationArray:Array<AnimationType> = [];
    public var drawArray:Array<DrawType> = [];
    public var setGradient:Dynamic = null;
    public var playing:Bool = false;
    public function new()
    {
        transform = {anchor: {x:0,y:0,z:0},scale: {x:1,y:1,z:1},pos: {x:0,y:0,z:0},rotation: 0,alpha:1};
    }
    public function create()
    {
        child = new Sprite();
        /*child.mouseEnabled = false;
        child.mouseChildren = false;
        child.buttonMode = false;*/
        child.buttonMode = true;

        child.addEventListener(MouseEvent.MOUSE_DOWN,function(_)
        {
            child.startDrag();
        });
        child.addEventListener(MouseEvent.MOUSE_UP,function(_)
        {
            child.stopDrag();
        });
        child.addEventListener(MouseEvent.MOUSE_WHEEL,function(e:MouseEvent)
        {
            child.scaleX += e.delta * 0.1;
            child.scaleY += e.delta * 0.1;
        });
        child.addEventListener(MouseEvent.CLICK,function(_)
        {
            animate();
        });

        child.cacheAsBitmap = true;
        child.graphics.beginFill(0xFFFFFF);
        child.graphics.drawRect(0,0,5,5);
        child.graphics.endFill();
    }
    public function play()
    {
        if(playing) return;
        playing = true;
        animate();
    }
    public function stop()
    {
        if (!playing) return;
        playing = false;

    }
    public function reset()
    {
        playing = false;
        scale();
        draw();
    }
    public function scale()
    {
        if(transform == null) return;
        child.scaleX = transform.scale.x;
        child.scaleY = transform.scale.y;
    }
    public function draw()
    {
        for(draw in drawArray)
        {
            command(draw);
        }
    }
    public function animate()
    {
        for(animation in animationArray)
        {
            //trace("animation " + animation);   
            if(animation.property.scaleX != null && animation.property.scaleY != null)
            {
                var scaleX:Float = animation.property.scaleX;
                var scaleY:Float = animation.property.scaleY;
                var shiftX:Float = -(child.width * scaleX - child.width)/2;
                var shiftY:Float = -(child.height * scaleY - child.height)/2;
                animation.property = {scaleX: scaleX,scaleY: scaleY,x:child.x + shiftX,y:child.y + shiftY};
            }
            motion.Actuate.tween(child,animation.duration,animation.property,false).delay(animation.delay).onComplete(function(_)
            {
                //trace("finish");
            });
        }
        //motion.Actuate.tween(child,1,{y:300}).delay(1);
    }
    public function command(draw:DrawType)
    {
        switch(draw.type)
        {
            case 0:
            //shape
			if(draw.data.vert.k != null)
            {
                //vert
                renderVert(draw.data.vert.k,child);
            }else{

            }
            case 1:
            //rect
            
            case 2:
            //ellipse

            case 3:
            //star

            case 4:
            //fill
            child.graphics.beginFill(draw.data.color,draw.data.alpha);
            case 5:
            //gFill
            var mat = new Matrix();
            mat.createGradientBox(100,100);
            child.graphics.beginGradientFill(draw.data.type,draw.data.color,draw.data.alpha,draw.data.ratio,mat);

            case 6:
            //gStroke

            case 7:
            //stroke
            child.graphics.lineStyle(
            draw.data.stroke,
            draw.data.color,
            draw.data.alpha,false,
            LineScaleMode.NORMAL,
            draw.data.cap,
            draw.data.join,
            draw.data.miter
            );
            case 8:
            //merge

            case 9:
            //trim

            case 10:
            //group

            case 11:
            //roundedCorners

            case 12:
            //repeater

        }
    }
    private function renderVert(v:Dynamic,shape:Sprite)
	{
        if(v == null) return;
        if (v.i == null) return;
        var length:Int = v.i.length;
        var vertex = addPoint({x:0,y:0});
        var prevVertex = addPoint({x:0,y:0});
        var cp1 = addPoint({x:0,y:0});
        var cp2 = addPoint({x:0,y:0});
        var closed:Bool = v.c;
        var inital = addPoint({x:v.v[0][0],y:v.v[0][1]});
        shape.graphics.moveTo(inital.x,inital.y);
		for (x in 1...length)
		{
            prevVertex = addPoint({x:v.v[x - 1][0],y:v.v[x - 1][1]});
            vertex = addPoint({x:v.v[x][0],y:v.v[x][1]});
            cp1 = addPoint(prevVertex,{x:v.o[x - 1][0],y:v.o[x - 1][1]});
            cp2 = addPoint(vertex,{x:v.i[x][0],y:v.i[x][1]});
            if(cp1 == inital && cp2 == vertex)
            {
                shape.graphics.lineTo(vertex.x,vertex.y);
                continue;
            }
            shape.graphics.cubicCurveTo(cp1.x,cp1.y,cp2.x,cp2.y,vertex.x,vertex.y);
		}
        
        if(closed)
        {
            vertex = inital;
            var x:Int = length;
            prevVertex = addPoint({x:v.v[x - 1][0],y:v.v[x - 1][1]});
            cp1 = addPoint(prevVertex,{x:v.o[x - 1][0],y:v.o[x - 1][1]});
            cp2 = addPoint(vertex,{x:v.i[0][0],y:v.i[0][1]});
            shape.graphics.cubicCurveTo(cp1.x,cp1.y,cp2.x,cp2.y,vertex.x,vertex.y);
        }

	}
    private function addPoint(p1:{x:Int,y:Int},p2:{x:Int,y:Int}=null)
    {
        if(p2 == null)
        {
            return {x:p1.x,y:p1.y};
        }else{
            return {x:p1.x + p2.x,y:p1.y + p2.y};
        }
    }
    private function interp(a:Float,b:Float,frac:Float)
    {
        return a + (b-a)*frac;
    }
}
typedef TransformType = {pos:TransformPoint,scale:TransformPoint,anchor:TransformPoint,rotation:Float,alpha:Float}
typedef TransformPoint = {x:Float,y:Float,z:Float}
typedef AnimationType = {delay:Float,duration:Float,property:Dynamic}
typedef DrawType = {type:Int,data:Dynamic}