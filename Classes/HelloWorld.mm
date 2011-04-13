//
//  HelloWorldLayer.m
//  BattleWord
//
//  Created by Jae Kim on 1/18/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "HelloWorld.h"
#import "Cell.h"
#import "OpenFeint.h"
#import "OFHighScoreService.h"
#import "OFMultiplayer.h"
#import "OFMultiplayerService.h"
#import "OFMultiplayerService+Advanced.h"
#import "OpenFeint+Dashboard.h"
#import "OpenFeint+UserOptions.h"
#import "OFMultiplayerGame.h"
#import "GameManager.h"
#import "Dictionary.h"

// HelloWorld implementation
@implementation HelloWorld

NSMutableArray *letterSlots;

int cols = 5;
int rows = 4;
int width = 80;
int height = 60;
int y_offset = 30;

CCLabelTTF *player1Timer;
CCLabelTTF *player2Timer;
CCLabelTTF *wordDefinition;
CCLabelTTF *player1Answer;
CCLabelTTF *player2Answer;
CCLabelTTF *gameTimer;
CCLabelTTF *midDisplay;
CCLabelTTF *currentAnswer;
int playerTurn = 1;
BOOL gameOver = NO;
NSMutableArray* allWords;
NSMutableDictionary *dictionary;
NSMutableArray* wordMatrix;
CCSpriteBatchNode *batchNode;
CCSprite *solveButton1;
CCSprite *solveButton2;
CCSprite *greySolveButton1;
CCSprite *greySolveButton2;
CCSprite *goButton1;
CCSprite *goButton2;
CCSprite *stopButton1;
CCSprite *stopButton2;
NSMutableArray *userSelection;
BOOL player1TileFipped = NO;
BOOL player2TileFipped = NO;
NSMutableDictionary *foundWords;
NSMutableArray *player1Words;
NSMutableArray *player2Words;
CCLabelTTF *player1Score;
CCLabelTTF *player2Score;
BOOL enableTouch = NO;
int countNoTileFlips = 1;
NSMutableArray *specialEffects;
int currentStarPoints = 8;
NSMutableArray *starPoints;
BOOL gameCountdown = NO;
CCLabelTTF *gameCountDownLabel;
CCSprite *gameSummary;
OFMultiplayerGame *myGame;

