package;
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
		
		Assets.loadText("assets/lottie2.json").onComplete(function(string:String)
		{
			var lottie = new lottie.Lottie(string);
		});
	}

}
