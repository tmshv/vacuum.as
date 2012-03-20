package ru.gotoandstop.nodes.links {
import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.vacuum.Layout;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.view.RectIcon;
import ru.gotoandstop.vacuum.view.VertexIcon;
import ru.gotoandstop.vacuum.view.VertexView;

/**
 * @author tmshv
 */
public class PortPoint extends VertexView implements IPort {
    public var node:INode;
    public var property:String;
    private var _type:String;
    public function get type():String {
        return _type;
    }

    private var _direction:String;
    public function get direction():String {
        return this._direction;
    }

    public function set direction(value:String):void {
        this._direction = value;
    }

    public function PortPoint(vertex:IVertex, layout:Layout, node:INode, property:String, type:String, direction:String) {
        this.property = property;
        this._type = type;
        this.direction = direction;

        var icon:VertexIcon;
        if (this.type == 'in') {
            icon = new RectIcon(0xff000000, 0xffffffff);
        } else {
            icon = new RectIcon(0xff000000, 0xff000000);
        }

        super(vertex, layout, icon);
        this.node = node;
    }

    public function getValue():* {
        if (node) {
            try{
                var value:* = node[property];
                return value;
            }catch(error:Error){
                return node.getKeyValue(property);
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
    }

    public function unlock():void {
    }

    public function get isLocked():Boolean {
        return false;
    }

    public function get dataType():String {
        return "";
    }
}
}