static inline int cell(int r, int c) {
	return (r * cols + c);
}
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		self.isTouchEnabled = YES;
		
		CGSize windowSize = [[CCDirector sharedDirector] winSize];
		/*
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"txt"];
		NSError *error;
		// read everything from text
		NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
		// first, separate by new line
		GameManager *gm = [GameManager sharedGameManager];
		NSString *fContents = [gm getFileContents];
		allWords = [[fContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] retain];
		*/
		//[self createDictionary];
		allWords = [[Dictionary sharedDictionary] allWords];
		dictionary = [[Dictionary sharedDictionary] dict];
		NSLog(@"dictionary size = %@", [dictionary objectForKey:@"orange"]);
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"WordToo.plist"];
		batchNode = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"WordToo.png"]];
		[self addChild:batchNode];
	
		/*
		gameTimer = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", 200] fontName:@"DBLCDTempBlack" fontSize:37.0f] retain];
		gameTimer.color = ccc3(255,125,125);
		gameTimer.position = ccp(windowSize.width/2, 260);
		[self addChild:gameTimer];
		*/

		player1Score = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", 0] fontName:@"DBLCDTempBlack" fontSize:37] retain];
		player1Score.color = ccc3(0,0,255);
		//player1Score.anchorPoint = ccp(1,0);
		player1Score.position = ccp(440, 220);
		[self addChild:player1Score];
		
		player2Score = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", 0] fontName:@"DBLCDTempBlack" fontSize:37] retain];
		player2Score.color = ccc3(0,0,255);
		//player2Score.anchorPoint = ccp(0,0);
		player2Score.position = ccp(50, 220);
		[self addChild:player2Score];

		CCLabelTTF *score1Label = [CCLabelTTF labelWithString:@"Score:" fontName:@"Verdana" fontSize:18];
		score1Label.color = ccc3(255, 255, 255);
		score1Label.position = ccp(440, 260);
		[self addChild:score1Label];

		CCLabelTTF *score2Label = [CCLabelTTF labelWithString:@"Score:" fontName:@"Verdana" fontSize:18];
		score2Label.color = ccc3(255, 255, 255);
		score2Label.position = ccp(50, 260);
		[self addChild:score2Label];
		
		player1Timer = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", 100] fontName:@"DBLCDTempBlack" fontSize:37] retain];
		player1Timer.color = ccc3(255, 0, 0);
		player1Timer.position = ccp(440, 130);
		[self addChild:player1Timer];

		player2Timer = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", 100] fontName:@"DBLCDTempBlack" fontSize:37] retain];
		player2Timer.color = ccc3(255, 0, 0);
		player2Timer.position = ccp(50, 130);
		[self addChild:player2Timer];
		
		CCLabelTTF *time1Label = [CCLabelTTF labelWithString:@"Time:" fontName:@"Verdana" fontSize:18];
		time1Label.color = ccc3(255, 255, 255);
		time1Label.position = ccp(440, 170);
		[self addChild:time1Label];
		
		CCLabelTTF *time2Label = [CCLabelTTF labelWithString:@"Time:" fontName:@"Verdana" fontSize:18];
		time2Label.color = ccc3(255, 255, 255);
		time2Label.position = ccp(50, 170);
		[self addChild:time2Label];
		
		player1Answer = [[CCLabelTTF labelWithString:@"" fontName:@"Verdana" fontSize:18] retain];
		player1Answer.color = ccc3(255,255,255);
		player1Answer.position = ccp(460, 260);
		player1Answer.anchorPoint = ccp(1,0);
		[self addChild:player1Answer];
		
		player2Answer = [[CCLabelTTF labelWithString:@"" fontName:@"Verdana" fontSize:18] retain];
		player2Answer.color = ccc3(255,255,255);
		player2Answer.position = ccp(20, 260);
		player2Answer.anchorPoint = ccp(0, 0);
		[self addChild:player2Answer];
		
		currentAnswer = [[CCLabelTTF labelWithString:@"Hello" fontName:@"Verdana-Bold" fontSize:24] retain];
		currentAnswer.color = ccc3(255, 255, 255);
		currentAnswer.position = ccp(windowSize.width/2, 260);
		currentAnswer.anchorPoint = ccp(0.5f, 0.5f);
		[self addChild:currentAnswer];
		
		wordMatrix = [[NSMutableArray alloc] init];
		for(int r = 0; r < rows; r++) {
			NSMutableArray *columns = [NSMutableArray array];
			for(int c = 0; c < cols; c++) {
				[columns addObject:[NSString stringWithString:@""]];
			}
			[wordMatrix addObject:columns];
		}
		NSLog(@"wordMatrix = %@", wordMatrix);

		wordDefinition = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"", 10] fontName:@"Verdana" fontSize:14.0f] retain];
		wordDefinition.color = ccc3(255,0,0);
		wordDefinition.position = ccp(80, 50);
		[self addChild:wordDefinition];
		
		solveButton1 = [CCSprite spriteWithSpriteFrameName:@"greenbutton.png"];
		solveButton1.position = ccp(440, 40);
		[self addChild:solveButton1];
		
		solveButton2 = [CCSprite spriteWithSpriteFrameName:@"greenbutton.png"];
		solveButton2.position = ccp(50, 40);
		[self addChild:solveButton2];
		
		greySolveButton1 = [CCSprite spriteWithSpriteFrameName:@"greybutton.png"];
		greySolveButton1.position = ccp(440, 40);
		[self addChild:greySolveButton1];
		
		greySolveButton2 = [CCSprite spriteWithSpriteFrameName:@"greybutton.png"];
		greySolveButton2.position = ccp(50, 40);
		[self addChild:greySolveButton2];
		greySolveButton2.visible = NO;
		
		userSelection = [[NSMutableArray alloc] init];
		
		foundWords = [[NSMutableDictionary dictionary] retain];
		
		player1Words = [[NSMutableArray array] retain];
		player2Words = [[NSMutableArray array] retain];
		
		midDisplay = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"", 10] fontName:@"MarkerFelt-Thin" fontSize:48] retain];
		midDisplay.position = ccp(windowSize.width/2, windowSize.height/2);
		midDisplay.color = ccc3(255, 255, 255);
		[self addChild:midDisplay z:40];
		
		[self createLetterSlots:rows columns:cols firstGame:YES];
		[self schedule:@selector(updateTimer:) interval:1.0f];
		
		specialEffects = [[NSMutableArray array] retain];
		starPoints = [[NSMutableArray array] retain];
		
		gameCountDownLabel = [[CCLabelTTF labelWithString:@"4" fontName:@"MarkerFelt-Wide" fontSize:100] retain];;
		gameCountDownLabel.position = ccp(240, 160);
		gameCountDownLabel.color = ccc3(255, 255, 255);
		gameCountDownLabel.visible = NO;
		[self addChild:gameCountDownLabel z:30];
		
		gameSummary = [CCSprite spriteWithSpriteFrameName:@"blackbackground.png"];
		gameSummary.position = ccp(windowSize.width/2, windowSize.height/2);
		gameSummary.visible = NO;
		[self addChild:gameSummary z:30];
	}
	return self;
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

