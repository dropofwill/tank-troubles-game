package code
{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Bitmap;
	import Math;


	public class Main extends MovieClip
	{
		/*---------------------------------------------------------------------------------------------/
			Designed and Developed by Will Paul
			Capture it! Font by Magique Fonts (Koczman Bálint), http://www.dafont.com/capture-it.font
			Jura. Font by by Tenbytwenty, http://www.tenbytwenty.com/jura.php
			AFV Dingbats. Font by Perry Mason, http://www.dafont.com/afv.font
			Cardboard Texture. http://www.photos-public-domain.com/2011/01/11/cardboard-texture/
		/---------------------------------------------------------------------------------------------*/
		
		
		/*--------Game wide Variables-----------*/
		private var currentLevel:String = ""; 		//possibly: "main_menu", "time_trial", "level_1", "level_2", "level_3"
		private var format1:TextFormat; 
		private var format2:TextFormat;
		private var finalScore:TextField;
		
		private var bulletClips:Array = new Array(); 	//the array where both the user and the enemies bullets art stored
		private var wallClips:Array = new Array();		//the array for the Wall MovieClips
		private var enemyClips:Array = new Array();		//the array for the Enemy MovieClips
		
		private var char:Char;									//the character/tank's turret
		private var charBody:CharBody;							//the character/tank's body
		private var charSX:int = 200; 							//x value of where the char spawns
		private var charSY:int = stage.stageHeight/2 + 30; 		//y value of where the char spawns
		private var fX:int = 200;								//x value of where the char goes after spawning
		private var fY:int = stage.stageHeight/2 + 30;  		//y value of where the char goes after spawning
		private var fR:Number;									//where the char should be facing in degrees
		private var oX:int = charSX;							//keeps track of the original X location of the tank
		private var oY:int = charSY;							//keeps track of the original Y location of the tank
		private var rotateChar:Boolean = true;					//whether or not the turret will rotate
		private var delaySetPoint:Timer;						//delays user input until after the level has started
		
		/*---------Time Trial Variables---------*/
		private var tTClips:Array = new Array();		//the array where the TimedTargets are stored
		private var tTTimer:Timer;						//the timer that determines when new targets are added to the stage
		private var noTimedTargets:int = 20;			//how many targets to add in the first round of targets
		private var tTCycleCounter:int = 0;				//keeps track of how many rows of targets
		private var tTSide:String;						//Which side the TimedTargets fly in from stored as "R","L","B", & "T"
		private var tTMultiplier:int = 1;				//keeps track of the points multiplier
		private var tTSlideRight:int = 100;				//for targets along the bottom in time trial mode
		private var tTSlideLeft:int = 100;				//for targets along the top in time trial mode
		private var tTSlideUp:int = 100;				//for targets along the right in time trial mode
		private var tTSlideDown:int = 100;				//for targets along the left in time trial mode
		
		private var countDown:Timer;					//the timer that keeps track of the length of the game
		private var timeTrialLength:int = 20;			//in seconds
		private var timeOfDeath:int = 0;				//when the player shot themselves or the timer ran out
		private var score:int = 0;						//the players current score
		private var prevScore:int;						//what the player got the last game
		private var textCountDown:TextField;			//TextField that displays the countDown Timer
		private var textScore:TextField;				//TextField that displays the current score
		
		
		/*-----Level Specific Variables------*/
		private var removeWall:Wall;
		private var victoryStar:Star;
		
		/*-----Main Menu Variables------*/
		private var openingScreen:OpeningScreen = new OpeningScreen(stage.stageWidth/2,stage.stageHeight/2); //Graphic for the main menu
		
		/*-----Credits Variables-----*/
		private var creditsTitle:TextField;
		private var creditsText:TextField;
		
		//Buttons for manuevering about the game
		private var startTimeTrial:BtnTimeTrial;
		private var btnRestartLevel:BtnRestartLevel;
		private var btnMainMenu:BtnMainMenu;
		private var btnLevel1:BtnLevel1;
		private var btnLevel2:BtnLevel2;
		private var btnLevel3:BtnLevel3;
		private var btnCredits:BtnCredits;
		
		
		/*-------------------------------------------
		*CONSTRUCTOR
		* -------------------------------------------*/

		public function Main()
		{
			// constructor code
			format1 = new TextFormat  ;
			format1.size = 25;
			format1.color = 0x5d381d ;
			format1.leading = 5;
			format1.font = "Jura";
			

			format2 = new TextFormat  ;
			format2.size = 35;
			format2.font = "Jura";
			format2.color = 0x5d381d ;
			
			initMainMenu();
		}


		/*-------------------------------------------
		*MAIN MENU
		* -------------------------------------------*/

		private function initMainMenu():void
		{
			currentLevel = "main_menu";
			
			addChild(openingScreen);
			
			
			startTimeTrial = new BtnTimeTrial(100,300);
			addChild(startTimeTrial);
			
			btnLevel1 = new BtnLevel1(100,400);
			addChild(btnLevel1);
			
			btnLevel2 = new BtnLevel2(125,500);
			addChild(btnLevel2);
			
			btnLevel3 = new BtnLevel3(150,600);
			addChild(btnLevel3);
			
			btnCredits = new BtnCredits(700,600);
			addChild(btnCredits);
			
			startTimeTrial.addEventListener(MouseEvent.CLICK,startingTimeTrial);
			btnLevel1.addEventListener(MouseEvent.CLICK,startingLevel1);
			btnLevel2.addEventListener(MouseEvent.CLICK,startingLevel2);
			btnLevel3.addEventListener(MouseEvent.CLICK,startingLevel3);
			btnCredits.addEventListener(MouseEvent.CLICK,startingCredits);
		}
		
		//A function to go back to the Main Menu screen when a level is completed
		private function initMainMenuClick(e:MouseEvent):void
		{			
			btnMainMenu.removeEventListener(MouseEvent.CLICK,initMainMenuClick);
			removeChild(btnMainMenu);
			
			if (currentLevel == "time_trial")
			{
     			btnRestartLevel.removeEventListener(MouseEvent.CLICK,startingTimeTrial);
				removeChild(btnRestartLevel);
			}
			else if (currentLevel == "level_1")
			{
				btnRestartLevel.removeEventListener(MouseEvent.CLICK,startingLevel1);
				removeChild(btnRestartLevel);
			}
			else if (currentLevel == "level_2")
			{
				btnRestartLevel.removeEventListener(MouseEvent.CLICK,startingLevel2);
				removeChild(btnRestartLevel);
			}
			else if (currentLevel == "level_3")
			{
				btnRestartLevel.removeEventListener(MouseEvent.CLICK,startingLevel3);
				removeChild(btnRestartLevel);
			}

			if (finalScore != null)
			{
				removeChild(finalScore);
				finalScore = null;
			}
			
			initMainMenu();
		}
		
		private function initMainMenuCleaner():void
		{
			removeChild(openingScreen);
			
			startTimeTrial.removeEventListener(MouseEvent.CLICK,startingTimeTrial);
			removeChild(startTimeTrial);
		
			btnLevel1.removeEventListener(MouseEvent.CLICK,startingLevel1);
			removeChild(btnLevel1);
			
			btnLevel2.removeEventListener(MouseEvent.CLICK,startingLevel2);
			removeChild(btnLevel2);
			
			btnLevel3.removeEventListener(MouseEvent.CLICK,startingLevel3);
			removeChild(btnLevel3);
			
			btnCredits.addEventListener(MouseEvent.CLICK,startingCredits);
			removeChild(btnCredits);
			
		}

		private function startingTimeTrial(e:MouseEvent):void
		{
			initMainMenuCleaner();
			initTimeTrial();
			
			currentLevel = "time_trial";
		}
		
		private function startingLevel1(e:MouseEvent):void
		{
			initMainMenuCleaner();
			initLevel1();
			
			currentLevel = "level_1";
		}
		
		private function startingLevel2(e:MouseEvent):void
		{
			initMainMenuCleaner();
			initLevel2();
			
			currentLevel = "level_2";
		}
		
		private function startingLevel3(e:MouseEvent):void
		{
			initMainMenuCleaner();
			initLevel3();
			
			currentLevel = "level_3";
		}
		
		private function startingCredits(e:MouseEvent):void
		{
			initMainMenuCleaner();
			initCredits();
		}



		/*-------------------------------------------
		*            TIME TRIAL LEVEL
		* -------------------------------------------*/

		private function initTimeTrial():void
		{
			//Timers
			countDown = new Timer(1000,timeTrialLength);
			countDown.addEventListener(TimerEvent.TIMER, timeTrialRepeat);
			countDown.start();

			tTTimer = new Timer(500,noTimedTargets);
			tTTimer.addEventListener(TimerEvent.TIMER, newTimedTarget);
			tTTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timeTrialPart2);
			tTTimer.start();
			
			//Prevents the char from moving before the level has started
			delaySetPoint = new Timer(100,1);
			delaySetPoint.addEventListener(TimerEvent.TIMER_COMPLETE, setPointEventListener);
			delaySetPoint.start();
			
			//Add Event Listeners;
			this.addEventListener(Event.ENTER_FRAME, frameLoop);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyIsDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyIsUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);

			//TextFields
			textCountDown = new TextField();
			textScore = new TextField();

			textCountDown.x = 40;
			textCountDown.y = 10;

			textScore.x = stage.stageWidth - 200;
			textScore.y = 10;

			textCountDown.defaultTextFormat = format1;
			textScore.defaultTextFormat = format1;
			textScore.width = 400;

			addChild(textCountDown);
			addChild(textScore);

			textScore.text = "Score: " + String(score);
			textCountDown.text = String(timeTrialLength);

			//Make the user's character
			charBody = new CharBody(charSX,charSY);
			addChild(charBody);
			
			char = new Char(charSX,charSY);
			addChild(char);

			//Make the walls
			var wall1:Wall = new Wall(stage.stageWidth/2,60,stage.stageWidth,30);
			var wall2:Wall = new Wall(16,30+stage.stageHeight/2,30,stage.stageHeight - 60);

			addChild(wall1);
			addChild(wall2);

			wallClips.push(wall1);
			wallClips.push(wall2);
		}

		
		private function newTimedTarget(e:TimerEvent):void
		{
			var timedTarget:TimedTargets;
			var wS:String = decideTimedTarget();//whichSide that they fly in from

			if (wS == "B")
			{
				timedTarget = new TimedTargets(tTSlideRight,800,this,180,1,4000,1*tTMultiplier);
				addChild(timedTarget);
				tTClips.push(timedTarget);
				tTSlideRight +=  200;
			}
			else if (wS == "L")
			{
				timedTarget = new TimedTargets(-100,tTSlideUp,this,270,0.3,4000,2*tTMultiplier);
				addChild(timedTarget);
				tTClips.push(timedTarget);
				tTSlideUp +=  100;
			}
			else if (wS == "T")
			{
				timedTarget = new TimedTargets(tTSlideLeft,-100,this,0,1,4000,1*tTMultiplier);
				addChild(timedTarget);
				tTClips.push(timedTarget);
				tTSlideLeft +=  200;
			}
			else
			{
				timedTarget = new TimedTargets(1100,tTSlideDown,this,90,0.3,4000,2*tTMultiplier);
				addChild(timedTarget);
				tTClips.push(timedTarget);
				tTSlideDown +=  100;
			}

			tTCycleCounter++;
		}
		
		
		//Every five targets it chooses a new random direction for the timers to fly in from, also makes sure they won't overlap
		private function decideTimedTarget():String
		{
			if (tTCycleCounter == 0 || tTCycleCounter == 5 || tTCycleCounter == 10 || tTCycleCounter == 15)
			{
				var wS:Number = Math.random();//decide which Side

				//reset the rows
				tTSlideRight = 100;
				tTSlideLeft = 100;
				tTSlideUp = 100;
				tTSlideDown = 100;

				if (wS >= 0 && wS < 0.25)
				{
					//Keeps the directions different
					if (tTSide != "B")
					{
						tTSide = "B";
					}
					else
					{
						tTSide = "R";
					}
				}
				else if (wS >= 0.25 && wS < 0.5)
				{
					if (tTSide != "R")
					{
						tTSide = "R";
					}
					else
					{
						tTSide = "T";
					}
				}
				else if (wS >= 0.5 && wS < 0.75)
				{
					if (tTSide != "T")
					{
						tTSide = "T";
					}
					else
					{
						tTSide = "L";
					}
				}
				else
				{
					if (tTSide != "L")
					{
						tTSide = "L";
					}
					else
					{
						tTSide = "B";
					}
				}
			}
			return tTSide;
		}

		private function timeTrialPart2(e:TimerEvent):void
		{
			var wall3:Wall = new Wall(stage.stageWidth/3 + 15,stage.stageHeight/2+60,30,300);
			var wall4:Wall = new Wall(stage.stageWidth*2/3 + 15,stage.stageHeight/2+60,30,300);
			var timed1:TimedTargets = new TimedTargets(0,stage.stageHeight/3+60, this, 270.1, 0.25, 9000, 5*tTMultiplier);
			var timed2:TimedTargets = new TimedTargets(stage.stageWidth,stage.stageHeight/3+60, this, 90.1, 0.25, 9000, 5*tTMultiplier);

			addChild(wall3);
			addChild(wall4);
			addChild(timed1);
			addChild(timed2);

			wallClips.push(wall3);
			wallClips.push(wall4);
			tTClips.push(timed1);
			tTClips.push(timed2);
		}
		
		//Figures out/displays the score and calls the cleaner function
		private function timeTrialRepeat(e:TimerEvent):void
		{
			textCountDown.text = (timeTrialLength - countDown.currentCount).toString();

			if (countDown.currentCount >= timeTrialLength)
			{
				timeOfDeath = timeTrialLength;
				initTimeTrialCleaner();
			}
		}

		private function initTimeTrialCleaner():void
		{
			prevScore = score;
			score = 0;
			fX = 200;
			fY = stage.stageHeight/2 + 30; 
			
			tTSlideRight = 100;
			tTSlideLeft = 100;
			tTSlideUp = 100;
			tTSlideDown = 100;
			tTCycleCounter = 0;

			finalScore = new TextField();
			finalScore.defaultTextFormat = format1;
			finalScore.text = String("You Scored " + String(prevScore) + " Points in " + String(timeOfDeath) + " Seconds.");
			finalScore.x = stage.stageWidth / 2;
			finalScore.y = stage.stageHeight / 2 - 15;
			finalScore.width = 400;
			addChild(finalScore);

			this.removeEventListener(Event.ENTER_FRAME, frameLoop);
			stage.removeEventListener(MouseEvent.CLICK, setPoint);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyIsDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyIsUp);
			delaySetPoint.removeEventListener(TimerEvent.TIMER_COMPLETE, setPointEventListener);
			countDown.removeEventListener(TimerEvent.TIMER, timeTrialRepeat);
			tTTimer.removeEventListener(TimerEvent.TIMER, newTimedTarget);
			tTTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, timeTrialPart2);

			for (var i:int = 0; i<bulletClips.length; i++)
			{
				if (this.contains(bulletClips[i]))
				{
					removeChild(bulletClips[i]);
					bulletClips[i].bulletCleaner();
				}
			}

			bulletClips = [];

			for (var w:int = 0; w<wallClips.length; w++)
			{
				removeChild(wallClips[w]);
			}

			wallClips = [];
			
			for (var t:int = 0; t<tTClips.length; t++)
			{
				//removeChild(tTClips[i]);
				tTClips[t].timedTargetsCleaner();
				tTClips[t].visible = false;
			}
			
			tTClips = [];
			
			removeChild(char);
			char = null;
			
			removeChild(charBody);
			charBody = null;

			removeChild(textCountDown);
			removeChild(textScore);

			btnRestartLevel = new BtnRestartLevel(50,stage.stageHeight / 2);
			addChild(btnRestartLevel);
			
			btnMainMenu = new BtnMainMenu(50, (stage.stageHeight / 2) + 100);
			addChild(btnMainMenu);

			btnRestartLevel.addEventListener(MouseEvent.CLICK,restartTimeTrial);
			btnMainMenu.addEventListener(MouseEvent.CLICK,initMainMenuClick);
		}
		

		private function restartTimeTrial(e:MouseEvent):void
		{
			btnRestartLevel.removeEventListener(MouseEvent.CLICK,startingTimeTrial);
			removeChild(btnRestartLevel);
			
			btnMainMenu.removeEventListener(MouseEvent.CLICK,initMainMenuClick);
			removeChild(btnMainMenu);

			if (finalScore != null)
			{
				removeChild(finalScore);
				finalScore = null;
			}
			initTimeTrial();
		}

		/*-------------------------------------------
		*LEVEL 1
		* -------------------------------------------*/

		private function initLevel1():void
		{
			//Prevents the char from moving before the level has started
			delaySetPoint = new Timer(100,1);
			delaySetPoint.addEventListener(TimerEvent.TIMER_COMPLETE, setPointEventListener);
			delaySetPoint.start();
			
			//Adds Event Listeners;
			this.addEventListener(Event.ENTER_FRAME, frameLoop);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyIsDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyIsUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			//Makes the star
			victoryStar = new Star((stage.stageWidth*2)/3, (stage.stageHeight/2)+30, 0.3, 0.3, 90);
			addChild(victoryStar);

			//Makes the user's character
			charBody = new CharBody(charSX,charSY);
			addChild(charBody);
			char = new Char(charSX,charSY);
			addChild(char);
			
			//Make the enemey
			var enemy1:Enemy = new Enemy(((stage.stageWidth*2)/3) + 90, stage.stageHeight/2+30, 0.75, 0.75, 180,this,0);
			addChild(enemy1);
			enemyClips.push(enemy1);
			
			//Makes the walls
			var wall1:Wall = new Wall(stage.stageWidth/2,60,stage.stageWidth,30);
			var wall2:Wall = new Wall(16,30+stage.stageHeight/2,30,stage.stageHeight - 60);
			var wall3:Wall = new Wall(stage.stageWidth/2,stage.stageHeight-15,stage.stageWidth,30);
			var wall4:Wall = new Wall(stage.stageWidth-14,30+stage.stageHeight/2,30,stage.stageHeight - 60);
			var wall5:Wall = new Wall(((stage.stageWidth*2)/3) - 60, stage.stageHeight/2+30, 30, 300);

			addChild(wall1);
			addChild(wall2);
			addChild(wall3);
			addChild(wall4);
			addChild(wall5);

			wallClips.push(wall1);
			wallClips.push(wall2);
			wallClips.push(wall3);
			wallClips.push(wall4);
			wallClips.push(wall5);
		}

		private function initLevel1Cleaner(win:Boolean):void
		{
			fX = 200;
			fY = stage.stageHeight/2 + 30; 
			
			finalScore = new TextField();
			finalScore.defaultTextFormat = format2;
			
			if (win == true)
			{
				finalScore.text = "You won!";
			}
			else if (win == false)
			{
				finalScore.text = "You lost.";
			}
			finalScore.x = stage.stageWidth / 2;
			finalScore.y = stage.stageHeight / 2 - 15;
			finalScore.width = 400;
			addChild(finalScore);

			this.removeEventListener(Event.ENTER_FRAME, frameLoop);
			stage.removeEventListener(MouseEvent.CLICK, setPoint);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyIsDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyIsUp);

			for (var i:int = 0; i < bulletClips.length; i++)
			{
				if (this.contains(bulletClips[i]))
				{
					removeChild(bulletClips[i]);
					bulletClips[i].bulletCleaner();
				}
			}

			bulletClips = [];

			for (var w:int = 0; w < wallClips.length; w++)
			{
				removeChild(wallClips[w]);
			}

			wallClips = [];
			
			for (var e:int = 0; e < enemyClips.length; e++)
			{
				if (this.contains(enemyClips[e]))
				{
					removeChild(enemyClips[e]);
					enemyClips[e].enemyCleaner();
				}
			}
			
			enemyClips = [];
			
			removeChild(char);
			char = null;
			
			removeChild(charBody);
			charBody = null;
			
			removeChild(victoryStar);
			victoryStar = null;

			btnRestartLevel = new BtnRestartLevel(50,stage.stageHeight / 2);
			addChild(btnRestartLevel);
			
			btnMainMenu = new BtnMainMenu(50, (stage.stageHeight / 2) + 100);
			addChild(btnMainMenu);

			btnRestartLevel.addEventListener(MouseEvent.CLICK,restartLevel1);
			btnMainMenu.addEventListener(MouseEvent.CLICK,initMainMenuClick);
		}
		
		private function restartLevel1(e:MouseEvent):void
		{
			btnRestartLevel.removeEventListener(MouseEvent.CLICK,restartLevel1);
			removeChild(btnRestartLevel);
			
			btnMainMenu.removeEventListener(MouseEvent.CLICK,initMainMenuClick);
			removeChild(btnMainMenu);

			if (finalScore != null)
			{
				removeChild(finalScore);
				finalScore = null;
			}

			initLevel1();
		}



		/*-------------------------------------------
		*LEVEL 2
		* -------------------------------------------*/

		private function initLevel2():void
		{
			//Prevents the char from moving before the level has started
			delaySetPoint = new Timer(100,1);
			delaySetPoint.addEventListener(TimerEvent.TIMER_COMPLETE, setPointEventListener);
			delaySetPoint.start();
			
			//Make the event listeners
			this.addEventListener(Event.ENTER_FRAME, frameLoop);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyIsDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyIsUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			//Makes the star
			victoryStar = new Star(400, (stage.stageHeight/2)+30, 0.3, 0.3, 90);
			addChild(victoryStar);

			//Makes the user's character
			charBody = new CharBody(charSX,charSY);
			addChild(charBody);
			char = new Char(charSX,charSY);
			addChild(char);
			
			//Make a couple enemies
			var enemy1:Enemy = new Enemy(800, 160, 0.75, 0.75, 180,this,0);
			addChild(enemy1);
			enemyClips.push(enemy1);
			
			var enemy2:Enemy = new Enemy(800, 600, 0.75, 0.75, 180,this,1);
			addChild(enemy2);
			enemyClips.push(enemy2);
			
			//Makes the walls
			var wall1:Wall = new Wall(stage.stageWidth/2,60,stage.stageWidth,30);
			var wall3:Wall = new Wall(stage.stageWidth/2,stage.stageHeight-15,stage.stageWidth,30);
			var wall4:Wall = new Wall(stage.stageWidth-14,30+stage.stageHeight/2,30,stage.stageHeight - 60);
			var wall5:Wall = new Wall(300, stage.stageHeight/2+30, 30, 225);
			var wall6:Wall = new Wall(564,282,500,30);
			var wall7:Wall = new Wall(564,477,500,30);
			
			addChild(wall1);
			addChild(wall3);
			addChild(wall4);
			addChild(wall5);
			addChild(wall6);
			addChild(wall7);
			
			wallClips.push(wall1);
			wallClips.push(wall3);
			wallClips.push(wall4);
			wallClips.push(wall5);
			wallClips.push(wall6);
			wallClips.push(wall7);
		}

		private function initLevel2Cleaner(win:Boolean):void
		{
			fX = 200;
			fY = stage.stageHeight/2 + 30; 
			
			finalScore = new TextField();
			finalScore.defaultTextFormat = format2;
			
			if (win == true)
			{
				finalScore.text = "You won!";
			}
			else if (win == false)
			{
				finalScore.text = "You lost.";
			}
			finalScore.x = stage.stageWidth / 2;
			finalScore.y = stage.stageHeight / 2 - 15;
			finalScore.width = 400;
			addChild(finalScore);
			
			//Remove the event listeners
			this.removeEventListener(Event.ENTER_FRAME, frameLoop);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyIsDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyIsUp);
			stage.removeEventListener(MouseEvent.CLICK, setPoint);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			for (var i:int = 0; i < bulletClips.length; i++)
			{
				if (this.contains(bulletClips[i]))
				{
					removeChild(bulletClips[i]);
					bulletClips[i].bulletCleaner();
				}
			}

			bulletClips = [];


			for (var w:int = 0; w < wallClips.length; w++)
			{
				removeChild(wallClips[w]);
			}

			wallClips = [];
			
			for (var e:int = 0; e < enemyClips.length; e++)
			{
				if (this.contains(enemyClips[e]))
				{
					removeChild(enemyClips[e]);
					enemyClips[e].enemyCleaner();
				}
			}
			
			enemyClips = [];
			
			removeChild(char);
			char = null;
			
			removeChild(charBody);
			charBody = null;
			
			removeChild(victoryStar);
			victoryStar = null;

			btnRestartLevel = new BtnRestartLevel(50,stage.stageHeight / 2);
			addChild(btnRestartLevel);
			
			btnMainMenu = new BtnMainMenu(50, (stage.stageHeight / 2) + 100);
			addChild(btnMainMenu);

			//Add event listeners
			btnRestartLevel.addEventListener(MouseEvent.CLICK,restartLevel2);
			btnMainMenu.addEventListener(MouseEvent.CLICK,initMainMenuClick);
		}
		
		private function restartLevel2(e:MouseEvent):void
		{
			//Remove event listeners
			btnRestartLevel.removeEventListener(MouseEvent.CLICK,restartLevel2);
			btnMainMenu.removeEventListener(MouseEvent.CLICK,initMainMenuClick);
			
			removeChild(btnRestartLevel);
			removeChild(btnMainMenu);
			
			if (finalScore != null)
			{
				removeChild(finalScore);
				finalScore = null;
			}
			
			initLevel2();
		}


		/*-------------------------------------------
		*LEVEL 3
		* -------------------------------------------*/
		private function initLevel3():void
		{
			//Prevents the char from moving before the level has started
			delaySetPoint = new Timer(100,1);
			delaySetPoint.addEventListener(TimerEvent.TIMER_COMPLETE, setPointEventListener);
			delaySetPoint.start();
			
			//add event listeners
			this.addEventListener(Event.ENTER_FRAME, frameLoop);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyIsDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyIsUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			//Makes the star
			victoryStar = new Star(400, (stage.stageHeight/2)+30, 0.3, 0.3, 90);
			addChild(victoryStar);

			//Makes the user's character
			charBody = new CharBody(charSX,charSY);
			addChild(charBody);
			char = new Char(charSX,charSY);
			addChild(char);
			
			//Make a couple enemies
			var enemy1:Enemy = new Enemy(800, 160, 0.75, 0.75, 180,this,0);
			addChild(enemy1);
			enemyClips.push(enemy1);
			
			var enemy2:Enemy = new Enemy(800, 600, 0.75, 0.75, 180,this,1);
			addChild(enemy2);
			enemyClips.push(enemy2);
			
			//Makes the walls
			var wall1:Wall = new Wall(stage.stageWidth/2,60,stage.stageWidth,30);
			var wall3:Wall = new Wall(stage.stageWidth/2,stage.stageHeight-15,stage.stageWidth,30);
			var wall4:Wall = new Wall(stage.stageWidth-14,30+stage.stageHeight/2,30,stage.stageHeight - 60);
			var wall5:Wall = new Wall(300, stage.stageHeight/2+30, 30, 225);
			var wall6:Wall = new Wall(388,282,200,30);
			var wall7:Wall = new Wall(388,477,200,30);
			removeWall = new Wall(500, stage.stageHeight/2+30, 30, 225);
			
			addChild(wall1);
			addChild(wall3);
			addChild(wall4);
			addChild(wall5);
			addChild(wall6);
			addChild(wall7);
			addChild(removeWall);
			
			wallClips.push(wall1);
			wallClips.push(wall3);
			wallClips.push(wall4);
			wallClips.push(wall5);
			wallClips.push(wall6);
			wallClips.push(wall7);
			wallClips.push(removeWall);
		}

		private function initLevel3Cleaner(win:Boolean):void
		{
			fX = 200;
			fY = stage.stageHeight/2 + 30; 
			
			finalScore = new TextField();
			finalScore.defaultTextFormat = format2;
			
			if (win == true)
			{
				finalScore.text = "You Won!";
			}
			else if (win == false)
			{
				finalScore.text = "You Lost.";
			}
			finalScore.x = stage.stageWidth / 2;
			finalScore.y = stage.stageHeight / 2 - 15;
			finalScore.width = 400;
			addChild(finalScore);
			
			//Remove event listeners
			this.removeEventListener(Event.ENTER_FRAME, frameLoop);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyIsDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyIsUp);
			stage.removeEventListener(MouseEvent.CLICK, setPoint);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			for (var i:int = 0; i < bulletClips.length; i++)
			{
				if (this.contains(bulletClips[i]))
				{
					removeChild(bulletClips[i]);
					bulletClips[i].bulletCleaner();
				}
			}

			bulletClips = [];


			for (var w:int = 0; w < wallClips.length; w++)
			{
				removeChild(wallClips[w]);
			}

			wallClips = [];
			
			for (var e:int = 0; e < enemyClips.length; e++)
			{
				if (this.contains(enemyClips[e]))
				{
					removeChild(enemyClips[e]);
					enemyClips[e].enemyCleaner();
				}
			}
			
			enemyClips = [];
			
			removeChild(char);
			char = null;
			
			removeChild(charBody);
			charBody = null;
			
			removeChild(victoryStar);
			victoryStar = null;

			btnRestartLevel = new BtnRestartLevel(50,stage.stageHeight / 2);
			addChild(btnRestartLevel);
			
			btnMainMenu = new BtnMainMenu(50, (stage.stageHeight / 2) + 100);
			addChild(btnMainMenu);
			
			//Add event listeners
			btnRestartLevel.addEventListener(MouseEvent.CLICK,restartLevel3);
			btnMainMenu.addEventListener(MouseEvent.CLICK,initMainMenuClick);
		}
		
		private function restartLevel3(e:MouseEvent):void
		{
			//Remove event listeners
			btnRestartLevel.removeEventListener(MouseEvent.CLICK,restartLevel3);
			btnMainMenu.removeEventListener(MouseEvent.CLICK,initMainMenuClick);
			
			removeChild(btnRestartLevel);
			removeChild(btnMainMenu);
			
			if (finalScore != null)
			{
				removeChild(finalScore);
				finalScore = null;
			}
			
			initLevel3();
		}

		/*-------------------------------------------
		*        		Credits
		* -------------------------------------------*/
		
		private function initCredits():void
		{
			creditsTitle = new TextField();
			creditsText = new TextField();
			btnMainMenu = new BtnMainMenu(75,75);

			creditsTitle.x = 120;
			creditsTitle.y = 150;

			creditsText.x = 120;
			creditsText.y = 200;

			creditsTitle.defaultTextFormat = format2;
			creditsTitle.width = 200;
			
			creditsText.defaultTextFormat = format1;
			creditsText.width = 800;
			creditsText.height = 700;
			creditsText.multiline = true;
			creditsText.wordWrap = true;
			
			creditsTitle.text = "Credits";
			creditsText.text = "Designed and Developed by Will Paul \n\nCapture it! Font by Magique Fonts (Koczman Bálint), http://www.dafont.com/capture-it.font \n\nJura. Font by by Tenbytwenty, http://www.tenbytwenty.com/jura.php \n\nAFV Dingbats. Font by Perry Mason, http://www.dafont.com/afv.font \n\nCardboard Texture. http://www.photos-public-domain.com/2011/01/11/cardboard-texture/";

			addChild(creditsTitle);
			addChild(creditsText);
			addChild(btnMainMenu);
			
			//Add event listener
			btnMainMenu.addEventListener(MouseEvent.CLICK,initCreditsCleaner);
		}
		
		private function initCreditsCleaner(e:MouseEvent):void
		{
			//Remove event listener
			btnMainMenu.removeEventListener(MouseEvent.CLICK,initCreditsCleaner);
			
			removeChild(creditsTitle);
			removeChild(creditsText);
			removeChild(btnMainMenu);
			
			initMainMenu();
		}


		/*-------------------------------------------
		*        FUNCTIONS FOR ALL LEVELS
		* -------------------------------------------*/
		
		private function setPointEventListener(e:TimerEvent):void
		{
			stage.addEventListener(MouseEvent.CLICK, setPoint);
		}

		//Records the coordinates of the users click
		private function setPoint(e:MouseEvent):void
		{
			fX = mouseX; //final x, where the tank is headed towards
			fY = mouseY; //final y
			fR = char.rotation; //final rotation, direction the tank is driving
			oX = char.x; //original x, where the tank is when it started
			oY = char.y; //original y
			
		}

		//On mouse move and while shift is not being held, calls a function that makes the character spin to face the cursor
		private function onMove(e:MouseEvent):void
		{
			if (rotateChar == true)
			{
				char.followCursor(mouseX,mouseY);
			}
		}

		private function frameLoop(e:Event):void
		{
			var saveIndex:int;

			if (textScore != null)
			{
				textScore.text = "Score: " + String(score);
			}

			//Calls a function to move the character and checks for collisions with the walls
			moveChar();
			
			//Calls a function that runs through the array looking for various types of collisions
			bulletCheck();
			
			//Calls a function that checks if the player has reached the star
			victoryCheck();
			
			//Checks to see if enemy can shoot and then fires if possible
			fireEnemyBullet();
			
			//opens the wall on level 3 after all the enemies have been killed
			if (currentLevel == "level_3")
			{
				if (enemyClips.length == 0 && char != null)
				{
					if (removeWall != null)
					{	
						wallClips.splice(6,1);
						removeChild(removeWall);
						removeWall = null;
					}
				}
			}
		}

		
		//moves the tank around based on where the user clicks
		private function moveChar():void
		{
			if (char.x != fX)
			{
				//chacks for wall collisions
				for (var w:int = 0; w<wallClips.length; w++)
				{
					if (charBody.hitTestObject(wallClips[w]) == false)
					{
						char.moveChar(fX,fY,fR,true);
						charBody.moveCharBody(fX,fY,fR,true);
					}
					else
					{
						//Checks for which direction the tank is coming from and what the wall's orientation is, so that it can react properly
						if (wallClips[w].width > wallClips[w].height) //x-axis walls
						{
							if (fY < oY) //if tank comes from the bottom
							{
								charBody.y += wallClips[w].height/2;
								char.y += wallClips[w].height/8;
								fY = wallClips[w].y + (charBody.height);
							}
							else //if tank comes from above
							{
								charBody.y -= wallClips[w].height/2;
								char.y -= wallClips[w].height/8;
								fY = wallClips[w].y - (charBody.height);
							}
						}
						else if (wallClips[w].width < wallClips[w].height) //y-axis walls
						{
							if (fX < oX) //if tank comes from the right
							{
								charBody.x += wallClips[w].width/2;
								char.x += wallClips[w].width/8;
								fX = wallClips[w].x + (charBody.width);
							}
							else //if tank comes from the left
							{
								charBody.x -= wallClips[w].width/2;
								char.x -= wallClips[w].width/8;
								fX = wallClips[w].x - (charBody.width);
							}
						}
					}
				}
			}
		}
		
		private function bulletCheck():void
		{
			//Cycles through the array of bullets checking for collisions
			for (var i:int = 0; i<bulletClips.length; i++)
			{
				//These are used to keep track of the bullet's multiplier temporarily
				var tempMulti:int = 2;
				var tempMultiHit:int;
				
				//Checks for collisions with the TimedTargets
				for (var t:int = 0; t<tTClips.length; t++)
				{
					if (this.contains(bulletClips[i]))
					{
						if (bulletClips[i].hitTestObject(tTClips[t]))
						{
							tempMultiHit = bulletClips[i].getBulletMultiplier();
							tTClips[t].setMultiplier(tempMultiHit);
							tTClips[t].explode();
							removeChild(bulletClips[i]);
							bulletClips[i].bulletCleaner();
						}
					}
				}
				
				//Checks for collisions with the Walls
				for (var w2:int = 0; w2<wallClips.length; w2++)
				{
					if (bulletClips[i].hitTestObject(wallClips[w2]))
					{
						//Checks to see if the bullet has bounced too many times and needs to die
						if (bulletClips[i].getBounces() < 2)
						{
							bulletClips[i].wallOrient(wallClips[w2].width,wallClips[w2].height);
							bulletClips[i].bulletBouncer();
							bulletClips[i].setBulletMultiplier(tempMulti);
							tempMulti ++;
						}
						else
						{
							if (this.contains(bulletClips[i]))
							{
								removeChild(bulletClips[i]);
								bulletClips[i].bulletCleaner();
							}
						}
					}
				}
				
				//Checks to see if the player shoots themselves after the bounce
				if (bulletClips[i].getParent() == "char")
				{
					if (bulletClips[i].hitTestObject(char))
					{
						if (bulletClips[i].getBounces() > 0)
						{
							if (bulletClips[i].getAllowedToKill())
							{
								if (currentLevel == "time_trial")
								{
									timeOfDeath = countDown.currentCount;
									initTimeTrialCleaner();
								}
								else if (currentLevel == "level_1")
								{
									initLevel1Cleaner(false);
								}
								else if (currentLevel == "level_2")
								{
									initLevel2Cleaner(false);
									trace("char");
								}
								else if (currentLevel == "level_3")
								{
									initLevel3Cleaner(false);
								}
							}
						}
					}
					else
					{
						for (var e:int = 0; e < enemyClips.length; e++)
						{
							if (bulletClips[i].hitTestObject(enemyClips[e]))
							{
								if (bulletClips[i].getAllowedToKill())
								{
									if (this.contains(bulletClips[i]))
									{
										enemyClips[e].explode();
										removeChild(bulletClips[i]);
										bulletClips[i].bulletCleaner();
									}
									
									bulletClips[i].setAllowedToKill(false);
								}
							}
						}
					}
				}
				else
				{
					if (bulletClips[i].hitTestObject(char))
					{
						if (currentLevel == "level_1")
						{
							initLevel1Cleaner(false);
						}
						else if (currentLevel == "level_2")
						{
							initLevel2Cleaner(false);
						}
						else if (currentLevel == "level_3")
						{
							initLevel3Cleaner(false);
						}
					}
					else if (bulletClips[i].getBounces() > 0)
					{
						for (var e3:int = 0; e3 < enemyClips.length; e3++)
						{
							if (bulletClips[i].hitTestObject(enemyClips[e3]))
							{
								if (this.contains(bulletClips[i]))
								{	
									enemyClips[e].explode();
									removeChild(bulletClips[i]);
									bulletClips[i].bulletCleaner();
								}
							}
						}
					}
				}

				//checks to see if the bullets are off the stage
				//Buggy, but not as necessary performance-wise with the addition of walls
				/*if (this.contains(bulletClips[i]))
				{
					if (bulletClips[i] != null)
					{
						if (bulletClips[i].bulletBoundaryCheck() == true)
						{
							removeChild(bulletClips[i]);
							bulletClips[i].bulletCleaner();
						}
					}
				}*/
			}
		}
		
		private function victoryCheck():void
		{
			if (victoryStar != null)
			{
				if (charBody.hitTestObject(victoryStar))
				{
					if (currentLevel == "level_1")
					{
						initLevel1Cleaner(true);
					}
					else if (currentLevel == "level_2")
					{
						initLevel2Cleaner(true);
					}
					else if (currentLevel == "level_3")
					{
						initLevel3Cleaner(true);
					}
				}
			}
		}
		
		public function deleteTimedTargets(aTimedTarget:TimedTargets, aScore):void
		{
			var index:int = tTClips.indexOf(aTimedTarget);


			tTClips[index].timedTargetsCleaner();
			removeChild(tTClips[index]);
			tTClips.splice(index,1);


			changeScore(aScore);
		}

		public function deleteBullet(bullet:int):void
		{
			removeChild(bulletClips[bullet]);
			bulletClips[bullet] = null;
			bulletClips.splice(bullet,1);
		}
		
		public function deleteEnemy(enemy:Enemy):void
		{
			var index:int = enemyClips.indexOf(enemy);
			
			enemyClips[index].enemyCleaner();
			removeChild(enemyClips[index]);
			enemyClips.splice(index,1);
		}
		
		public function getCharX():int
		{
			return char.x;
		}
		
		
		public function getCharY():int
		{
			return char.y;
		}


		public function changeScore(amount:int):void
		{
			score +=  amount;
		}

		private function fireEnemyBullet():void
		{
			for (var e2:int = 0; e2 < enemyClips.length; e2++)
			{
				if (enemyClips[e2] != null)
				{
					var enemyX:Number = enemyClips[e2].x;
					var enemyY:Number = enemyClips[e2].y;
					var enemyAngle:Number = enemyClips[e2].rotation + 90;
	
					if (enemyClips[e2].allowedToFire(currentLevel) == true)
					{
						var bullet:Bullet = new Bullet(enemyX,enemyY,enemyAngle,20,"enemy"+String(e2));
	
						addChild(bullet);
						bulletClips.push(bullet);
					}
				}
			}
		}

		private function keyIsDown(e:KeyboardEvent):void
		{
			//Checks for shift to make the character not spin
			if (e.keyCode == Keyboard.SHIFT)
			{
				rotateChar = false;
			}

			//Checks for spacebar to shoot a new bullet
			if (e.keyCode == Keyboard.SPACE)
			{
				var charX:Number = char.x;
				var charY:Number = char.y;
				var charAngle:Number = char.rotation + 90;

				if (char.fireBullet() == true)
				{
					var bullet:Bullet = new Bullet(charX,charY,charAngle,20,"char");

					addChild(bullet);
					bulletClips.push(bullet);
				}
			}
		}

		private function keyIsUp(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.SHIFT)
			{
				rotateChar = true;
			}
		}
	}

}