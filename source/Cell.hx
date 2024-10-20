
import flixel.FlxG;
import flixel.util.FlxColor;

class Cell {
    private var selected: Bool = false;
    private var beingSelectedDuringDrag: Bool = false;
    private var invalid: Bool = false;
    private var color:FlxColor = FlxColor.WHITE;
    private var tint:Float = 1.0;
    public var belongsToRegion: Int = 0;
    
    public function new() {
        
    }

    public function setSelected():Void {
        selected = !selected;
    }

    public function setSelectedWithValue(bool:Bool): Void {
        selected = bool;
    }

    public function isSelected():Bool {
        return selected;
    }

    public function setColor(newColor:FlxColor):Void
    {
        color = newColor;
    }

    public function getColor():FlxColor {
        return color;
    }

    public function setTint(tint:Float):Void
    {
        this.tint = tint;
    }

    public function getTint():Float
    {
        return tint;
    }

    public function setBeingSelectedDuringDrag(bool: Bool) {
        beingSelectedDuringDrag = bool;
    }

    public function isBeingSelectedDuringDrag(): Bool {
        return beingSelectedDuringDrag;
    }

    public function setInvalid(bool: Bool) {
        invalid = bool;
    }

    public function isInvalid(): Bool {
        return invalid;
    }
}