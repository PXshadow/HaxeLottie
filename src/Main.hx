package;
import openfl.display.Graphics;
import openfl.events.MouseEvent;
import lottie.DrawCommand;
import lottie.LottieType;
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
					sprite.cacheAsBitmap = true;
					addChild(sprite);
					sprite.addEventListener(MouseEvent.MOUSE_DOWN,function(_)
					{
						sprite.startDrag();
					});
					sprite.addEventListener(MouseEvent.MOUSE_UP,function(_)
					{
						sprite.stopDrag();
					});
					for(draw in data.draw[i])
					{
						switch(draw.getName())
						{
							case "Vert":
							var params = draw.getParameters();
							//sprite.graphics.beginFill(0xFFFFFF,0.5);
							renderVert({i:params[0],o:params[1],v:params[2],c:params[3]},sprite.graphics);
							case "GradientFill":
							var mat = new openfl.geom.Matrix();
							
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
