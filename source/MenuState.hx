package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MenuState extends FlxState {
    private var title: FlxText;
    private var playButton: FlxButton;
    private var titleShadow: FlxText;

	// Variables for music

    override public function create():Void {
        super.create();

        // Set the background color
        this.bgColor = 0xFFFFFFFF; // White background
        // Add background image
        var background = new FlxSprite(0, 0);
        background.loadGraphic(AssetPaths.Background__png);
        // Resize the image to match the screen size (or any custom size)
        background.setGraphicSize(FlxG.width, FlxG.height); // Resize the background to fit the screen
        background.updateHitbox(); // Ensure the hitbox is updated after resizing
        add(background);

        titleShadow = new FlxText(0, 0, FlxG.width, "LITS Puzzle Game");
        titleShadow.setFormat(null, 48, FlxColor.GRAY, "center"); // Gray shadow text
        titleShadow.x = (FlxG.width - titleShadow.width) / 2 + 5; // Offset for shadow effect
        titleShadow.y = FlxG.height * 0.3 + 5; // Offset vertically for shadow effect
        add(titleShadow); // Add shadow first to render behind the original text

        // Create and position the title text
        title = new FlxText(0, 0, FlxG.width, "LITS Puzzle Game");
        title.setFormat(null, 48, 0xFF0000FF, "center"); // Blue text
        title.x = (FlxG.width - title.width) / 2; // Dynamically center horizontally
        title.y = FlxG.height *0.3;
        add(title);

        // Create shadow text for the ti

        playButton = new FlxButton(0, 0, "Play", onPlay);
        playButton.scale.set(2, 2);
        playButton.label.setFormat(null, 24, FlxColor.WHITE); // Larger text size to match the larger button
        playButton.labelOffsets[0].x = (playButton.width - playButton.label.width) / 2;
        playButton.labelOffsets[0].y = (playButton.height - playButton.label.height) / 2;

        playButton.x = (FlxG.width - playButton.width) / 2; // Center horizontally
        playButton.y = (FlxG.height - playButton.height) / 2 + 50; // Center vertically
        
        add(playButton);
        
        
		FlxG.sound.playMusic(AssetPaths.Background__ogg);// Function for Play button
        FlxG.sound.music.volume = 0.1;
    }
override public function update(elapsed:Float):Void {
    super.update(elapsed);

    // Check for hover effect on Play button
    if (FlxG.mouse.screenX >= playButton.x && FlxG.mouse.screenX <= playButton.x + playButton.width * playButton.scale.x &&
        FlxG.mouse.screenY >= playButton.y && FlxG.mouse.screenY <= playButton.y + playButton.height * playButton.scale.y) {
        playButton.label.color = FlxColor.YELLOW; // Change label color on hover

    } else {
        playButton.label.color = FlxColor.WHITE;

    }

}

        private function onPlay():Void {
            FlxG.switchState(new RuleState());
        }
        override public function destroy():Void {
            super.destroy();
		  FlxG.sound.music.stop();
    }
}
