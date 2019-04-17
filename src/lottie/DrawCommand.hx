package lottie;

enum DrawCommand 
{
    Fill(color:UInt,alpha:Float);
    GradientFill(color:Array<UInt>,ratio:Array<Int>,alpha:Array<Float>,type:Int);
    Stroke(cap:Int,joint:Int,miter:Int,color:UInt,alpha:Float);
    Vert(i:Array<Float>,o:Array<Float>,v:Array<Float>,c:Bool);
}