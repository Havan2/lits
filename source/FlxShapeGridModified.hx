package;

import flixel.FlxG;
import flixel.addons.display.shapes.FlxShapeGrid;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.geom.Matrix;

class FlxShapeGridModified extends FlxShapeGrid {

    public var cells:Array<Array<Cell>>;

    /**
     * Creates a FlxSprite with a grid drawn on top of it, and associates a logical grid of Cell objects.
     * @param X X position of the sprite.
     * @param Y Y position of the sprite.
     * @param CellWidth Width of each cell.
     * @param CellHeight Height of each cell.
     * @param CellsWide Number of cells horizontally.
     * @param CellsTall Number of cells vertically.
     * @param LineStyle_ The line style for the grid.
     * @param FillColor The fill color for the entire grid.
     */
    public function new(X:Float, Y:Float, CellWidth:Float, CellHeight:Float, CellsWide:Int, CellsTall:Int, LineStyle_:LineStyle, FillColor:FlxColor) {
        super(X, Y, CellWidth, CellHeight, CellsWide, CellsTall, LineStyle_, FillColor);

        // Initialize the grid with Cell objects
        cells = [];
        for (i in 0...cellsTall) {
            var row:Array<Cell> = [];
            for (j in 0...cellsWide) {
                row.push(new Cell());
            }
            cells.push(row);
        }
    }

    // Set a Cell to selected/deselected
    public function modifyCell(row:Int, col:Int):Void {
        if (col < 0 || col >= cellsWide || row < 0 || row >= cellsTall) {
            trace("Cell index out of bounds.");
            return;
        }

        // Update the logical state of the cell
        cells[row][col].setSelected();
        shapeDirty = true;
    }
    public function modifyCellColor(row:Int, col:Int, color:FlxColor):Void {
        if (col < 0 || col >= cellsWide || row < 0 || row >= cellsTall) {
        trace("Cell index out of bounds.");
        return;
        }   

        // Set the color of the cell using the color property we just added
        cells[row][col].setColor(color);
        shapeDirty = true;
    }

    public function modifyTint(row:Int, col:Int, intensity:Float):Void
    {
        if (col < 0 || col >= cellsWide || row < 0 || row >= cellsWide)
        {
            trace("Cell index out of bounds.");
            return;
        }

        cells[row][col].setTint(intensity);
        shapeDirty = true;
    } 

    public function getCellState(row:Int, col:Int):Bool {
        if (col < 0 || col >= cellsWide || row < 0 || row >= cellsTall) {
            trace("Cell index out of bounds");
            return false;
        }
        return cells[row][col].isSelected();
    }

    /**
     * Draws the entire grid, colouring each cell.
     * Will need to be updates to colour cells according to which region they are.
     */
     override public function drawSpecificShape(?matrix:Matrix):Void {
        var ox:Float = (lineStyle.thickness / 2);
        var oy:Float = (lineStyle.thickness / 2);

        // Iterate over the entire grid and colour each cell
        for (ih in 0...cellsTall) {
            for (iw in 0...cellsWide) {
                // Choose color based on whether the cell is selected
                var fillColor:FlxColor = cells[ih][iw].getColor();
                var intensity = cells[ih][iw].getTint();
                var tintedColor:FlxColor = multiplyAlpha(fillColor, intensity);

                // if (cells[ih][iw].isSelected())
                // {
                //  tintedColor = darken(tintedColor);
                // }
                
                // Calculate the position of the specific cell
                var x:Float = ox + (cellWidth * iw);
                var y:Float = oy + (cellHeight * ih);

                // Draw the rectangle for the specific cell
                FlxSpriteUtil.drawRect(this, x, y, cellWidth, cellHeight, tintedColor);
            }
        }

        // Draw the grid lines
        for (iw in 0...cellsWide + 1)
            FlxSpriteUtil.drawLine(this, ox + (cellWidth * iw), oy, ox + (cellWidth * iw), oy + shapeHeight, lineStyle);

        for (ih in 0...cellsTall + 1)
            FlxSpriteUtil.drawLine(this, ox, oy + (cellHeight * ih), ox + shapeWidth, oy + (cellHeight * ih), lineStyle);
    }
    // Change the tint
    public static function multiplyAlpha(color:FlxColor, factor:Float):FlxColor
    {
        var red:Int = color.red;
        var green:Int = color.green;
        var blue:Int = color.blue;
        var alpha:Int = color.alpha;

        var newAlpha:Int = Math.round(alpha * factor);

        // Return a new color with the adjusted alpha
        return FlxColor.fromRGB(red, green, blue, newAlpha);
    }

    // public static function darken(color:FlxColor):FlxColor
    // {
    //  var factor = 0.5;
    //  // Reduce each color component by the factor
    //  var red:Int = Math.round(color.red * factor);
    //  var green:Int = Math.round(color.green * factor);
    //  var blue:Int = Math.round(color.blue * factor);
    //  return FlxColor.fromRGB(red, green, blue, color.alpha);
    // }

    public function setCellSelectedDuringDrag(row: Int, col: Int, bool:Bool): Void {
        cells[row][col].setBeingSelectedDuringDrag(bool);
    }
    
    public function getCellBeingSelectedDuringDrag(row: Int, col: Int): Bool {
        return cells[row][col].isBeingSelectedDuringDrag();
    }

    public function setCellInvalid(row: Int, col: Int, bool: Bool): Void {
        cells[row][col].setInvalid(bool);
    }

    public function getCellInvalid(row: Int, col: Int): Bool {
        return cells[row][col].isInvalid();
    }
}

