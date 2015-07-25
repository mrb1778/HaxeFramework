package com.nachofries.framework.util;


/**
 * ...
 * @author Michael R. Bernstein
 */

class TemplateManager {
    private static var defaults:Dynamic;
    private static var templates:Map<String, Dynamic> = new Map<String, Dynamic>();

    public static inline function initialize():Void {
        loadDefaults();
        loadTemplates();
    }

    public static function setDefaults(defaults:Dynamic):Void {
        TemplateManager.defaults = defaults;
    }
    public static function loadDefaults(directory:String="levels", fileName:String="level-template"):Void {
        var json = Resources.loadJson(directory + "/" + fileName);
        if(json != null) {
            setDefaults(json);
        }
    }

    public static function populateLevel(level:Dynamic):Dynamic {
        return JsonUtils.extend(defaults, level);
    }

    public static function loadTemplates(directory:String="levels", fileName:String="templates"):Void {
        var json = Resources.loadJson(directory + "/" + fileName);
        if(json != null) {
            addTemplates(json.templates);
        }
    }

    public static function addTemplates(jsonTemplates:Array<Dynamic>):Void {
        if(jsonTemplates != null) {
            for (template in jsonTemplates) {
                addTemplate(template.templateName, extendTemplate(template));
            }
        }
    }
    public static inline function addTemplate(name:String, template:Dynamic):Dynamic {
        templates.set(name, template);
        return template;
    }

    public static inline function addTemplateFromExistingExtension(name:String, baseName:String, extensionName:String):Dynamic {
        var extensionTemplate:Dynamic = getTemplate(extensionName);
        #if debug
        if(extensionTemplate == null) {
            trace("unknown extend template extension:" + extensionName);
        }
        #end
        return addTemplateFromExtension(name, baseName, extensionTemplate);
    }

    public static inline function addTemplateFromExtension(name:String, baseName:String, extensionTemplate:Dynamic):Dynamic {
        var baseTemplate:Dynamic = getTemplate(baseName);
        #if debug
        if(baseTemplate == null) {
            trace("unknown extend template base:" + baseName);
        }
        #end
        return addTemplate(name, JsonUtils.extend(baseTemplate, extensionTemplate));
    }

    public static function extendTemplate(json:Dynamic, ?templateName:String, ?subTemplateName:String):Dynamic {
        if(templateName == null) {
            templateName = json.template;
        }
        if (templateName != null && templates.exists(templateName)) {
            json = extendFromTemplates(json, templateName);
        }
        json.extended = templateName;

        if(subTemplateName == null) {
            subTemplateName = json.subTemplate;
        }
        if(subTemplateName != null) {
            json = extendFromTemplates(json, subTemplateName);
            json.extendedSub = subTemplateName;
        }
        return json;
    }

    private static function extendFromTemplates(json:Dynamic, extendTemplate:String):Dynamic {
        if (extendTemplate != null && templates.exists(extendTemplate)) {
            json = JsonUtils.extend(templates.get(extendTemplate), json);
        }
        return json;
    }

    public static function getTemplate(templateName:String):Dynamic {
        return templates.get(templateName);
    }

    public static function hasTemplate(templateName:String):Bool {
        return templates.exists(templateName);
    }
}