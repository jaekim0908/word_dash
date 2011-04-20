//
//  HelloWorldLayer.m
//  BattleWord
//
//  Created by Jae Kim on 1/18/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "Multiplayer.h"
#import "Cell.h"
#import "OpenFeint.h"
#import "OFHighScoreService.h"
#import "OFMultiplayerService.h"
#import "OFMultiplayerService+Advanced.h"
#import "OpenFeint+Dashboard.h"
#import "OpenFeint+UserOptions.h"
#import "OFMultiplayerMove.h"
#import "Dictionary.h"
#import "GameManager.h"
#import "ResultsLayer.h"

// HelloWorld implementation
@implementation Multiplayer

@synthesize rows;
@synthesize cols;
@synthesize thisGame;
@synthesize isThisPlayerChallenger;


+ (id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Multiplayer	*layer = [Multiplayer node];
	[scene addChild:layer z:0 tag:0];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		OFMultiplayerGame *game = [OFMultiplayerService getSlot:0];
		self.isThisPlayerChallenger = NO;
		CCLOG(@"****************LOCAL USER ID = %@", [[OpenFeint localUser] resourceId]);
		CCLOG(@"****************PLAYER 0 ID = %@", [[game playerOFUserIds] objectAtIndex:0]);
		CCLOG(@"****************CHALLENGER ID = %@", [game challengerOFUserId]);
		
		if ([[[OpenFeint localUser] resourceId] isEqualToString:[[game playerOFUserIds] objectAtIndex:0]]) {
			CCLOG(@"****************THIS PLAYER IS A CHALLENGER");
			isThisPlayerChallenger = YES;
		}
		
		cols = 5;
		rows = 4;
		width = 80;
		height = 60;
		y_offset = 30;
		playerTurn = 1;
		gameOver = NO;
		player1TileFipped = NO;
		player2TileFipped = NO;
		enableTouch = NO;
		countNoTileFlips = 1;
		currentStarPoints = 8;
		gameCountdown = NO;
		
		self.isTouchEnabled = YES;
		
		CGSize windowSize = [[CCDirector sharedDirector] winSize];
		
		/*
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"txt"];
		NSError *error;
		// read everything from text
		NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
		// first, separate by new line
		allWords = [[fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] retain];
		*/
		allWords = [[Dictionary sharedDictionary] allWords];
		dictionary = [[Dictionary sharedDictionary] dict];
		//[self createDictionary];
		CCLOG(@"dictionary size = %@", [dictionary objectForKey:@"orange"]);
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"WordToo.plist"];
		batchNode = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"WordToo.png"]];
		[self addChild:batchNode];
		
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
		CCLOG(@"wordMatrix = %@", wordMatrix);
		
		wordDefinition = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"", 10] fontName:@"Verdana" fontSize:14.0f] retain];
		wordDefinition.color = ccc3(255,0,0);
		wordDefinition.position = ccp(80, 50);
		[self addChild:wordDefinition];
		
		solveButton1 = [CCSprite spriteWithSpriteFrameName:@"greenbutton.png"];
		solveButton1.position = ccp(440, 40);
		[self addChild:solveButton1];
		
		solveButton2 = [CCSprite spriteWithSpriteFrameName:@"greenbutton.png"];
		solveButton2.position = ccp(50, 40);
		//[self addChild:solveButton2];
		
		greySolveButton1 = [CCSprite spriteWithSpriteFrameName:@"greybutton.png"];
		greySolveButton1.position = ccp(440, 40);
		[self addChild:greySolveButton1];
		
		greySolveButton2 = [CCSprite spriteWithSpriteFrameName:@"greybutton.png"];
		greySolveButton2.position = ccp(50, 40);
		//[self addChild:greySolveButton2];
		greySolveButton2.visible = NO;
		
		userSelection = [[NSMutableArray alloc] init];
		
		foundWords = [[NSMutableDictionary dictionary] retain];
		
		player1Words = [[NSMutableArray array] retain];
		player2Words = [[NSMutableArray array] retain];
		
		midDisplay = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"", 10] fontName:@"MarkerFelt-Thin" fontSize:48] retain];
		midDisplay.position = ccp(240, 160);
		midDisplay.color = ccc3(255, 255, 255);
		[self addChild:midDisplay z:40];
		[self createLetterSlots:rows columns:cols firstGame:YES];
		//[self schedule:@selector(updateTimer:) interval:1.0f];
		
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
		
		CCSprite *backGround = [CCSprite spriteWithSpriteFrameName:@"footprints-beach.png"];
		backGround.position = ccp(windowSize.width/2, windowSize.height/2);
		[batchNode addChild:backGround z:-10];
	}
	return self;
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
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
	
	CCLOG(@"max openable = %i", maxOpenable);
	
	while(openedLetters < maxOpenable) {
		int randomRow = arc4random() % rows;
		int randomCol = arc4random() % cols;
		cell = [[wordMatrix objectAtIndex:randomRow] objectAtIndex:randomCol];
		if (!cell.letter.visible) {
			[self sendMove:@"TILE_FLIP" rowNum:randomRow colNum:randomCol value:@"Y" endTurn:NO];
			cell.letter.visible = YES;
			openedLetters++;
			if ([self isThisStarPoint:cell]) {
				CCLOG(@"star point set");
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
		
	[self sendMove:@"INIT_STAR_POINT" rowNum:0 colNum:0 value:@"" endTurn:NO];
	
	if ([starPoints count] > 0) {
		return;
	}
	
	int n = 0;
	
	while (n < currentStarPoints) {
		CCLOG(@"setting star points");
		int randomRow = arc4random() % rows;
		int randomCol = arc4random() % cols;
		Cell *cell = [[wordMatrix objectAtIndex:randomRow] objectAtIndex:randomCol];
		
		if (![self isThisStarPoint:cell]) {
			if (isThisPlayerChallenger) {
				[self sendMove:@"STAR_POINT" rowNum:randomRow colNum:randomCol value:@"Y" endTurn:NO];
			}
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
		
		CCLOG(@"CountNoTileFlips = %i", countNoTileFlips);
		
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
	//[currentAnswer setString:@" "];
	
	if ([OFMultiplayerService isItMyTurn]) {
		CCLOG(@"---------MY TURN IN SWITCH_TO---------");
		playerTurn = 1;	
		player1TileFipped = NO;
		greySolveButton1.visible = NO;
		CCLOG(@"*********MY TURN IN SWITCH_TO*********");
	} else {
		CCLOG(@"---------NOT MY TURN IN SWITCH_TO---------");
		greySolveButton1.visible = YES;
		CCLOG(@"*********NOT MY TURN IN SWITCH_TO*********");
	}
}

- (void) addScore:(int) point toPlayer:(int) playerId anchorCell:(Cell *) cell {
	CCLOG(@"addScore called");
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
}

- (void) addMoreTime:(int) timeInSeconds toPlayer:(int) playerId {
	CCLOG(@"addMoreTime called");
	
	if (timeInSeconds <= 0) return;
	
	int currentTimer;
	
	if (playerId == 1) {
		currentTimer = [[player1Timer string] intValue];
	} else {
		currentTimer = [[player2Timer string] intValue];
	}
	
	currentTimer += timeInSeconds;
	
	CCLabelTTF *timerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"+%i", timeInSeconds] fontName:@"DBLCDTempBlack" fontSize:24];
	timerLabel.color = ccc3(0, 255, 0);
	
	if (playerId == 1) {
		[player1Timer setString:[NSString stringWithFormat:@"%i", currentTimer]];
		timerLabel.position = ccp(player1Timer.position.x, player1Timer.position.y + 30);
	} else {
		[player2Timer setString:[NSString stringWithFormat:@"%i", currentTimer]];
		timerLabel.position = ccp(player2Timer.position.x, player1Timer.position.y + 30);
	}
	
	[self addChild:timerLabel z:20];
	//TODO: Garbage collect timerLabel
	[timerLabel runAction:[CCSpawn actions:[CCMoveBy actionWithDuration:1 position:ccp(0, 15)], [CCFadeOut actionWithDuration:1], nil]];
}

- (void) sendInitMoveRow:(int) r Col:(int) c value:(NSString *) val visible:(BOOL) isVisible starPoint:(BOOL) isThisStar endTurn:(BOOL) turn {
	NSString *sendString = [NSString stringWithFormat:@"INIT_MATRIX|%i|%i|%@|%i|%i", r, c, val, isVisible, isThisStar];
	NSData *sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	OFMultiplayerGame *game = [OFMultiplayerService getSlot:0];
	if ([OFMultiplayerService isReadyToSendMoves]) {
		CCLOG(@"READY TO SEND INIT MOVES");
		if (turn) {
			[game sendMove:sendData];
			[game sendEndTurn];
			[self switchTo:1 countFlip:NO];
		} else {
			[game sendMove:sendData];
		}
	} else {
		CCLOG(@"NOT READY TO SEND INIT MOVES");
	}
	
}

- (void) sendMove:(NSString *) moveType rowNum:(int) r colNum:(int) c value:(NSString *) val endTurn:(BOOL) turn {
	NSString *sendString = [NSString stringWithFormat:@"%@|%i|%i|%@", moveType, r, c, val];
	NSData *sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	OFMultiplayerGame *game = [OFMultiplayerService getSlot:0];
	if ([OFMultiplayerService isReadyToSendMoves]) {
		CCLOG(@"READY TO SEND MOVES");
		if (turn) {
			[game sendMove:sendData];
			[game sendEndTurn];
			[self switchTo:1 countFlip:NO];
		} else {
			[game sendMove:sendData];
		}
	} else {
		CCLOG(@"NOT READY TO SEND MOVES");
	}
}

- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {
		
	if (gameOver || !enableTouch) {
		return TRUE;
	}
	
	BOOL myTurn = [OFMultiplayerService isItMyTurn];
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
	
	if (gameOver && CGRectContainsPoint(midDisplay.boundingBox, touchLocation)) {
		int p1 = [[player1Score string] intValue];
		int p2 = [[player2Score string] intValue];
		int highScore = (p1 > p2)? p1 : p2;
		
		[OFHighScoreService setHighScore:highScore forLeaderboard:@"650204" onSuccess:OFDelegate() onFailure:OFDelegate()];
		[OpenFeint launchDashboardWithHighscorePage:@"650204"];
	}
	
	if (!myTurn) {
		[self switchTo:1 countFlip:NO];
		return TRUE;
	}
	
	if (myTurn && playerTurn == 1 && CGRectContainsPoint(solveButton1.boundingBox, touchLocation)) {
		CCLOG(@"SOLVE BUTTON TOUCHED");
		if ([userSelection count] > 0) {
			[self checkAnswer];
			[self switchTo:1 countFlip:NO];
			[self sendMove:@"SOLVE_COUNTFLIP_NO" rowNum:0 colNum:0 value:@"" endTurn:YES];
		} else {
			[self switchTo:1 countFlip:YES];
			[self sendMove:@"SOLVE_COUNTFLIP_YES" rowNum:0 colNum:0 value:@"" endTurn:YES];
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
					[self sendMove:@"DESELECT_TILE" rowNum:r colNum:c value:@"" endTurn:NO];
				} else if (cell.letter.visible && !cellSelected) {
					cell.letterSelected.visible = YES;
					[userSelection addObject:cell];
					[self updateAnswer];
					[self sendMove:@"SELECT_TILE" rowNum:r colNum:c value:@"" endTurn:NO];
				} else {
					if (myTurn && playerTurn == 1 && !player1TileFipped) {
						[self sendMove:@"TILE_FLIP" rowNum:r colNum:c value:@"" endTurn:NO];
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
					} else if (myTurn && playerTurn == 2 && !player2TileFipped) {
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

#pragma mark Remote Methods
- (void) setCellRow:(int) r Col:(int) c withValue:(NSString *) val {
	Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
	cell.value = val;
	[cell.letter setString:val];
}

- (void) tileFlipRow:(int) r Col:(int) c {
	Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
	cell.letter.visible = YES;
	if ([cell.value isEqualToString:@"A"] || 
		[cell.value isEqualToString:@"E"] || 
		[cell.value isEqualToString:@"I"] || 
		[cell.value isEqualToString:@"O"] || 
		[cell.value isEqualToString:@"U"]) {
		[self addScore:8 toPlayer:2 anchorCell:cell];
	}
	if ([self isThisStarPoint:cell]) {
		cell.star.visible = YES;
	}
}

- (void) scheduleUpdateTimer {
	[self schedule:@selector(updateTimer:) interval:1.0f];
	
	if (isThisPlayerChallenger) {
		[self sendMove:@"START_GAME" rowNum:0 colNum:0 value:@"" endTurn:NO];
	} 
}

- (void) selectCellRow:(int) r Col:(int) c {
	Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
	cell.letterSelected.visible = YES;
	[userSelection addObject:cell];
	[self updateAnswer];
}

- (void) deselectCellRow:(int) r Col:(int) c {
	Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
	cell.letterSelected.visible = NO;
	[userSelection removeObject:cell];
	[self updateAnswer];
}

- (void) clearStarPoints {
	[starPoints removeAllObjects];
}

- (void) setSPRow:(int) r Col:(int) c {
	Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
	[starPoints addObject:cell];
}

- (void) setTimer:(NSString *) t {
	[player2Timer setString:t];
}

- (void) ccTouchEnded:(UITouch *) touch withEvent:(UIEvent *) event {
}

- (void) startGame {
	
	gameOver = NO;
	playerTurn = 1;
	currentStarPoints = 8;
	[foundWords removeAllObjects];
	[starPoints removeAllObjects];
	[player1Timer setString:@"15"];
	[player2Timer setString:@"15"];
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
	
	if (isThisPlayerChallenger) {
		[self setStarPoints];
		[self openRandomLetters:2];
	}
	gameCountdown = YES;
	enableTouch = YES;
}

- (NSString*) createRandomString {
	int totalLength = 0;
	NSString *randomString = [NSString string];
	CCLOG(@"1. create randomString");
	while(totalLength <= rows * cols) {
		int index = arc4random() % [allWords count];
		CCLOG(@"2. createRandomString");
		NSString *newString = [allWords objectAtIndex:index];
		if (newString) {
			CCLOG(@"new string = %@", newString);
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
		CCLOG(@"letters = %@", letters);
	}
	
	NSMutableDictionary *usedIdx = [NSMutableDictionary dictionary];
	
	for(int r = 0; r < self.rows ; r++) {
		for(int c = 0; c < self.cols; c++) {
			int i = arc4random() % [letters length];
			NSString *key = [[NSNumber numberWithInt:i] stringValue];
			CCLOG(@"Key = %@", key);
			while([usedIdx valueForKey:key]) {
				CCLOG(@"Already Used Index = %@", key);
				i = arc4random() % [letters length];
				key = [[NSNumber numberWithInt:i] stringValue];
				CCLOG(@"Key = %@", key);
			}
			[usedIdx setObject:@"Y" forKey:key];
			CCLOG(@"adding character = %@", [NSString stringWithFormat:@"%c", [letters characterAtIndex:i]]);
			
			if (firstGameFlag) {
				CCLOG(@"row = %i | col = %i", r, c);
				if (self.isThisPlayerChallenger) {
					[self sendInitMoveRow:r Col:c value:[NSString stringWithFormat:@"%c", [letters characterAtIndex:i]] visible:NO starPoint:NO endTurn:NO];
				}
				label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%c", [letters characterAtIndex:i]] fontName:@"Verdana" fontSize:50.0f];
				label.position = ccp(125 + c * 60, 30 + r * 60);
				label.visible = NO;
				label.color = ccc3(159, 182, 205);
				cell = [[Cell alloc] init];
				cell.letter = label;
				cell.center = label.position;
				cell.value = [label string];
				cell.owner = 0;
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
				if (isThisPlayerChallenger) {
					[self sendInitMoveRow:r Col:c value:[NSString stringWithFormat:@"%c", [letters characterAtIndex:i]] visible:NO starPoint:NO endTurn:NO];
				}
			}
		}
	}
	
	if (isThisPlayerChallenger) {
		[self sendMove:@"INIT_END" rowNum:0 colNum:0 value:@"" endTurn:NO];
		[self scheduleUpdateTimer];
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
	
	CCLOG(@"user selection = %@", s);
	
	if ([foundWords objectForKey:s]) {
		[midDisplay setString:@"Already Used"];
	} else {
		if ([s length] >= 3 && [dictionary objectForKey:s]) {
			[foundWords setObject:s forKey:s];
			if ([OFMultiplayerService isItMyTurn]) {
				CCLOG(@"word added to player 1 words list");
				[player1Words addObject:s];
			} else {
				CCLOG(@"word added to player 2 words list");
				[player2Words addObject:s];
			}
			int starCount = [self countStarPointandRemoveStars];
			int newPoint = pow(2, [s length]);
		
			if ([OFMultiplayerService isItMyTurn]) {
				[self addScore:newPoint toPlayer:1 anchorCell: [userSelection objectAtIndex:0]];
				[self addMoreTime:(starCount * 10) toPlayer:1];
			} else {
				[self addScore:newPoint toPlayer:2 anchorCell: [userSelection objectAtIndex:0]];
				[self addMoreTime:(starCount * 10) toPlayer:2];
			}
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

	[currentAnswer setString:s];
}

- (void) updateTimer:(ccTime) dt {
	
	CCLOG(@"updateTimer called");
	OFMultiplayerGame *game = [OFMultiplayerService getSlot:0];
	CCLOG(@"game id in updateTimer = %i", game.gameId);
	
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
			enableTouch = YES;
		} else {
			enableTouch = NO;
			int x = [status intValue];
			if (x > 1) {
				[gameCountDownLabel setString:[NSString stringWithFormat:@"%i", --x]];
			} else {
				[gameCountDownLabel	setString:@"Go!"];
			}
			return;
		}
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
		[self unscheduleAllSelectors];
		CCLOG(@"game over");
		enableTouch = NO;
		int p1score = [[player1Score string] intValue];
		int p2score = [[player2Score string] intValue];
		NSNumber* winner;
		NSNumber* loser;
		CCLOG(@"game over check point #0");
		OFMultiplayerGame *game = [OFMultiplayerService getSlot:0];
		CCLOG(@"game object = %@", game);
		CCLOG(@"game player arrays = %@", [game playerOFUserIds]);
		CCLOG(@"game over check point #1");

		if (p1score > p2score) {
			CCLOG(@"player 1 wins #1");
			[midDisplay setString:@"Player 1 Wins"];
			winner = [NSNumber numberWithUnsignedInt:1];
			loser  = [NSNumber numberWithUnsignedInt:0];
			CCLOG(@"player 1 wins #2");
		} else if (p1score < p2score) {
			CCLOG(@"player 2 wins #1");
			[midDisplay setString:@"Player 2 Wins"];
			winner = [NSNumber numberWithUnsignedInt:0];
			loser  = [NSNumber numberWithUnsignedInt:1];
			CCLOG(@"player 2 wins #2");
		} else {
			CCLOG(@"tie #1");
			//TODO: tie game logic
			[midDisplay setString:@"Tie Game"];
			winner = [NSNumber numberWithUnsignedInt:0];
			loser  = [NSNumber numberWithUnsignedInt:0];
			CCLOG(@"tie #2");
		}
		
		CCLOG(@"game over check point #2");
		[midDisplay runAction:[CCFadeIn actionWithDuration:1]];
		CCLOG(@"game over check point #3");
		//gameSummary.visible = YES;
		CCLOG(@"game over check point #4");
		//[OFMultiplayerService finishGameWithPlayerRanks:[NSArray arrayWithObjects:winner, loser, nil]];
		CCLOG(@"game over check point #5");
		ResultsLayer *rl = [[[ResultsLayer alloc] initWithPlayerOneScore:[player1Score string] 
													  WithPlayerTwoScore:[player2Score string] 
													  WithPlayerOneWords:player1Words 
													  WithPlayerTwoWords:player2Words] 
							autorelease];
		 [[[CCDirector sharedDirector] runningScene] addChild:rl 
															z:3];
		//[[GameManager sharedGameManager] runSceneWithId:kMainMenuScene];
	} else {
		if ([OFMultiplayerService isItMyTurn]) {
			if (!play1Done) {
				--p1;
				[player1Timer setString:[NSString stringWithFormat:@"%i", p1]];
				[self sendMove:@"TIMER_COUNTDOWN" rowNum:0 colNum:0 value:[NSString stringWithFormat:@"%i", p1] endTurn:NO];
			} else {
				[self sendMove:@"NO_TIME_LEFT" rowNum:0 colNum:0 value:@"" endTurn:YES];
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
 CCLOG(@"draw point");
 
 for(int r = 0; r < rows; r++) {
 for(int c = 0; c < cols; c++) {
 CCLabelTTF *l = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
 CGPoint p0 = [l boundingBox].origin;
 CCLOG(@"point = %f", p0.x);
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
	CCLOG(@"bannerViewActionDidFinish called");
	[[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation) [[CCDirector sharedDirector] deviceOrientation]];
}

- (BOOL) bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
	CCLOG(@"bannerViewActionShouldBegin called");
	return YES;
}

@end
