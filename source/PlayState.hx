package;

import Region.Region;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.ds.Map;
import haxe.ds.StringMap;

class PlayState extends FlxState
{
    var playButton: FlxButton;
	var grid:FlxShapeGridModified;
	var mousePosition:FlxPoint;
	var isDragging:Bool = false;
	var regionsInt:Array<Array<Int>>;
    var regions:Array<Region>;
    var invalidSelectionMessage: FlxText;
	var color:FlxColor;
    var musicToggleBool: Bool = false;
    
    var L_SHAPE_CONFIGURATIONS:Array<Array<FlxPoint>>;
    var I_SHAPE_CONFIGURATIONS:Array<Array<FlxPoint>>;
    var T_SHAPE_CONFIGURATIONS:Array<Array<FlxPoint>>;
    var S_SHAPE_CONFIGURATIONS:Array<Array<FlxPoint>>;
    
	override public function create()
	{
		super.create();

        L_SHAPE_CONFIGURATIONS = [
            // Original L
            [new FlxPoint(0,0), new FlxPoint(0,1), new FlxPoint(0,2), new FlxPoint(1,2)],
            // Rotate 90 degrees
            [new FlxPoint(0,0), new FlxPoint(1,0), new FlxPoint(2,0), new FlxPoint(2,1)],
            // Rotate 180 degrees
            [new FlxPoint(1,0), new FlxPoint(1,1), new FlxPoint(1,2), new FlxPoint(0,2)],
            // Rotate 270 degrees
            [new FlxPoint(0,1), new FlxPoint(1,1), new FlxPoint(2,1), new FlxPoint(0,0)],
            // Reflect over vertical axis
            [new FlxPoint(1,0), new FlxPoint(1,1), new FlxPoint(1,2), new FlxPoint(0,0)],
            // Reflect over horizontal axis
            [new FlxPoint(0,0), new FlxPoint(1,0), new FlxPoint(1,1), new FlxPoint(1,2)],
            // Rotate 90 and reflect
            [new FlxPoint(0,0), new FlxPoint(0,1), new FlxPoint(1,0), new FlxPoint(2,0)],
            // Rotate 270 and reflect
            [new FlxPoint(0,0), new FlxPoint(0,1), new FlxPoint(1,1), new FlxPoint(2,1)],
            // Missing?
            [new FlxPoint(0,0), new FlxPoint(0,1), new FlxPoint(0,1), new FlxPoint(1,0)],

        ];
        
        I_SHAPE_CONFIGURATIONS = [
            // Vertical I
            [new FlxPoint(0,0), new FlxPoint(0,1), new FlxPoint(0,2), new FlxPoint(0,3)],
            // Horizontal I
            [new FlxPoint(0,0), new FlxPoint(1,0), new FlxPoint(2,0), new FlxPoint(3,0)]
        ];
    
        // Adjusted T_SHAPE_CONFIGURATIONS without negative coordinates
        T_SHAPE_CONFIGURATIONS = [
            // Original T
            [new FlxPoint(0,1), new FlxPoint(1,1), new FlxPoint(2,1), new FlxPoint(1,0)],
            // Rotate 90 degrees
            [new FlxPoint(1,0), new FlxPoint(1,1), new FlxPoint(1,2), new FlxPoint(2,1)],
            // Rotate 180 degrees
            [new FlxPoint(1,1), new FlxPoint(0,1), new FlxPoint(2,1), new FlxPoint(1,2)],
            // Rotate 270 degrees
            [new FlxPoint(1,0), new FlxPoint(1,1), new FlxPoint(1,2), new FlxPoint(0,1)],
            // Reflect over vertical axis
            [new FlxPoint(0,1), new FlxPoint(1,1), new FlxPoint(2,1), new FlxPoint(1,2)],
            // Reflect over horizontal axis
            [new FlxPoint(1,1), new FlxPoint(0,0), new FlxPoint(1,0), new FlxPoint(2,0)],
            // Rotate 90 and reflect
            [new FlxPoint(1,1), new FlxPoint(0,0), new FlxPoint(0,1), new FlxPoint(0,2)],
            // Rotate 270 and reflect
            [new FlxPoint(1,1), new FlxPoint(2,0), new FlxPoint(2,1), new FlxPoint(2,2)]
        ];
    
        S_SHAPE_CONFIGURATIONS = [
            // Original S
            [new FlxPoint(1,0), new FlxPoint(2,0), new FlxPoint(0,1), new FlxPoint(1,1)],
            // Rotate 90 degrees
            [new FlxPoint(0,0), new FlxPoint(0,1), new FlxPoint(1,1), new FlxPoint(1,2)],
            // Reflect over vertical axis
            [new FlxPoint(0,0), new FlxPoint(1,0), new FlxPoint(1,1), new FlxPoint(2,1)],
            // Rotate 90 and reflect
            [new FlxPoint(1,0), new FlxPoint(1,1), new FlxPoint(0,1), new FlxPoint(0,2)]
        ];

        // Play background music
        FlxG.sound.playMusic(AssetPaths.SmoothJazz__ogg);
        FlxG.sound.music.volume = 0.5;

		var background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.gold_gradient__jpg);
		add(background);

