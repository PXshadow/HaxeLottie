package;
import openfl.display.GradientType;
import openfl.display.Graphics;
import openfl.events.MouseEvent;
import lottie.DrawCommand;
import lottie.Lottie.LottieType;
import openfl.Assets;
import openfl.display.Sprite;

/**
 * ...
 * @author 
 */
class Main extends Sprite 
{

	public function new() 
	{
		super();
		mouseEnabled = true;
		buttonMode = true;
		//drag test
		addEventListener(MouseEvent.MOUSE_DOWN,function(_)
		{
			startDrag();
		});
		addEventListener(MouseEvent.MOUSE_UP,function(_)
		{
			stopDrag();
		});
		//var animation = new Lottie("assets/vote.json");
		//var anim = new Animation();
		//JsonClass.start("assets/docs/json/animation.json");
		//JsonClass.start("assets/docs/json/shapes/shape.json");
		
		Assets.loadText("assets/vote.json").onComplete(function(string:String)
		{
			var lottie = new lottie.Lottie(string,function(data:LottieType)
			{
				for(i in 0...data.draw.length)
				{
					var sprite = new Sprite();
					sprite.mouseEnabled = false;
					//sprite.buttonMode = true;
					//sprite.cacheAsBitmap = true;
					addChild(sprite);
					for(draw in data.draw[i])
					{
						switch(draw.getName())
						{
							case "Vert":
							var param = draw.getParameters();
							//sprite.graphics.beginFill(0xFFFFFF,0.5);
							renderVert({i:param[0],o:param[1],v:param[2],c:param[3]},sprite.graphics);
							case "GradientFill":
							var mat = new openfl.geom.Matrix();
							var param = draw.getParameters();
							sprite.graphics.beginGradientFill(
								param[0] == 0 ? LINEAR : RADIAL,
								param[1],
								param[2],
								param[3],
								mat
							);
							case "Fill":
							trace("fill");
							var param = draw.getParameters();
							sprite.graphics.beginFill(param[0],param[1]);
							
						}
					}
				}
			});
		});
	}

	private function renderVert(v:Dynamic,graphics:Graphics)
	{
        if(v == null) return;
        if (v.i == null) return;
		trace("render vert");
        var length:Int = v.i.length;
        var vertex = addPoint({x:0,y:0});
        var prevVertex = addPoint({x:0,y:0});
        var cp1 = addPoint({x:0,y:0});
        var cp2 = addPoint({x:0,y:0});
        var closed:Bool = v.c;
        var inital = addPoint({x:v.v[0][0],y:v.v[0][1]});
        graphics.moveTo(inital.x,inital.y);
		for (x in 1...length)
		{
            prevVertex = addPoint({x:v.v[x - 1][0],y:v.v[x - 1][1]});
            vertex = addPoint({x:v.v[x][0],y:v.v[x][1]});
            cp1 = addPoint(prevVertex,{x:v.o[x - 1][0],y:v.o[x - 1][1]});
            cp2 = addPoint(vertex,{x:v.i[x][0],y:v.i[x][1]});
            if(cp1 == inital && cp2 == vertex)
            {
                graphics.lineTo(vertex.x,vertex.y);
                continue;
            }
            graphics.cubicCurveTo(cp1.x,cp1.y,cp2.x,cp2.y,vertex.x,vertex.y);
		}
        
        if(closed)
        {
            vertex = inital;
            var x:Int = length;
            prevVertex = addPoint({x:v.v[x - 1][0],y:v.v[x - 1][1]});
            cp1 = addPoint(prevVertex,{x:v.o[x - 1][0],y:v.o[x - 1][1]});
            cp2 = addPoint(vertex,{x:v.i[0][0],y:v.i[0][1]});
            graphics.cubicCurveTo(cp1.x,cp1.y,cp2.x,cp2.y,vertex.x,vertex.y);
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

}