- (NSString *) convertToAlpha:(int) v {
	if (v == 0) return [NSString stringWithFormat:@"%c", 'A'];
	else if (v == 1) return [NSString stringWithFormat:@"%c", 'B'];
	else if (v == 2) return [NSString stringWithFormat:@"%c", 'C'];
	else if (v == 3) return [NSString stringWithFormat:@"%c", 'D'];
	else if (v == 4) return [NSString stringWithFormat:@"%c", 'E'];
	else if (v == 5) return [NSString stringWithFormat:@"%c", 'F'];
	else if (v == 6) return [NSString stringWithFormat:@"%c", 'G'];
	else if (v == 7) return [NSString stringWithFormat:@"%c", 'H'];
	else if (v == 8) return [NSString stringWithFormat:@"%c", 'I'];
	else if (v == 9) return [NSString stringWithFormat:@"%c", 'J'];
	else if (v == 10) return [NSString stringWithFormat:@"%c", 'K'];
	else if (v == 11) return [NSString stringWithFormat:@"%c", 'L'];
	else if (v == 12) return [NSString stringWithFormat:@"%c", 'M'];
	else if (v == 13) return [NSString stringWithFormat:@"%c", 'N'];
	else if (v == 14) return [NSString stringWithFormat:@"%c", 'O'];
	else if (v == 15) return [NSString stringWithFormat:@"%c", 'P'];
	else if (v == 16) return [NSString stringWithFormat:@"%c", 'Q'];
	else if (v == 17) return [NSString stringWithFormat:@"%c", 'R'];
	else if (v == 18) return [NSString stringWithFormat:@"%c", 'S'];
	else if (v == 19) return [NSString stringWithFormat:@"%c", 'T'];
	else if (v == 20) return [NSString stringWithFormat:@"%c", 'U'];
	else if (v == 21) return [NSString stringWithFormat:@"%c", 'V'];
	else if (v == 22) return [NSString stringWithFormat:@"%c", 'W'];
	else if (v == 23) return [NSString stringWithFormat:@"%c", 'X'];
	else if (v == 24) return [NSString stringWithFormat:@"%c", 'Y'];
	else return [NSString stringWithFormat:@"%c", 'Z'];
}

- (void) openRandomLetters:(int) n {
	int openedLetters = 0;
	
	int closedLetters = 0;
	
	Cell *cell;
	
	for(int r = 0; r < rows; r++) {
		for(int c = 0; c < cols; c++) {
			cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
			if (!cell.letter.visible) {
				closedLetters++;
			}
		}
	}
	
	int maxOpenable = (n <= closedLetters)? n : closedLetters;
	
	NSLog(@"max openable = %i", maxOpenable);
	
	while(openedLetters < maxOpenable) {
		int randomRow = arc4random() % rows;
		int randomCol = arc4random() % cols;
		cell = [[wordMatrix objectAtIndex:randomRow] objectAtIndex:randomCol];
		if (!cell.letter.visible) {
			cell.letter.visible = YES;
			openedLetters++;
			if ([self isThisStarPoint:cell]) {
				NSLog(@"star point set");
				cell.star.visible = YES;
			}
		}
	}
}

- (BOOL) isThisStarPoint:(Cell *) cell {
	for(Cell *c in starPoints) {
		if (c == cell) {
			return TRUE;
		}
	}
	
	return FALSE;
}

- (void) setStarPoints {
	
	if ([starPoints count] > 0) {
		return;
	}
		
	int n = 0;
	
	while (n < currentStarPoints) {
		NSLog(@"setting star points");
		int randomRow = arc4random() % rows;
		int randomCol = arc4random() % cols;
		Cell *cell = [[wordMatrix objectAtIndex:randomRow] objectAtIndex:randomCol];
		
		if (![self isThisStarPoint:cell]) {
			[starPoints addObject:cell];
			n++;
		}
	}
}

