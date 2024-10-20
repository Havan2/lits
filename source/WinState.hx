import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class WinState extends FlxState
{
    override public function create():Void
    {
        super.create();

        var background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.gold_gradient__jpg);
		add(background);

        // Display "You Won" message
        var winText = new FlxText(0, 50, FlxG.width, "You Won!");
        winText.setFormat(null, 32, FlxColor.GREEN, "center");
        add(winText);
        // Optional: Create confetti effect
        createConfettiEffect();

        // Create a button to return to MenuState
        var menuButton = new FlxButton(FlxG.width / 2 - 40, FlxG.height / 2, "Back to Menu", goToMenu);
        add(menuButton);
    }

    // Function to switch to MenuState
    function goToMenu():Void
    {
        FlxG.switchState(new MenuState());
    }
    // Function to create a simple confetti effect using colored squares
    function createConfettiEffect():Void
    {
        for (i in 0...100) // Create 100 confetti pieces
        {
            var confetti = new FlxSprite(FlxG.width * Math.random(), FlxG.height * Math.random());
            var width:Int = Math.ceil(5 + Math.random() * 10); // Random size (5 to 15)
            var height:Int = Math.ceil(5 + Math.random() * 10); // Random size (5 to 15)
            confetti.makeGraphic(width, height, getRandomColor()); // Create a small square with a random color
            confetti.scrollFactor.set(0, 0); // Make it static

            // Set a random velocity to simulate falling confetti
            confetti.velocity.set(FlxG.random.int(-50, 50), FlxG.random.int(50, 150)); // Fall downwards

            add(confetti); // Add the confetti to the display
        }
    }
    // Function to get a random color
    private function getRandomColor():FlxColor
    {
        return FlxColor.fromHSB(FlxG.random.int(0, 360), 1, 1); // Random color in HSV
    }
}