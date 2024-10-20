package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class RuleState extends FlxState {
    private var rulesText: FlxText;
    private var backButton: FlxButton;

    override public function create():Void {
        super.create();

        // Set the background color
        var background = new FlxSprite(0, 0);
        background.loadGraphic(AssetPaths.gold_gradient__jpg);
        add(background);
        // Create the rules text
        rulesText = new FlxText(10, 10, FlxG.width - 20, 
            "Game Rules:\n\n" +
            "1. Shade exactly four connected cells in each outlined region to form an L, I, T, or S tetromino.\n\n" +
            "2. The following conditions must be true:\n" +
            "   (a) All selected cells are connected with each other.\n" +
            "   (b) No 2x2 square can be formed anywhere on the grid.\n" +
            "   (c) No two shapes of the same type can touch.\n"
        );
        rulesText.setFormat(null, 16, 0xFF000000, "left"); // Black text
        add(rulesText);

        // Add a back button to return to the menu
        backButton = new FlxButton(FlxG.width / 2, FlxG.height - 40, "Play", onclick);
        backButton.scale.set(2, 2);
        backButton.label.setFormat(null, 24, FlxColor.WHITE); // Larger text size to match the larger button
        backButton.labelOffsets[0].x = (backButton.width - backButton.label.width) / 2;
        backButton.labelOffsets[0].y = (backButton.height - backButton.label.height) / 2;
        backButton.x = (FlxG.width - backButton.width) / 2;
        
        add(backButton);
    }
        override public function update(elapsed:Float):Void {
        super.update(elapsed);

        /// Check for hover effect on Play button
        if (FlxG.mouse.screenX >= backButton.x && FlxG.mouse.screenX <= backButton.x + backButton.width &&
            FlxG.mouse.screenY >= backButton.y && FlxG.mouse.screenY <= backButton.y + backButton.height) {
            backButton.label.color = FlxColor.YELLOW; // Change label color on hover
        } else {
            backButton.label.color = FlxColor.WHITE; // Revert label color on hover out
        }
    }
    private function onclick():Void {
        // Switch back to MenuState
        FlxG.switchState(new PlayState());
    }
}