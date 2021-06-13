package;

import flixel.FlxSprite;

class FreeplayButtonBack extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTrack:FlxSprite;

	public function new()
	{
		super();
        loadGraphic(Paths.image('menubuttonbackground'));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTrack != null)
			setPosition(sprTrack.x - 300, sprTrack.y - 38);
            //setGraphicSize(1100,162);
            //updateHitbox();
	}
}