- (void) switchTo:(int) player countFlip:(BOOL) flag {
	
	if (flag) {
		if (playerTurn == 1 && !player1TileFipped) {
			countNoTileFlips++;
		} else if (playerTurn == 2 && !player2TileFipped) {
			countNoTileFlips++;
		} else {
			countNoTileFlips = 1;
		}
			
		NSLog(@"CountNoTileFlips = %i", countNoTileFlips);

		if (countNoTileFlips % 5 == 0) {
			countNoTileFlips = 1;
			[self openRandomLetters:1];
		}
	} else {
		countNoTileFlips = 1;
	}
	
		
	[self clearLetters];
	[player1Answer setString:@" "];
	[player2Answer setString:@" "];
	[currentAnswer setString:@" "];
	
	if (player == 1) {
		playerTurn = 1;	
		player1TileFipped = NO;
		greySolveButton1.visible = NO;
		greySolveButton2.visible = YES;
	} else {
		playerTurn = 2;
		player2TileFipped = NO;
		greySolveButton1.visible = YES;
		greySolveButton2.visible = NO;
	}
}

- (void) addScore:(int) point toPlayer:(int) playerId anchorCell:(Cell *) cell {
	NSLog(@"addScore called");
	int currentScore;
	
	if (playerId == 1) {
		currentScore = [[player1Score string] intValue];
	} else {
		currentScore = [[player2Score string] intValue];
	}
	
	currentScore += point;
	
	if (playerId == 1) {
		[player1Score setString:[NSString stringWithFormat:@"%i", currentScore]];
	} else {
		[player2Score setString:[NSString stringWithFormat:@"%i", currentScore]];
	}
	
	CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"+%i", point] fontName:@"Verdana-Bold" fontSize:24];
	scoreLabel.color = ccc3(0, 255, 0);
	scoreLabel.position = ccp(cell.letter.position.x, cell.letter.position.y + 30);
	[self addChild:scoreLabel z:20];
	[scoreLabel runAction:[CCSpawn actions:[CCMoveBy actionWithDuration:1 position:ccp(0, 15)], [CCFadeOut actionWithDuration:1], nil]];
	//[specialEffects addObject:scoreLabel];
}

- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {

	if (!gameOver && !enableTouch) {
		return TRUE;
	}
	
	
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
	
	if (gameOver && CGRectContainsPoint(midDisplay.boundingBox, touchLocation)) {
		int p1 = [[player1Score string] intValue];
		int p2 = [[player2Score string] intValue];
		int highScore = (p1 > p2)? p1 : p2;
		
		//[OFHighScoreService setHighScore:highScore forLeaderboard:@"650204" onSuccess:OFDelegate() onFailure:OFDelegate()];
		//[OpenFeint launchDashboardWithHighscorePage:@"650204"];
		[self startGame];
		gameSummary.visible = NO;
	}
	

	if (playerTurn == 1 && CGRectContainsPoint(solveButton1.boundingBox, touchLocation)) {
		if ([userSelection count] > 0) {
			[self checkAnswer];
			[self switchTo:2 countFlip:NO];
		} else {
			[self switchTo:2 countFlip:YES];
		}
	}
	
	if (playerTurn == 2 && CGRectContainsPoint(solveButton2.boundingBox, touchLocation)) {
		if ([userSelection count] > 0) {
			[self checkAnswer];
			[self switchTo:1 countFlip:NO];
		} else {
			[self switchTo:1 countFlip:YES];
		}
	}
		
	for(int r = 0; r < rows; r++) {
		for(int c = 0; c < cols; c++) {
			Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
			BOOL cellSelected = cell.letterSelected.visible;
			if (CGRectContainsPoint(cell.letterBackground.boundingBox, touchLocation)) {
				if (cell.letter.visible && cellSelected) {
					cell.letterSelected.visible = NO;
					[userSelection removeObject:cell];
					[self updateAnswer];
				} else if (cell.letter.visible && !cellSelected) {
					cell.letterSelected.visible = YES;
					[userSelection addObject:cell];
					[self updateAnswer];
				} else {
					if (playerTurn == 1 && !player1TileFipped) {
						cell.letter.visible = YES;
						player1TileFipped = YES;
						if ([cell.value isEqualToString:@"A"] || 
							[cell.value isEqualToString:@"E"] || 
							[cell.value isEqualToString:@"I"] || 
							[cell.value isEqualToString:@"O"] || 
							[cell.value isEqualToString:@"U"]) {
							[self addScore:8 toPlayer:playerTurn anchorCell:cell];
						}
						if ([self isThisStarPoint:cell]) {
							cell.star.visible = YES;
						}
					} else if (playerTurn == 2 && !player2TileFipped) {
						cell.letter.visible = YES;
						player2TileFipped = YES;
						if ([cell.value isEqualToString:@"A"] || 
							[cell.value isEqualToString:@"E"] || 
							[cell.value isEqualToString:@"I"] || 
							[cell.value isEqualToString:@"O"] || 
							[cell.value isEqualToString:@"U"]) {
							[self addScore:8 toPlayer:playerTurn anchorCell:cell];
						}
						if ([self isThisStarPoint:cell]) {
							cell.star.visible = YES;
						}
					}
				}
			}
		}
	}
		
	return TRUE;
}

