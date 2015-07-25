package com.nachofries.framework.lifecycle;

class LifecycleEvent {
    public static inline var PAUSE:String = "lifecycle.pause";
    public static inline var CHANGE_STATE:String = "lifecycle.state";
    public static inline var BACK:String = "lifecycle.back";
    public static inline var NEXT:String = "lifecycle.next";
    public static inline var RESTART:String = "lifecycle.restart";
    public static inline var SHOW_DIALOG = "show.dialog";
    public static inline var ON_DIALOG_SHOW = "on.dialog.show";
    public static inline var ON_DIALOG_HIDE = "on.dialog.hide";
}
