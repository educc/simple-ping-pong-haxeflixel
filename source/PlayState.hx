package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import haxe.Log;

class PlayState extends FlxState
{
	var walls:FlxGroup;
	var paddles:FlxGroup;
	var ball:FlxSprite;
	var wallTop:FlxSprite;
	var wallBottom:FlxSprite;
	var paddleLeft:FlxSprite;
	var paddleRight:FlxSprite;

	var scoreLeft:Int = 0;
	var scoreRight:Int = 0;
	var scoreDisplayLeft:FlxText;
	var scoreDisplayRight:FlxText;

	override public function create()
	{
		super.create();

		ball = new FlxSprite();
		ball.makeGraphic(16, 16, FlxColor.WHITE);
		ball.screenCenter();
		ball.velocity.y = 200;
		ball.velocity.x = 200;
		ball.elasticity = 1;
		add(ball);

		// create wall
		wallTop = new FlxSprite(0, 0);
		wallTop.makeGraphic(FlxG.width, 4, FlxColor.LIME);
		wallTop.immovable = true;
		add(wallTop);

		wallBottom = new FlxSprite(0, FlxG.height - 4);
		wallBottom.makeGraphic(FlxG.width, 4, FlxColor.LIME);
		wallBottom.immovable = true;
		add(wallBottom);

		// create paddles
		paddleLeft = new FlxSprite(8, 0);
		paddleLeft.makeGraphic(16, 64, FlxColor.RED);
		paddleLeft.screenCenter(FlxAxes.Y);
		paddleLeft.immovable = true;
		add(paddleLeft);

		paddleRight = new FlxSprite(FlxG.width - 24, 0);
		paddleRight.makeGraphic(16, 64, FlxColor.CYAN);
		paddleRight.screenCenter(FlxAxes.Y);
		paddleRight.immovable = true;
		add(paddleRight);

		walls = new FlxGroup();
		walls.add(wallTop);
		walls.add(wallBottom);

		paddles = new FlxGroup();
		paddles.add(paddleLeft);
		paddles.add(paddleRight);

		// Score
		scoreDisplayLeft = new FlxText(220, 32, 100, "0", 32);
		scoreDisplayRight = new FlxText(320, 32, 100, "0", 32);

		scoreDisplayLeft.color = FlxColor.LIME;
		scoreDisplayRight.color = FlxColor.LIME;

		scoreDisplayRight.alignment = FlxTextAlign.RIGHT;

		add(scoreDisplayLeft);
		add(scoreDisplayRight);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(ball, walls);
		FlxG.collide(ball, paddles);

		setLeftPaddleMovement();
		setRightPraddleMovement();
		checkForWins();
	}

	private function checkForWins()
	{
		var hasWinner = false;
		if (ball.x < 0)
		{
			scoreRight += 1;
			hasWinner = true;
		}
		else if (ball.x > FlxG.width)
		{
			scoreLeft += 1;
			hasWinner = true;
		}

		if (hasWinner)
		{
			updateScoreDisplays();
			ball.velocity.x = ball.velocity.x * -1;
			ball.velocity.y = 200;
			ball.screenCenter();
		}
	}

	private function setLeftPaddleMovement()
	{
		if (FlxG.keys.pressed.W && paddleLeft.y > wallTop.height)
		{
			paddleLeft.velocity.y = -200;
		}
		else if (FlxG.keys.pressed.S && paddleLeft.y + paddleLeft.height < wallBottom.y)
		{
			paddleLeft.velocity.y = 200;
		}
		else
		{
			paddleLeft.velocity.y = 0;
		}
	}

	private function setRightPraddleMovement()
	{
		if (FlxG.keys.pressed.UP && paddleRight.y > wallTop.height)
		{
			paddleRight.velocity.y = -200;
		}
		else if (FlxG.keys.pressed.DOWN && paddleRight.y + paddleRight.height < wallBottom.y)
		{
			paddleRight.velocity.y = 200;
		}
		else
		{
			paddleRight.velocity.y = 0;
		}
	}

	private function updateScoreDisplays()
	{
		scoreDisplayLeft.text = Std.string(scoreLeft);
		scoreDisplayRight.text = Std.string(scoreRight);
	}
}
