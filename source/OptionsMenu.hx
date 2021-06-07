package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class OptionsMenu extends MusicBeatState
{

	var selector:FlxText;
	var curSelected:Int = 0;

	var options:Array<OptionCategory> = [
		new OptionCategory("Gameplay", [
			new DFJKOption(controls),
			new DownscrollOption("Change the layout of the strumline."),
			new GhostTapOption("Ghost Tapping is when you tap a direction and it doesn't give you a miss."),
			new Judgement("Customize your Hit Timings (LEFT or RIGHT)"),
			#if desktop
			new FPSCapOption("Cap your FPS"),
			#end
			new ScrollSpeedOption("Change your scroll speed (1 = Chart dependent)"),
			new AccuracyDOption("Change how accuracy is calculated. (Accurate = Simple, Complex = Milisecond Based)"),
			new ResetButtonOption("Toggle pressing R to gameover."),
			// new OffsetMenu("Get a note offset based off of your inputs!"),
			new CustomizeGameplay("Drag'n'Drop Gameplay Modules around to your preference")
		]),
		new OptionCategory("Appearance", [
			#if desktop
			new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay."),
			new RainbowFPSOption("Make the FPS Counter Rainbow"),
			new AccuracyOption("Display accuracy information."),
			new NPSDisplayOption("Shows your current Notes Per Second."),
			new SongPositionOption("Show the songs current position (as a bar)"),
			new CpuStrums("CPU's strumline lights up when a note hits it."),
			#else
			new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay.")
			#end
		]),
		
		new OptionCategory("Misc", [
			#if desktop
			new FPSOption("Toggle the FPS Counter"),
			new ReplayOption("View replays"),
			#end
			new FlashingLightsOption("Toggle flashing lights that can cause epileptic seizures and strain."),
			new WatermarkOption("Enable and disable all watermarks from the engine."),
			new BotPlay("Showcase your charts and mods with autoplay.")
		])
		
	];

	private var currentDescription:String = "";
	private var grpControls:FlxTypedGroup<OptionText>;
	public static var versionShit:FlxText;

	public var currentOptions:Array<FlxText> = [];
	var offsetPog:FlxText;
	var targetY:Array<Float> = [];

	var currentSelectedCat:OptionCategory;
	var menuShade:FlxSprite;

	override function create()
	{
		var bg:FlxSprite = new FlxSprite(-10,-10).loadGraphic(Paths.image('optionsmenu'));
		add(bg);

		var shade:FlxSprite = new FlxSprite(-205,-100).loadGraphic(Paths.image('Shadescreen'));
		shade.setGraphicSize(Std.int(shade.width * 0.65));
		add(shade);

		for (i in 0...options.length)
		{
			var option:OptionCategory = options[i];

			var text:FlxText = new FlxText(125,(95 * i) + 100, 0, option.getName(),34);
			text.color = FlxColor.fromRGB(255,0,0);
			text.setFormat("Hooman Stitch.ttf", 60, FlxColor.RED);
			add(text);
			currentOptions.push(text);

			targetY[i] = i;

			trace('option king ' );
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		currentDescription = "none";

		currentOptions[0].color = FlxColor.WHITE;

		offsetPog = new FlxText(125,600,0,"Offset: " + FlxG.save.data.offset);
		offsetPog.setFormat("Hooman Stitch.ttf",42,FlxColor.RED);
		add(offsetPog);

		menuShade = new FlxSprite(-1350,-1190).loadGraphic(Paths.image("Menu Shade"));
		menuShade.setGraphicSize(Std.int(menuShade.width * 0.7));
		add(menuShade);

		super.create();
	}

	var isCat:Bool = false;

	function resyncVocals():Void
	{
		MusicMenu.Vocals.pause();

		FlxG.sound.music.play();
		MusicMenu.Vocals.time = FlxG.sound.music.time;
		MusicMenu.Vocals.play();
	}
	

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (MusicMenu.Vocals != null)
		{
			if (MusicMenu.Vocals.playing)
			{
				if (FlxG.sound.music.time > MusicMenu.Vocals.time + 20 || FlxG.sound.music.time < MusicMenu.Vocals.time - 20)
					resyncVocals();
			}
		}


		if (controls.BACK && !isCat)
			FlxG.switchState(new MainMenuState());
		else if (controls.BACK)
		{
			isCat = false;
			for (i in currentOptions)
				remove(i);
			currentOptions = [];
			for (i in 0...options.length)
				{
					// redo shit
					var option:OptionCategory = options[i];
				
					var text:FlxText = new FlxText(125,(95 * i) + 100, 0, option.getName(),34);
					text.color = FlxColor.fromRGB(255,0,0);
					text.setFormat("tahoma-bold.ttf", 60, FlxColor.RED);
					add(text);
					currentOptions.push(text);
				}
				remove(menuShade);
				add(menuShade);
				curSelected = 0;
				currentOptions[curSelected].color = FlxColor.WHITE;
		}
		if (FlxG.keys.justPressed.UP)
			changeSelection(-1);
		if (FlxG.keys.justPressed.DOWN)
			changeSelection(1);
		
		if (isCat)
		{
			
			if (currentSelectedCat.getOptions()[curSelected].getAccept())
			{
				if (FlxG.keys.pressed.SHIFT)
					{
						if (FlxG.keys.pressed.RIGHT)
							{
								currentSelectedCat.getOptions()[curSelected].right();
								currentOptions[curSelected].text = currentSelectedCat.getOptions()[curSelected].getDisplay();
							}
							if (FlxG.keys.pressed.LEFT)
								{
									currentSelectedCat.getOptions()[curSelected].left();
									currentOptions[curSelected].text = currentSelectedCat.getOptions()[curSelected].getDisplay();
								}
					}
				else
				{
					if (FlxG.keys.justPressed.RIGHT)
						{
							currentSelectedCat.getOptions()[curSelected].right();
							currentOptions[curSelected].text = currentSelectedCat.getOptions()[curSelected].getDisplay();
						}
						if (FlxG.keys.justPressed.LEFT)
							{
								currentSelectedCat.getOptions()[curSelected].left();
								currentOptions[curSelected].text = currentSelectedCat.getOptions()[curSelected].getDisplay();
							}
				}
			}
			else
			{

				if (FlxG.keys.pressed.SHIFT)
				{
					if (FlxG.keys.pressed.RIGHT)
						FlxG.save.data.offset++;
					if (FlxG.keys.pressed.LEFT)
						FlxG.save.data.offset--;
				}
				else
				{
					if (FlxG.keys.justPressed.RIGHT)
						FlxG.save.data.offset++;
					if (FlxG.keys.justPressed.LEFT)
						FlxG.save.data.offset--;
				}
			}
		}	
		else
		{
				if (FlxG.keys.pressed.SHIFT)
				{
					if (FlxG.keys.pressed.RIGHT)
						FlxG.save.data.offset++;
					if (FlxG.keys.pressed.LEFT)
						FlxG.save.data.offset--;
				}
				else
				{
					if (FlxG.keys.justPressed.RIGHT)
						FlxG.save.data.offset++;
					if (FlxG.keys.justPressed.LEFT)
						FlxG.save.data.offset--;
				}
		}

		offsetPog.text = "Offset: " + FlxG.save.data.offset + " (Left/Right)";		

		if (controls.RESET)
			FlxG.save.data.offset = 0;

		if (controls.ACCEPT)
			{
				//FlxG.sound.play(Paths.sound("confirm",'clown'));
				if (isCat)
				{
					if (currentSelectedCat.getOptions()[curSelected].press()) {
						// select thingy and redo itself
						for (i in currentOptions)
							remove(i);
						currentOptions = [];
						for (i in 0...currentSelectedCat.getOptions().length)
							{
								// clear and redo everything else
								var option:Option = currentSelectedCat.getOptions()[i];
	
								trace(option.getDisplay());
	
								var text:FlxText = new FlxText(125,(95 * i) + 100, 0, option.getDisplay(),34);
								text.color = FlxColor.fromRGB(255,0,0);
								text.setFormat("Hooman Stitch.ttf", 60, FlxColor.RED);
								add(text);
								currentOptions.push(text);
							}
							remove(menuShade);
							add(menuShade);
							trace('done');
						currentOptions[curSelected].color = FlxColor.WHITE;
					}
				}
				else
				{
					currentSelectedCat = options[curSelected];
					isCat = true;
					for (i in currentOptions)
						remove(i);
					currentOptions = [];
					for (i in 0...currentSelectedCat.getOptions().length)
						{
							// clear and redo everything else
							var option:Option = currentSelectedCat.getOptions()[i];

							trace(option.getDisplay());

							var text:FlxText = new FlxText(125,(95 * i) + 100, 0, option.getDisplay(),34);
							text.color = FlxColor.fromRGB(255,0,0);
							text.setFormat("Hooman Stitch.ttf", 60, FlxColor.RED);
							add(text);
							currentOptions.push(text);
						}
						remove(menuShade);
						add(menuShade);
					curSelected = 0;
					currentOptions[curSelected].color = FlxColor.WHITE;
				}
			}
		FlxG.save.flush();
	}
	
	
	var isSettingControl:Bool = false;
	
	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end
			
		//FlxG.sound.play(Paths.sound("Hover",'clown'));
	
		currentOptions[curSelected].color = FlxColor.fromRGB(255,0,0);
	
		curSelected += change;
	
		if (curSelected < 0)
			curSelected = currentOptions.length - 1;
		if (curSelected >= currentOptions.length)
			curSelected = 0;
	
	
		currentOptions[curSelected].color = FlxColor.WHITE;
	
		var bullShit:Int = 0;
		
	}
}