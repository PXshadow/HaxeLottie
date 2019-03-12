package lottie;

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
    public function new()
    {
        transform = {x:0,y:0,scaleX:1,scaleY:1,rotation:0,anchorX:0,anchorY:0,width:-1,height:-1};
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

        child.cacheAsBitmap = true;
        child.graphics.beginFill(0xFFFFFF,1);
        child.graphics.drawRect(0,0,5,5);
        child.graphics.endFill();
    }
    public function resetTransform()
    {
        if(transform == null)return;
        child.graphics.beginFill(0,0);
        child.graphics.drawRect(0,0,transform.width,transform.height);
        child.x = transform.x;
        child.y = transform.y;
        draw(transform.anchorX,transform.anchorY);
        child.scaleX = transform.scaleX;
        child.scaleY = transform.scaleY;
        child.rotation = transform.rotation;
    }
    public function draw(anchorX:Float,anchorY:Float)
    {
        var i:Int = 0;
        for(draw in drawArray)
        {
            command(draw,i++);
        }
    }
    public function command(draw:DrawType,i:Int=0)
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
            child.graphics.beginFill(0xFF0000);
            if(transform.width >= 0 && transform.height >= 0) 
            {
                child.graphics.drawRect(0,0,transform.width,transform.height);
            }
            child.graphics.endFill();
            case 2:
            //ellipse
            child.graphics.beginFill(0xFF0000);
            if(transform.width >= 0 && transform.height >= 0)
            {
                child.graphics.drawEllipse(0,0,transform.width,transform.height);
            }
            case 3:
            //star

            case 4:
            //fill
            child.graphics.beginFill(draw.data.color,draw.data.alpha);
            case 5:
            //gFill
            var mat = new Matrix();
            mat.createGradientBox(transform.width,transform.height);
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
        var length:Int = v.i.length;
        var vertex = addPoint({x:v.v[0][0],y:v.v[0][1]});
        shape.graphics.moveTo(vertex.x,vertex.y);
		for (x in 1...length)
		{
            var prevVertex = addPoint({x:v.v[x - 1][0],y:v.v[x - 1][1]});
            vertex = addPoint({x:v.v[x][0],y:v.v[x][1]});
            var cp1 = addPoint(prevVertex,{x:v.o[x - 1][0],y:v.o[x - 1][1]});
            var cp2 = addPoint(vertex,{x:v.i[x][0],y:v.i[x][1]});
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
    public function addAnimation(delay:Float,duration:Float,startTime:Int,data:Dynamic)
    {
        animationArray.push({delay: delay,duration: duration,startTime: startTime,data: data});
    }
    public function setOpacity(data:Dynamic)
    {

    }
    public function setAnchor(data:Dynamic)
    {

    }
    public function setPos(data:Dynamic)
    {
        if(data.x == null)
        {
            transform.x = data.array[0];
            transform.y = data.array[1];
        }else{
            transform.x = data.x;
            transform.y = data.y;
        }
    }
    public function setSize(data:Dynamic)
    {
        transform.width = data.array[0];
        transform.height = data.array[1];
    }
    public function setRotation(data:Dynamic)
    {
        transform.rotation = data.value;
    }
    public function setScale(data:Dynamic)
    {
        //transform.scaleX = data.k[0];
        //transform.scaleY = data.k[1];
    }
    public function setPosX(data:Dynamic)
    {

    }
    public function setPosY(data:Dynamic)
    {

    }
}
typedef TransformType = {x:Float,y:Float,scaleX:Float,scaleY:Float,rotation:Float,anchorX:Float,anchorY:Float,width:Float,height:Float}
typedef AnimationType = {delay:Float,duration:Float,startTime:Int,data:Dynamic}
typedef DrawType = {type:Int,data:Dynamic}