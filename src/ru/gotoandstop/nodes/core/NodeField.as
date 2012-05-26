/**
 * Created with IntelliJ IDEA.
 * User: tmshv
 * Date: 4/10/12
 * Time: 6:50 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.core {
import com.bit101.components.Label;
import com.bit101.components.Panel;

import flash.display.Sprite;


import ru.gotoandstop.nodes.links.PortPoint;
import ru.gotoandstop.nodes.validate.IInputValidator;

public class NodeField extends Panel {
    private static function getLabelText(pattern:String, options:Object):String {
        const pattr:RegExp = /%([\w\d]+)(\[([\d]*):([\d]*)\])?/gi;
        var msg:String = pattern;

        var last_index:uint = pattr.lastIndex;
        while(pattr.test(pattern)) {
            pattr.lastIndex = last_index;

            var m:Array = pattr.exec(pattern);
            var text:String = options[m[1]];
            var left:uint = m[3] ? parseInt(m[3]) : 0;
            var right:uint = m[4] ? parseInt(m[4]) : text.length;
            var add_dots:Boolean = right < text.length;
            text = text.substr(left, right);
            if(add_dots) text += "...";
            msg = msg.replace(m[0], text);

            last_index = pattr.lastIndex;
        }

//        for(var i:String in options){
//            var text:String = options[i];
//            var m:Array = pattr.exec(pattern);
//            var left:uint = m[3] ? parseInt(m[3]) : 0;
//            var right:uint = m[4] ? parseInt(m[4]) : text.length;
//            var add_dots:Boolean = right < text.length;
//            text = text.substr(left, right);
//            if(add_dots) text += "...";
//            msg = msg.replace(m[0], text);
//        }
        return msg;
    }

    private static const DEFAULT_DEFINITION:Object = {
        visible:true,
        access:"none",
        validator:"none",
        ui:"input",
        display:"%key: %value[:10]"
    };

    public var key:String;
    public var ui:String;
    public var display:String;

    public var access:String;
    public var index:uint;
    private var validator:IInputValidator;

    private var type:String;
    private var port:PortPoint;
    private var label:Label;
    private var def:Object;

    /**
     *
     * @param object
     * @param index
     */
    public function NodeField(key:String, object:Object, index:uint) {
        def = object ? merge(DEFAULT_DEFINITION, object, true) : DEFAULT_DEFINITION;

        for(var i:String in def) {
            try{
                this[i] = def[i];
            }catch(error:Error){

            }
        }

        this.index = index;
        super.shadow = false;
        super.color = 0x0000aa;
        super._background.alpha = 0.01;
        super.name = key;
        this.key = key;

        label = new Label();
        label.mouseEnabled = true;
        label.mouseChildren = true;
        label.doubleClickEnabled = true;
        super.addChild(label);
    }

    public function update(complexValue:Object):void{
        updateValue(complexValue.value);
        delete complexValue.value;

        for(var i:String in complexValue) {
            try{
                this[i] = complexValue[i];
            }catch(error:Error){

            }
        }
    }

    public function updateValue(value:Object):void {
        var txt:String = (value == undefined || value == null) ? '' : value.toString();
        label.text = getLabelText(display, {
            key:key,
            value:txt
        });
    }

    public function getPosition():int{
        return index * 15;//height;
    }

    private function merge(object1:Object, object2:Object, override:Boolean=false):Object {
        var result:Object = {};
        var i:String;
        for (i in object1) {
            result[i] = object1[i];
        }
        if(override) {
            for (i in object2) {
                result[i] = object2[i];
            }
        }else{
            for (i in object2) {
                if (result[i] == undefined) {
                    result[i] = object2[i];
                }
            }
        }
        return result;
    }
}
}
