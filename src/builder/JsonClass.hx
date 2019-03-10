package;
import haxe.Json;
import lime.system.System;
import openfl.Assets;
import openfl.Lib;
import sys.io.File;
class JsonClass 
{
	private static var path:String;
	private static var name:String = "";
	private static var docDir:String = "";
	private static var systemPath:String = "";
	private static var backslash = "\\".substring(0, 1);
	private static var history:Array<String> = [];
	public static function start(main:String)
	{
		if (history.indexOf(main) >= 0) return;
		history.push(main);
		name = main.substring(main.lastIndexOf("/") + 1, main.lastIndexOf("."));
		if(docDir == "")docDir = main.substring(0, main.lastIndexOf("/"));
		path = StringTools.replace(main.substring(0, main.lastIndexOf("/") + 1), "/", backslash);
		try {
		parse(Json.parse(Assets.getText(main)));
		}catch (e:Dynamic)
		{
			trace("eeeeeeee " + e);
		}
	}
	public static function parse(data:Dynamic)
	{
		name = name.substring(0, 1).toUpperCase() + name.substring(1, name.length);
		var importArray:Array<String> = [];
		var varArray:Array<String> = [];
		if (data.type == "object")
		{
			for (field in Reflect.fields(data.properties))
			{
				var varData:Dynamic = Reflect.field(data.properties, field);
				varArray.push("	" + "/**");
				if (varData.title != null) varArray.push("	*" + varData.title);
				if (varData.extended_name) varArray.push("	*" + varData.extended_name);
				if (varData.description) varArray.push("	*" + varData.description);
				varArray.push("	" + "**/");
				switch(varData.type)
				{
					case "number":
					//number
					varArray.push("	public var " + field + ":Float = 0;");
					case "string":
					//string
					varArray.push("	public var " + field + ":String = '';");
					case "object":
					//object
					varArray.push("	public var " + field + ":Dynamic = null;");
					if (varData.properties != null)
					{
						if (varData.properties.items != null) propertyParse(varData.properties.items);
					}else{
						if (varData.oneOf != null) itemsParse(varData.oneOf);
						if (varData.items != null) if(varData.items.oneOf != null)itemsParse(varData.items.oneOf);
					}
					case "array":
					varArray.push("	public var " + field + ":Array<Dynamic> = [];");
					if (varData.items != null) if(varData.items.oneOf != null) itemsParse(varData.items.oneOf);
				}
			}
		}
		var output:String = "";
		var path:String = System.applicationDirectory + path + name + ".hx";
		var lineArray:Array<String> = [];
		lineArray = ["package;"];
		lineArray = lineArray.concat(importArray);
		lineArray.push("class " + name);
		lineArray.push("{");
		lineArray.push("	public function new()");
		lineArray.push("	{");
		//lineArray.push("		super();");
		lineArray.push("	}");
		
		lineArray = lineArray.concat(varArray);
		lineArray.push("}");
		for (line in lineArray) output += line + "\n";
		File.saveContent(path, output);
	}
	private static function propertyParse(items:Array<Dynamic>)
	{
		for (item in items)
		{
			if (item.oneOf != null)
			{
				itemsParse(item.oneOf);
				return;
			}
			if (item.properties != null)
			{
				propertyParse(item.properties);
			}
		}
	}
	private static function itemsParse(items:Array<Dynamic>)
	{
		trace("items " + items);
		for (item in items)
		{
			//[{ standsFor => Star, value => 1 },{ standsFor => Polygon, value => 2 }]
			if (Reflect.field(item, "$ref") != null)
			{
				trace("path " + path);
				var path:String = Reflect.field(item, "$ref");
				path = path.substring(1, path.length);
				start(docDir + path + ".json");
			}
		}
	}
	
}