- (void) ccTouchEnded:(UITouch *) touch withEvent:(UIEvent *) event {
}
/*
- (void) newGame {
		
	for(int r = 0; r < rows ; r++) {
		for(int c = 0; c < cols; c++) {
			int val = (rand() % (26*3)) % 26;
			CCLabelTTF *label = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
			label.visible = NO;
			[label setString:[self convertToAlpha:val]];
		}
	}
	
	[self startGame];
}
*/
- (void) startGame {
	
	gameOver = NO;
	playerTurn = 1;
	currentStarPoints = 8;
	[foundWords removeAllObjects];
	[starPoints removeAllObjects];
	[player1Timer setString:@"100"];
	[player2Timer setString:@"100"];
	[player1Score setString:@"0"];
	[player2Score setString:@"0"];
	[player1Answer setString:@" "];
	[player2Answer setString:@" "];
	[currentAnswer setString:@" "];
	[midDisplay runAction:[CCFadeOut actionWithDuration:0.1f]];
	[midDisplay setString:@""];
	[self clearAllSelectedLetters];
	[self switchTo:1 countFlip:NO];
	
	for(int r = 0; r < rows ; r++) {
		for(int c = 0; c < cols; c++) {
			Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
			cell.letter.visible = YES;
			if (r != rows - 1 || c != cols - 1) {
				[cell.letter runAction:[CCSequence actions:[CCFadeOut actionWithDuration:3], nil]];
			} else {
				[cell.letter runAction:[CCSequence actions:[CCFadeOut actionWithDuration:3], [CCCallFunc actionWithTarget:self selector:@selector(hideBoard)], nil]];
			}
		}
	}
}
		 
- (void) hideBoard {
	for(int r = 0; r < rows ; r++) {
		for(int c = 0; c < cols; c++) {
			Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
			cell.letter.visible = NO;
			[cell.letter runAction:[CCFadeIn actionWithDuration:0.1f]];
		}
	}
	[self setStarPoints];
	[self openRandomLetters:2];
	gameCountdown = YES;
	enableTouch = YES;
}

- (NSString*) createRandomString  {
	int totalLength = 0;
	NSString *randomString = [NSString string];
	NSLog(@"1. create randomString");
	while(totalLength <= rows * cols) {
		int index = arc4random() % [allWords count];
		NSLog(@"2. createRandomString");
		NSString *newString = [allWords objectAtIndex:index];
		if (newString) {
			NSLog(@"new string = %@", newString);
			randomString = [randomString stringByAppendingString:newString];
		}
		
		totalLength = [randomString length];
	}
	
	return randomString;
}
				 

