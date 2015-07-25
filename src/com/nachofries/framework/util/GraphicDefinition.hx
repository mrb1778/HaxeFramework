package com.nachofries.framework.util;
import com.nachofries.framework.util.Placement.Placeable;
typedef GraphicDefinition = {
    > Placeable,
    ?image:String,
    ?duplicates:Int,
    ?behavior:Dynamic,
    ?duplicateProperties:Dynamic,

    ?x:Float,
    ?y:Float,
    ?fill: String,
    ?width: Float,
    ?height: Float
}