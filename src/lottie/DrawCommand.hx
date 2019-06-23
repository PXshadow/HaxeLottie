package lottie;

enum DrawCommand 
{
    Fill(color:UInt,alpha:Float);
    GradientFill(type:Int,color:Array<UInt>,alpha:Array<Float>,ratio:Array<Int>);
    Stroke(cap:Int,joint:Int,miter:Int,color:UInt,alpha:Float);
    Vert(i:Array<Float>,o:Array<Float>,v:Array<Float>,c:Bool);
}