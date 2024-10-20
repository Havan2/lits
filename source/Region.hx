package;

class Region {
    public var id:Int;
    public var cellsInRegion: Array<Cell>;
    public var numSelectedCells: Int = 0;
    public var shapeType:ShapeType = ShapeType.NoShape;
    public var regionsAdjacent: Array<Region>;
    public var complete: Bool;

    public function new(id:Int) {
        this.id = id;
        this.cellsInRegion = [];
        this.regionsAdjacent = [];
        complete = false;
    }

    // Reset the region's shape status
    public function resetRegion():Void {
        shapeType = null;
        numSelectedCells = 0;
        cellsInRegion = [];
    }

    // Check if this region is fully occupied by selected cells
    public function isFullyOccupied():Bool {
        return numSelectedCells == cellsInRegion.length;
    }

    // Add a cell to the region
    public function addCell(cell:Cell):Void {
        cellsInRegion.push(cell);
    }

    // Remove a cell from the region
    public function removeCell(cell:Cell):Void {
        cellsInRegion.remove(cell);
    }

}

    // more


    // more