- (void) createLetterSlots:(int) rows columns:(int) cols firstGame:(BOOL) firstGameFlag{
	
	CCLabelTTF *label;
	Cell *cell;
	NSString *letters = [self createRandomString];
	
	if (letters) {
		NSLog(@"letters = %@", letters);
	}
	
	NSMutableDictionary *usedIdx = [NSMutableDictionary dictionary];
	
	for(int r = 0; r < rows ; r++) {
		for(int c = 0; c < cols; c++) {
			int i = arc4random() % [letters length];
			NSString *key = [[NSNumber numberWithInt:i] stringValue];
			NSLog(@"Key = %@", key);
			while([usedIdx valueForKey:key]) {
				NSLog(@"Already Used Index = %@", key);
				i = arc4random() % [letters length];
				key = [[NSNumber numberWithInt:i] stringValue];
				NSLog(@"Key = %@", key);
			}
			[usedIdx setObject:@"Y" forKey:key];
			NSLog(@"adding character = %@", [NSString stringWithFormat:@"%c", [letters characterAtIndex:i]]);
			
			if (firstGameFlag) {
				label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%c", [letters characterAtIndex:i]] fontName:@"Verdana" fontSize:50.0f];
				label.position = ccp(125 + c * 60, 30 + r * 60);
				label.visible = NO;
				label.color = ccc3(159, 182, 205);
				cell = [[Cell alloc] init];
				cell.letter = label;
				cell.center = label.position;
				cell.value = [label string];
				cell.owner = 0;
				/*
				cell.currentOwner = [CCLabelTTF labelWithString:@"0" fontName:@"Verdana" fontSize:8];
				cell.currentOwner.position = ccp(cell.center.x + 20, cell.center.y - 20);
				cell.currentOwner.color = ccc3(0,255,0);
				cell.currentOwner.visible = YES;
				*/
				[self addChild:cell.letter z:10];
				//[self addChild:cell.currentOwner z:10];
				[label release];
				
				//CCSprite *background = [CCSprite spriteWithTexture:[batchNode texture]];
				CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"red_outlined_box.png"];
				//background.position = ccp(120 + c * 60, 60 + r * 60);
				background.position = cell.letter.position;
				[batchNode addChild:background z:-1];
				cell.letterBackground = background;
				[background release];
				
				CCSprite *selectedBackground = [CCSprite spriteWithSpriteFrameName:@"selectedbackground.png"];
				selectedBackground.position = cell.letter.position;
				selectedBackground.visible = NO;
				[batchNode addChild:selectedBackground z:1];
				cell.letterSelected = selectedBackground;
				[selectedBackground release];

				CCSprite *selectedBackground2 = [CCSprite spriteWithSpriteFrameName:@"blue.png"];
				selectedBackground2.position = cell.letter.position;
				selectedBackground2.visible = NO;
				[batchNode addChild:selectedBackground2 z:-1];
				cell.letterSelected2 = selectedBackground2;
				[selectedBackground2 release];
				
				CCSprite *redBackground = [CCSprite spriteWithSpriteFrameName:@"redbackground_small.png"];
				redBackground.position = cell.letter.position;
				redBackground.visible = NO;
				[batchNode addChild:redBackground z:-1];
				cell.redBackground = redBackground;
				[redBackground release];
				
				CCSprite *star = [CCSprite spriteWithSpriteFrameName:@"star_small.png"];
				star.position = ccp(cell.letter.position.x + 20, cell.letter.position.y - 20);
				star.visible = NO;
				[batchNode addChild:star z:10];
				cell.star = star;
				[star release];
				
				[[wordMatrix objectAtIndex:r] insertObject:cell atIndex:c];
				[cell release];
			} else {
				cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
				cell.letter.visible = NO;
				[cell.letter setString:[NSString stringWithFormat:@"%c", [letters characterAtIndex:i]]];
				cell.value = [NSString stringWithFormat:@"%c", [letters characterAtIndex:i]];
				cell.star.visible = NO;
			}
		}
	}
	
	[self startGame];
}

- (void) clearAllSelectedLetters {
	
	[player1Answer setString:@" "];
	[player2Answer setString:@" "];
	[currentAnswer setString:@" "];

	for(int r = 0; r < rows ; r++) {
		for(int c = 0; c < cols; c++) {
			Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
			cell.letterSelected2.visible = NO;
			cell.redBackground.visible = NO;
			cell.star.visible = NO;
		}
	}
	
	for(Cell *c in userSelection) {
		c.letterSelected.visible = NO;
		c.letterSelected2.visible = NO;
		c.redBackground.visible = NO;
	}
}

- (void) clearLetters {
	for(Cell *c in userSelection) {
		c.letterSelected.visible = NO;
	}
	
	[userSelection removeAllObjects];
}

- (void) updateCellOwnerTo:(int) playerId {
	for (Cell *c in userSelection) {
		c.owner = playerId;
		[c.currentOwner setString:[NSString stringWithFormat:@"%i", playerId]];
		if (playerId == 1) {
			c.redBackground.visible = YES;
			c.letterSelected2.visible = NO;
		} else {
			c.redBackground.visible = NO;
			c.letterSelected2.visible = YES;
		}
	}
}

- (int) countStarPointandRemoveStars {
	int startCount = 0;
	
	for(Cell *c in userSelection) {
		if ([self isThisStarPoint:c]) {
			startCount++;
			[starPoints removeObject:c];
			c.star.visible = NO;
		}
	}
	
	return startCount;
}