        // Add the button to the bottom-right corner of the screen
        // var checkButton = new FlxButton(FlxG.width - 100, FlxG.height - 40, "Done", onCheckGridComplete);
        // add(checkButton);

        var resetButton = new FlxButton(FlxG.width - 100, FlxG.height - 40, "Reset", resetLevel);
        add(resetButton);

        var musicButton = new FlxButton(FlxG.width - 100, 40 - resetButton.height, "Mute", toggleMusic);
        add(musicButton);

        var ruleButton = new FlxButton(FlxG.width - 120 - resetButton.width, FlxG.height - 40, "Rules", onclickheadback);
        add(ruleButton);

        // Add a text object to display the result (Passed/Failed)
        var statusText = new FlxText(0, FlxG.height - 100, FlxG.width, ""); // Empty text at start
        statusText.setFormat(null, 24, 0xFFFFFF, "center");
        add(statusText);

		grid = new FlxShapeGridModified(0,0,60,60,6,6, {thickness: 2, color: FlxColor.BLACK}, FlxColor.BLUE);
		grid.screenCenter();
		add(grid);

        resetLevel();

        setCellColors();
        // Initialize the invalid selection message
        invalidSelectionMessage = new FlxText(0, 10, 400, "");
        invalidSelectionMessage.setFormat(null, 16, FlxColor.RED, "center");
        add(invalidSelectionMessage);
        invalidSelectionMessage.visible = false; // Start hidden
	}

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        // Calculate the mouse position relative to the grid
        mousePosition = new FlxPoint(FlxG.mouse.x - grid.x, FlxG.mouse.y - grid.y);

        // Initialize currentRow and currentCol with default values
        var currentRow:Int = -1;
        var currentCol:Int = -1;

        if (FlxG.mouse.justPressed)
        {
            isDragging = true;
        }

        if (FlxG.mouse.pressed && isDragging)
        {
            var mouseX:Float = FlxG.mouse.x;
            var mouseY:Float = FlxG.mouse.y;

            // If clicking within the grid
            if (mouseX >= grid.x && mouseX <= grid.x + grid.width &&
                mouseY >= grid.y && mouseY <= grid.y + grid.height) 
            {
                // Calculate row and column based on mouse position and grid's cell dimensions
                currentCol = Std.int((mouseX - grid.x) / grid.cellWidth);
                currentRow = Std.int((mouseY - grid.y) / grid.cellHeight);
            
                if (currentRow <= 5 && currentCol <= 5 && currentRow >= 0 && currentCol >= 0)
                { 
                    // trace("Row: " + currentRow + ", Col: " + currentCol);

                    // Check if the cell was already selected during this drag
                    if (!grid.getCellBeingSelectedDuringDrag(currentRow, currentCol)) {
                        // Set the tile as selected to avoid re-selecting it in this drag operation
                        grid.setCellSelectedDuringDrag(currentRow, currentCol, true);

                        // Toggle the selected state of the cell
                        grid.modifyCell(currentRow, currentCol);
            
                        FlxG.sound.play(AssetPaths.Casualtap__ogg); 

                        checkFor2x2Block();
                        checkRegionsForLetters();
                        checkForAdjacentSameShape();
                        setCellColors();
                        areAllRegionsComplete();
                        onCheckGridComplete();
                    }
                }
            }
        }

        if (FlxG.mouse.justReleased)
        {
            isDragging = false;
            resetTileSelection();
        }       
    }

    private function resetTileSelection():Void
    {
        for (row in 0...grid.cellsWide) {
            for (col in 0...grid.cellsTall) {
                grid.setCellSelectedDuringDrag(row, col, false);
            }
        }
    }

    public function setCellColors() {
        // Iterate through cells
        for (row in 0...grid.cellsWide) {
            for (col in 0...grid.cellsTall) {
                var cell = grid.cells[row][col];
                var color:FlxColor;
                
                // Color cell black if invalid and continue onto next cell
                if (cell.isInvalid()) {
                    grid.modifyCellColor(row, col, FlxColor.BLACK);
                    grid.modifyTint(row, col, 1.0);
                    continue;
                }
                
                // Match color depending on the cell's region
                switch(cell.belongsToRegion)
                {
                    case 1: color = FlxColor.RED;
                    case 2: color = FlxColor.GREEN;
                    case 3: color = FlxColor.BLUE;
                    case 4: color = FlxColor.YELLOW;
                    case 5: color = FlxColor.MAGENTA;
                    case 0: color = FlxColor.PURPLE;
                    default: color = FlxColor.WHITE; // should not happen
                }

                // Set cell's color
                grid.modifyCellColor(row, col, color);

                // Set cell's tint according to whether it is selected or not
                if (cell.isSelected()) {
                    grid.modifyTint(row, col, 1.0);
                } else {
                    grid.modifyTint(row, col, 0.2);
                }
            }
        }
	}
    
    public function checkFor2x2Block():Void 
    {
        for (row in 0...grid.cellsWide - 1) {
            for (col in 0...grid.cellsTall - 1) {
                if (grid.getCellState(row, col) &&
                    grid.getCellState(row + 1, col) &&
                    grid.getCellState(row, col + 1) &&
                    grid.getCellState(row + 1, col + 1)) {
                    // A 2x2 block is found
                    // trace("Invalid selection! 2x2 block detected at Row: " + row + ", Col: " + col);
                    set2x2CellsInvalid(row, col);

                    // Display message and continue playing
                    invalidSelectionMessage.text = "Invalid selection! 2x2 block detected. Keep playing.";
                    invalidSelectionMessage.visible = true;
                } 
            }
        }
            // Hide the message if no block is detected
        invalidSelectionMessage.visible = false;    
    }
    
    public function set2x2CellsInvalid(row:Int, col:Int):Void {
        grid.setCellInvalid(row, col, true);
        grid.setCellInvalid(row + 1, col, true);
        grid.setCellInvalid(row, col + 1, true);
        grid.setCellInvalid(row + 1, col + 1, true);
    }

    function getSelectedCellsInRegion(regionId:Int):Array<FlxPoint>
    {
        var selectedCells:Array<FlxPoint> = [];
    
        // Iterate through the entire regions grid
        for (row in 0...6)
        {
            for (col in 0...6)
            {
                // Check if the current cell belongs to the specified region
                var region:Region = regions[regionId];
                if (region.cellsInRegion.indexOf(grid.cells[row][col]) != -1)
                {
                    // Check if the cell is selected
                    if (grid.getCellState(row, col)) 
                    {
                        // Add the cell's coordinates (row, col) to the selectedCells array
                        selectedCells.push(new FlxPoint(row, col));
                    }
                }
            }
        }
    
        trace("Selected cells in region " + regionId + ": " + selectedCells.length);
    
        // Return the list of selected cells
        return selectedCells;
    }

    function checkRegionsForLetters():Void
    {
        for (regionId in 0...regions.length) {
            var region = regions[regionId];
            checkAdjacentRegionShapes(regionId);
    
            var selectedCells:Array<FlxPoint> = [];
        
            // Collect all selected cells in the region
            selectedCells = getSelectedCellsInRegion(regionId);
    
            // If more than 4 cells selected in a region, return false
            if (selectedCells.length > 4) {
                setRegionCellsInvalid(regionId);
                region.complete = false;
                return;
            }
    
            // If any of the cells are invalid, return false
            for (cell in regions[regionId].cellsInRegion) {
                if (cell.isInvalid()) {
                    region.complete = false;
                    return;
                }
            }
    
            trace(selectedCells);
        
            // Check if the selected cells form any of the letters L, I, T, or S
            if (isLShape(selectedCells)) {
                region.shapeType = ShapeType.L;
                region.complete = true;             
            } else if (isIShape(selectedCells)) {
                region.shapeType = ShapeType.I;
                region.complete = true;
            } else if (isTShape(selectedCells)) {
                region.shapeType = ShapeType.T;
                region.complete = true;
            } else if (isSShape(selectedCells)) {
                region.shapeType = ShapeType.S;
                region.complete = true;
            } else {
                region.shapeType = NoShape;
                region.complete = false;
            }
        }
        
    }

    public function setRegionCellsInvalid(regionId:Int) {
        var region = regions[regionId];

        for (cell in region.cellsInRegion) {
            if (cell.isSelected()) {
                cell.setInvalid(true);
            }    
        }
    }

    public function checkForAdjacentSameShape() {
        for (regionId in 0...6)
        {
            var region = regions[regionId];
            var shape = region.shapeType;

            for (adjacent in region.regionsAdjacent) {
                if (shape == adjacent.shapeType && shape != ShapeType.NoShape) {
                    if (areShapesTouching(region, adjacent)) {
                        setRegionCellsInvalid(regionId);
                    }
                }
            }
        }
    }

    function areAllRegionsComplete():Bool
    {
        // Iterate over all regions
        for (regionId in 0...6)
        {
            if (regions[regionId].complete == false)
            {
                trace("Region " + regionId + " is not complete.");
                return false;
            } else {
                trace("Region " + regionId + " is complete!");
            }
        }
    
        // If all regions are complete, return true
        trace("All regions are complete!");
        return true;
    }

    function onCheckGridComplete():Void
    {
        if (areAllRegionsComplete())
        {
            
            trace("Switching to WinState...");
            FlxG.switchState(new WinState());
        }
        /**
        else
        {
            var statusText = new FlxText(10, 10, 0, "Failed");
            statusText.color = FlxColor.RED; // Set text color to red for "Failed"
            add(statusText);
        }**/
        
    }
    
    function resetLevel(): Void {
        // trace("Clicked to reset!");
        regions = [];
        
        for (i in 0...6) {
            var region = new Region(i);
            regions.push(region);
        }

		regionsInt = [
    	[1, 1, 1, 1, 2, 2],
		[1, 3, 1, 4, 4, 2],
    	[3, 3, 4, 4, 0, 2],
    	[3, 5, 5, 4, 0, 2],
    	[5, 5, 5, 4, 0, 0],
    	[5, 4, 4, 4, 4, 0]
		];

        // Add Cells to the Regions
		for (row in 0...6)
    	{
        	for (col in 0...6)
        	{
                var regionId:Int = regionsInt[row][col];
                var region = regions[regionId];

                if (region != null) {
                    var cellAtInt:Cell = grid.cells[row][col];
                    cellAtInt.setInvalid(false);
                    cellAtInt.setSelectedWithValue(false);
                    region.cellsInRegion.push(cellAtInt);  // Add the cell to the region
                    cellAtInt.belongsToRegion = regionId;  // Mark the cell with the region ID
                }
            }
    	}

        // Check adjacent regions
        for (row in 0...6) {
            for (col in 0...6) {
                var currentRegionId = regionsInt[row][col];
                var currentRegion = regions[currentRegionId];
    
                // Check adjacent cells (up, down, left, right)
                var adjacentOffsets = [
                    {dx: -1, dy: 0}, // Left
                    {dx: 1, dy: 0},  // Right
                    {dx: 0, dy: -1}, // Up
                    {dx: 0, dy: 1}   // Down
                ];
    
                for (offset in adjacentOffsets) {
                    var adjacentRow = row + offset.dy;
                    var adjacentCol = col + offset.dx;
    
                    if (adjacentRow >= 0 && adjacentRow < 6 && adjacentCol >= 0 && adjacentCol < 6) {
                        var adjacentRegionId = regionsInt[adjacentRow][adjacentCol];
    
                        // If the adjacent cell belongs to a different region
                        if (adjacentRegionId != currentRegionId) {
                            var adjacentRegion = regions[adjacentRegionId];
                            
                            // Add the adjacent region if not already added
                            if (!currentRegion.regionsAdjacent.contains(adjacentRegion)) {
                                currentRegion.regionsAdjacent.push(adjacentRegion);
                            }
    
                            // Add current region to the adjacent region's adjacency list
                            if (!adjacentRegion.regionsAdjacent.contains(currentRegion)) {
                                adjacentRegion.regionsAdjacent.push(currentRegion);
                            }
                        }
                    }
                }
            }
        }

        setCellColors();
    }

    function toggleMusic(): Void {
        if (musicToggleBool == false) {
            FlxG.sound.music.volume = 0;
        } else {
            FlxG.sound.music.volume = 0.50;
        }

        musicToggleBool = !musicToggleBool;
    }
    
    function onclickheadback():Void
    {
        FlxG.switchState(new RuleState());
    }
    
    function normalizeShape(shape:Array<FlxPoint>):Array<FlxPoint> {
        var minX:Float = shape[0].x;
        var minY:Float = shape[0].y;
    
        // Find the minimum x and y values
        for (point in shape) {
            if (point.x < minX) minX = point.x;
            if (point.y < minY) minY = point.y;
        }
    
        // Shift all points so that the minimum x and y are at (0,0)
        var normalizedShape = shape.map(function(p) {
            return new FlxPoint(p.x - minX, p.y - minY);
        });
    
        return normalizedShape;
    }
    
    
    function shapesMatch(shape1:Array<FlxPoint>, shape2:Array<FlxPoint>):Bool {
        if (shape1.length != shape2.length) return false;
    
        // Create sets of points for easy comparison
        var set1 = new haxe.ds.StringMap<Bool>();
        for (p in shape1) {
            var x = Math.floor(p.x);
            var y = Math.floor(p.y);
            var key = x + "," + y;
            set1.set(key, true);
        }
    
        for (p in shape2) {
            var x = Math.floor(p.x);
            var y = Math.floor(p.y);
            var key = x + "," + y;
            if (!set1.exists(key)) return false;
        }
    
        return true;
    }    

    function isLShape(selectedCells:Array<FlxPoint>):Bool {
        if (selectedCells.length != 4) return false;
    
        var normalizedCells = normalizeShape(selectedCells);
    
        for (config in L_SHAPE_CONFIGURATIONS) {
            if (shapesMatch(normalizedCells, config)) return true;
        }
    
        return false;
    }    

    function isIShape(selectedCells:Array<FlxPoint>):Bool {
        if (selectedCells.length != 4) return false;
    
        var normalizedCells = normalizeShape(selectedCells);
    
        for (config in I_SHAPE_CONFIGURATIONS) {
            if (shapesMatch(normalizedCells, config)) return true;
        }
    
        return false;
    }
    
    function isTShape(selectedCells:Array<FlxPoint>):Bool {
        if (selectedCells.length != 4) return false;
    
        var normalizedCells = normalizeShape(selectedCells);
    
        for (config in T_SHAPE_CONFIGURATIONS) {
            if (shapesMatch(normalizedCells, config)) return true;
        }
    
        return false;
    }

    function isSShape(selectedCells:Array<FlxPoint>):Bool {
        if (selectedCells.length != 4) return false;
    
        var normalizedCells = normalizeShape(selectedCells);
    
        for (config in S_SHAPE_CONFIGURATIONS) {
            if (shapesMatch(normalizedCells, config)) return true;
        }
    
        return false;
    }
    
    function checkAdjacentRegionShapes(regionId:Int): Bool {
        var region = regions[regionId];
        trace("Adjacent regions to region " + regionId + ": ");

        for (adjacent in region.regionsAdjacent) {
            trace(adjacent.id);
        }
        trace("------");

        return true;
    }

    public function areShapesTouching(region1:Region, region2:Region):Bool {
        var selectedCellsRegion1 = getSelectedCellsInRegion(region1.id);
        var selectedCellsRegion2 = getSelectedCellsInRegion(region2.id);

        for (cell1 in selectedCellsRegion1) {
            for (cell2 in selectedCellsRegion2) {
                // Check if the two shape cells are adjacent (sharing an edge)
                if (Math.abs(cell1.x - cell2.x) + Math.abs(cell1.y - cell2.y) == 1) {
                    return true; // The shapes in the two regions are adjacent
                }
            }
        }
        return false;
    }

}
