package com.nachofries.framework.util;
import haxe.macro.Context;
import haxe.macro.Expr.ExprOf;
class ClassInfo {
    macro static public function getClassName():ExprOf<String> {
        return { expr: EConst(CString(Context.getLocalClass().toString())), pos: Context.currentPos() }
    }
}