- (void) checkAnswer {
	
	[midDisplay setString:@""];
	[midDisplay runAction:[CCFadeIn actionWithDuration:0.1f]];
		
	NSString *s = [NSString string];
	for(Cell *c in userSelection) {
		s = [s stringByAppendingString:c.value];
		c.letterSelected.visible = NO;
	}
	
	NSLog(@"user selection = %@", s);
	
	if ([foundWords objectForKey:s]) {
		[midDisplay setString:@"Already Used"];
	} else {
		if ([s length] >= 3 && [dictionary objectForKey:s]) {
			[foundWords setObject:s forKey:s];
			//[midDisplay setString:@"Correct"];
			int starCount = [self countStarPointandRemoveStars];
			int newPoint = pow(2, [s length]) + starCount * 10;
			[self addScore:newPoint toPlayer:playerTurn anchorCell: [userSelection objectAtIndex:0]];
		} else {
			[midDisplay setString:@"Try again"];
		}
	}
	[midDisplay runAction:[CCFadeOut actionWithDuration:1]];
	[userSelection removeAllObjects];
}

- (void) updateAnswer {
	
	NSString *s = [NSString string];
	for(Cell *c in userSelection) {
		s = [s stringByAppendingString:c.value];
	}
	/*
	if (playerTurn == 1) {		
		[player1Answer setString:s];
	} else {
		[player2Answer setString:s];
	}
	*/
	[currentAnswer setString:s];
}

- (void) updateTimer:(ccTime) dt {
	int p1 = [[player1Timer string] intValue];
	int p2 = [[player2Timer string] intValue];
	
	BOOL play1Done = NO;
	BOOL play2Done = NO;
	
	if (gameCountdown) {
		CCLOG(@"gameCountdown start");
		NSString *status = [gameCountDownLabel string];
		gameCountDownLabel.visible = YES;
		if ([status isEqualToString:@"Go!"]) {
			gameCountdown = NO;
			gameCountDownLabel.visible = NO;
		} else {
			int x = [status intValue];
			if (x > 1) {
				[gameCountDownLabel setString:[NSString stringWithFormat:@"%i", --x]];
			} else {
				[gameCountDownLabel	setString:@"Go!"];
			}
			return;
		}
	}
	
	if (!enableTouch) {
		return;
	}
	
	if (p1+p2 <= 0) {
		gameOver = YES;
	}
	
	if (p1 <= 0) {
		play1Done = YES;
	}
	
	if (p2 <= 0) {
		play2Done = YES;
	}
	
	if (gameOver) {
		enableTouch = NO;
		int p1score = [[player1Score string] intValue];
		int p2score = [[player2Score string] intValue];
		if (p1score > p2score) {
			[midDisplay setString:@"Player 1 Wins"];
		} else if (p1score < p2score) {
			[midDisplay setString:@"Player 2 Wins"];
		} else {
			[midDisplay setString:@"Tie Game"];
		}
		[midDisplay runAction:[CCFadeIn actionWithDuration:1]];
		gameSummary.visible = YES;
	} else {
		if (playerTurn == 1) {
			if (!play1Done) {
				--p1;
				[player1Timer setString:[NSString stringWithFormat:@"%i", p1]];
			} else {
				playerTurn = 2;
				[self switchTo:playerTurn countFlip:NO];
			}
		} else {
			if (!play2Done) {
				--p2;
				[player2Timer setString:[NSString stringWithFormat:@"%i", p2]];
			} else {
				playerTurn = 1;
				[self switchTo:playerTurn countFlip:NO];
			}
		}
	}	
}

/*
- (void) draw {
	glEnable(GL_LINE_SMOOTH);
	glColor4ub(255, 0, 255, 255);
	glLineWidth(2);
	CGPoint vertices2[] = { ccp(79,299), ccp(134,299), ccp(134,229), ccp(79,229) };
	NSLog(@"draw point");
	
	for(int r = 0; r < rows; r++) {
		for(int c = 0; c < cols; c++) {
			CCLabelTTF *l = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
			CGPoint p0 = [l boundingBox].origin;
			NSLog(@"point = %f", p0.x);
		}
	}
	
	ccDrawPoly(vertices2, 4, YES);
	[super draw];
}
*/

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[userSelection release];
	[super dealloc];
}

- (void) createDictionary {
	dictionary = [[NSMutableDictionary alloc] init];
	for(NSString *s in allWords) {
		if (s) {
			[dictionary setObject:s forKey:s];
		}
	}
}

