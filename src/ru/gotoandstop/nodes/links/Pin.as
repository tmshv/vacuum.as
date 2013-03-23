package ru.gotoandstop.nodes.links {
import ru.gotoandstop.nodes.Triag45Icon;
import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.vacuum.Layout;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.view.RectIcon;
import ru.gotoandstop.vacuum.view.VertexIcon;
import ru.gotoandstop.vacuum.view.VertexView;

/**
 * @author tmshv
 */
public class Pin extends VertexView implements IPin {
    private var _node:INode;
    public function get node():INode {
        return _node;
    }

    private var _property:String;
    public function get property():String{
        return _property;
    }

    private var _type:String;
    public function get type():String {
        return _type;
    }

    private var _direction:String;
    public function get direction():String {
        return this._direction;
    }
    public function set direction(value:String):void {
        _direction = value;
    }

    private var _locked:Boolean;
    public function get isLocked():Boolean {
        return _locked;
    }

    public function Pin(vertex:IVertex, layout:Layout, node:INode, property:String, type:String, direction:String) {
        this.direction = direction;
        _property = property;
        _type = type;
        _node = node;

        var icon:VertexIcon = type == PinType.INPUT ? new RectIcon(0xffbbbbbb, 0xffffffff) : new Triag45Icon(0xffbbbbbb, 0xffffffff);
        super(vertex, layout, icon);
    }

    public function getValue():* {
        if (node) {
            try{
                var value:* = node[property];
                return value;
            }catch(error:Error){
                return node.get(property);
            }
        } else {
            return null;
        }
    }

    public function get target():IVertex {
        return null;
    }

    public function setTarget(vertex:IVertex):void {
    }

    public function lock():void {
        _locked = true;
    }

    public function unlock():void {
        _locked = false;
    }

    public function get dataType():String {
        return "";
    }

    override public function toString():String {
        var msg:String = "[pin type for property of node]";
        msg = msg.replace(/type/, type);
        msg = msg.replace(/property/, property);
        msg = msg.replace(/node/, node);
        return msg;
    }
}
}