- (void) onEnter {
	[super onEnter];
	/*
	adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
	adView.delegate = self;
	adView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
	adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
	[[[CCDirector sharedDirector] openGLView] addSubview:adView];
	//CGSize windowSize = [[CCDirector sharedDirector] winSize];
	adView.center = CGPointMake(adView.frame.size.width/2, adView.frame.size.height/2);
	adView.hidden = YES;
	*/
}

- (void) onExit {
	adView.delegate = nil;
	[adView removeFromSuperview];
	[adView release];
	adView = nil;
	[super onExit];
}

- (void) bannerViewDidLoadAd:(ADBannerView *)banner {
	adView.hidden = NO;
}

- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	adView.hidden = YES;
}

- (void) bannerViewActionDidFinish:(ADBannerView *)banner {
	NSLog(@"bannerViewActionDidFinish called");
	[[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation) [[CCDirector sharedDirector] deviceOrientation]];
}

- (BOOL) bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
	NSLog(@"bannerViewActionShouldBegin called");
	return YES;
}

#pragma mark OpenFeintDelegate

- (void)dashboardWillAppear {
}

- (void)dashboardDidAppear {
	[[CCDirector sharedDirector] pause];
	[[CCDirector sharedDirector] stopAnimation];
}

- (void)dashboardWillDisappear {
}

- (void)dashboardDidDisappear {
	[[CCDirector sharedDirector] resume];
	[[CCDirector sharedDirector] startAnimation];
}

- (void)userLoggedIn:(NSString*)userId {
	OFLog(@"New user logged in! Hello %@", [OpenFeint lastLoggedInUserName]);
	//not a typo: force any existing user to logout so it will reconnect with the new one
	[OFMultiplayerService internalLogout];
}

- (BOOL)showCustomOpenFeintApprovalScreen {
	return NO;
}

#pragma mark OFMultiplayerDelegate

//these are only required since the sample isn't using OpenGL and has to be manually updated
-(void) gameDidFinish:(OFMultiplayerGame *)game {
    //[[MPClassRegistry gameController] refreshView];
}

-(void) playerLeftGame:(unsigned int)playerNumber {
    //[[MPClassRegistry gameController] refreshView];
}

- (void)networkDidUpdateLobby {
    if([OFMultiplayerService getNumberOfChallenges]) {
        OFLog(@"Outstanding challenges %d", [OFMultiplayerService getNumberOfChallenges]);
		//        for(int i=0; i<[OFMultiplayerService getNumberOfChallenges]; ++i) {
		//            OFMultiplayerGame *game = [OFMultiplayerService getChallengeAtIndex:i];
		//            //this functionality does not exist yet
		//            [game sendChallengeResponseWithAccept:YES];
		//        }
    }
    //[[MPClassRegistry lobbyController] refillList];
}

-(void) networkFailureWithReason:(NSUInteger)reason {
    
}

//there are two methods of processing moves, either use the delegate or scan for moves in the game's tick
//see MPGameController.mm processNetMove to see the two options
-(BOOL)gameMoveReceived:(OFMultiplayerMove *)move {
#ifdef DELEGATE_MOVE_MODE
	//[[MPClassRegistry gameController] processNetMove:move];
    return YES;
#endif
    return NO;    
}


-(void) handlePushRequestGame:(OFMultiplayerGame*)game options:(NSDictionary*) options {
    //const NSSet* gameLaunchTypes = [NSSet setWithObjects:@"accept", @"start", @"finish", @"turn", nil];
    //const NSSet* gameLobbyTypes = [NSSet setWithObjects:@"challenge", nil];
	/*
	 if([gameLaunchTypes containsObject:[options objectForKey:@"type"]]) 
	 [MPClassRegistry showGameControllerWithGame:game];
	 else if([gameLobbyTypes containsObject:[options objectForKey:@"type"]]) {
	 
	 [MPClassRegistry showLobbyForSlot:game.gameSlot];
	 }
	 */
    
}

-(void) gameLaunchedFromPushRequest:(OFMultiplayerGame*)game withOptions:(NSDictionary*) options
{
    OFLog(@"This is where we would launch game for slot %d type %s", game.gameSlot, [options objectForKey:@"type"]);
    [self handlePushRequestGame:game options:options];
}


-(void) gameRequestedFromPushRequest:(OFMultiplayerGame*)game withOptions:(NSDictionary*) options
{
    OFLog(@"Testing push notification response for slot %d type %s", game.gameSlot, [options objectForKey:@"type"]);
    [self handlePushRequestGame:game options:options];
}

@end
