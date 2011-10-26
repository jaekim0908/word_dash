//
//  SinglePlayer.mm
//  WordDash
//
//  Created by Jae Kim on 1/18/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "SinglePlayer.h"
#import "Cell.h"
#import "OpenFeint.h"
#import "OFHighScoreService.h"
#import "OFMultiplayerService.h"
#import "OFMultiplayerService+Advanced.h"
#import "OFAchievement.h"
#import "OFAchievementService.h"
#import "OpenFeint+Dashboard.h"
#import "OpenFeint+UserOptions.h"
#import "OFMultiplayerMove.h"
#import "Dictionary.h"
#import "GameManager.h"
#import "ResultsLayer.h"
#import "PauseLayer.h"
#import "SimpleAudioEngine.h"
#import "AIDictionary.h"

@implementation SinglePlayer

@synthesize rows;
@synthesize cols;
@synthesize thisGame;
@synthesize isThisPlayerChallenger;
@synthesize numPauseRequests;
@synthesize soundEngine;
@synthesize initOpponentOutOfTime;


+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SinglePlayer *layer = [SinglePlayer node];
	
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
		gameCountdown = YES;
        initOpponentOutOfTime = NO;
        
		self.isTouchEnabled = YES;
        
		allWords = [[Dictionary sharedDictionary] allWords];
		dictionary = [[Dictionary sharedDictionary] dict];
        
        aiAllWords = [[AIDictionary sharedDictionary] allWords];
                
        // Retina Display Support
        if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ImageAssets-hd.plist"];
            batchNode = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"ImageAssets-hd.png"]];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ImageAssets2-hd.plist"];
            batchNode2 = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"ImageAssets2-hd.png"]]; 
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ImageAssets.plist"];
            batchNode = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"ImageAssets.png"]];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ImageAssets2.plist"];
            batchNode2 = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"ImageAssets2.png"]];
        }
        
        [self addChild:batchNode];
        [self addChild:batchNode2];
        
		player1Score = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", 0] fontName:@"DBLCDTempBlack" fontSize:28] retain];
		player1Score.color = ccc3(0,0,255);
		player1Score.position = ccp(440, 190);
		[self addChild:player1Score];
		
		player2Score = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", 0] fontName:@"DBLCDTempBlack" fontSize:28] retain];
		player2Score.color = ccc3(0,0,255);
		player2Score.position = ccp(50, 190);
		[self addChild:player2Score];
        
		CCLabelTTF *score1Label = [CCLabelTTF labelWithString:@"Score" fontName:@"Verdana" fontSize:14];
		score1Label.color = ccc3(0, 0, 0);
		score1Label.position = ccp(440, 220);
		[self addChild:score1Label];
        
		CCLabelTTF *score2Label = [CCLabelTTF labelWithString:@"Score" fontName:@"Verdana" fontSize:14];
		score2Label.color = ccc3(0, 0, 0);
		score2Label.position = ccp(50, 220);
		[self addChild:score2Label];
		
		player1Timer = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", 100] fontName:@"DBLCDTempBlack" fontSize:28] retain];
		player1Timer.color = ccc3(255, 0, 0);
		player1Timer.position = ccp(440, 250);
		[self addChild:player1Timer];
        
		player2Timer = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", 100] fontName:@"DBLCDTempBlack" fontSize:28] retain];
		player2Timer.color = ccc3(255, 0, 0);
		player2Timer.position = ccp(50, 250);
		[self addChild:player2Timer];
		
		CCLabelTTF *time1Label = [CCLabelTTF labelWithString:@"Time" fontName:@"Verdana" fontSize:14];
		time1Label.color = ccc3(0, 0, 0);
		time1Label.position = ccp(440, 280);
		[self addChild:time1Label];
		
		CCLabelTTF *time2Label = [CCLabelTTF labelWithString:@"Time" fontName:@"Verdana" fontSize:14];
		time2Label.color = ccc3(0, 0, 0);
		time2Label.position = ccp(50, 280);
		[self addChild:time2Label];
		
		//player1Answer = [[CCLabelTTF labelWithString:@"" fontName:@"Verdana" fontSize:18] retain];
		//player1Answer.color = ccc3(0,0,0);
		//player1Answer.position = ccp(460, 260);
		//player1Answer.anchorPoint = ccp(1,0);
		//[self addChild:player1Answer];
		
		//player2Answer = [[CCLabelTTF labelWithString:@"" fontName:@"Verdana" fontSize:18] retain];
		//player2Answer.color = ccc3(0,0,0);
		//player2Answer.position = ccp(20, 260);
		//player2Answer.anchorPoint = ccp(0, 0);
		//[self addChild:player2Answer];
		
		currentAnswer = [[CCLabelTTF labelWithString:@" " fontName:@"Verdana" fontSize:24] retain];
		currentAnswer.color = ccc3(237, 145, 33);
		currentAnswer.position = ccp(windowSize.width/2, 290);
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
		
		solveButton1 = [CCSprite spriteWithSpriteFrameName:@"GreenSandDollar.png"];
		solveButton1.position = ccp(440, 70);
		[self addChild:solveButton1];
        
        transparentBoundingBox1 = [CCSprite spriteWithSpriteFrameName:@"transparentBoundingBox.png"];
		transparentBoundingBox1.position = ccp(440, 70);
		[self addChild:transparentBoundingBox1];
		
        solveButton2 = [CCSprite spriteWithSpriteFrameName:@"GreenSandDollar.png"];
		solveButton2.position = ccp(50, 70);
        solveButton2.visible = NO;
		[self addChild:solveButton2];
        
		transparentBoundingBox2 = [CCSprite spriteWithSpriteFrameName:@"transparentBoundingBox.png"];
		transparentBoundingBox2.position = ccp(50, 70);
        transparentBoundingBox2.visible = NO;
		[self addChild:transparentBoundingBox2];
		
		greySolveButton1 = [CCSprite spriteWithSpriteFrameName:@"WhiteSandDollar.png"];
		greySolveButton1.position = ccp(440, 70);
		[self addChild:greySolveButton1];
		
		greySolveButton2 = [CCSprite spriteWithSpriteFrameName:@"WhiteSandDollar.png"];
		greySolveButton2.position = ccp(50, 70);
		[self addChild:greySolveButton2];
		greySolveButton2.visible = NO;
		
		userSelection = [[NSMutableArray alloc] init];
		
		foundWords = [[NSMutableDictionary dictionary] retain];
		
		player1Words = [[NSMutableArray array] retain];
		player2Words = [[NSMutableArray array] retain];
		
		midDisplay = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"", 10] fontName:@"MarkerFelt-Thin" fontSize:48] retain];
		midDisplay.position = ccp(240, 160);
		midDisplay.color = ccc3(255, 193, 37);
		[self addChild:midDisplay z:40];
		
		[self createLetterSlots:rows columns:cols firstGame:YES];
		[self schedule:@selector(updateTimer:) interval:1.0f];
        [self schedule:@selector(runAI:) interval:2.0f];
		
		specialEffects = [[NSMutableArray array] retain];
		starPoints = [[NSMutableArray array] retain];
		
		gameCountDownLabel = [[CCLabelTTF labelWithString:@"4" fontName:@"MarkerFelt-Wide" fontSize:100] retain];;
		gameCountDownLabel.position = ccp(240, 160);
		gameCountDownLabel.color = ccc3(135, 206, 250);
		gameCountDownLabel.visible = NO;
		[self addChild:gameCountDownLabel z:30];       
        
        CCSprite *beachImg = [CCSprite spriteWithFile:@"whiteSandBg.png"];
        beachImg.position = ccp(windowSize.width/2, windowSize.height/2);
        beachImg.opacity = 0;
        [self addChild:beachImg z:1];
        
        CCSprite *beachImg2 = [CCSprite spriteWithFile:@"whiteSandBg.png"];
        beachImg2.position = ccp(windowSize.width/2, windowSize.height/2);
        [self addChild:beachImg2 z:-12];
        
        soundEngine = [SimpleAudioEngine sharedEngine];
        
        visibleLetters = [[NSMutableDictionary dictionary] retain];
        
        aiLevel = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"level"];
        progressiveScore = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"progressive_score"];
        
        
        if (aiLevel == nil) {
            aiLevel = [NSString stringWithFormat:@"0"];
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"level" Value:aiLevel];
        }
        
        if (progressiveScore == nil) {
            progressiveScore = [NSString stringWithFormat:@"0"];
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"progressive_score" Value:progressiveScore];
        }
        
        [[CCNotifications sharedManager] addNotificationTitle:@"Current AI Level" 
                                                      message:[NSString stringWithFormat:@"Level is %@ : Progressive Score is %@", aiLevel, progressiveScore] 
                                                        image:nil 
                                                          tag:0 
                                                      animate:YES];
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
			if (!cell.letterSprite.visible) {
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
		if (!cell.letterSprite.visible) {
			cell.letterSprite.visible = YES;
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
	//[player1Answer setString:@" "];
	//[player2Answer setString:@" "];
	
	if (player == 1) {
		playerTurn = 1;	
		player1TileFipped = NO;
		greySolveButton1.visible = NO;
		greySolveButton2.visible = NO;
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
	scoreLabel.position = ccp(cell.letterSprite.position.x, cell.letterSprite.position.y + 30);
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


- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {
    
	if (gameOver || !enableTouch || playerTurn == 2) {
		return TRUE;
	}
	
	
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
	
	if (gameOver && CGRectContainsPoint(midDisplay.boundingBox, touchLocation)) {
		int p1 = [[player1Score string] intValue];
		int p2 = [[player2Score string] intValue];
		//int highScore = (p1 > p2)? p1 : p2;
		
		//[self startGame];
	}
	
    
	if (playerTurn == 1 && CGRectContainsPoint(transparentBoundingBox1.boundingBox, touchLocation)) {
		if ([userSelection count] > 0) {
			[self checkAnswer];
			[self switchTo:2 countFlip:NO];
		} else {
			[self switchTo:2 countFlip:YES];
		}
	}
	
	if (playerTurn == 2 && CGRectContainsPoint(transparentBoundingBox2.boundingBox, touchLocation)) {
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
                
				if (cell.letterSprite.visible && cellSelected) {
					cell.letterSelected.visible = NO;
					[userSelection removeObject:cell];
					[self updateAnswer];
				} else if (cell.letterSprite.visible && !cellSelected) {
                    if ([self allLettersOpened] && touch.tapCount > 2) {
                        CCLOG(@"Triple-Tap detected !!");
                        char ch = (arc4random() % 26) + 'a';
                        Cell *newCell = [self cellWithCharacter:ch atRow:r atCol:c];
                        cell.letterSprite.visible = NO;
                        newCell.letterSprite.visible = YES;
                        [[wordMatrix objectAtIndex:r] removeObject:cell];
                        [[wordMatrix objectAtIndex:r] insertObject:newCell atIndex:c];
                    } else {
                        cell.letterSelected.visible = YES;
                        [userSelection addObject:cell];
                        [self updateAnswer];
                    }
				} else {
					if (playerTurn == 1 && !player1TileFipped) {
						cell.letterSprite.visible = YES;
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
						cell.letterSprite.visible = YES;
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

- (BOOL) allLettersOpened {
    
    for(int r = 0; r < rows; r++) {
		for(int c = 0; c < cols; c++) {
            Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
            if (!cell.letterSprite.visible) {
                return NO;
            }
        }
    }
    return YES;
}

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
	//[player1Answer setString:@" "];
	//[player2Answer setString:@" "];
	[currentAnswer setString:@" "];
	[midDisplay runAction:[CCFadeOut actionWithDuration:0.1f]];
	[midDisplay setString:@""];
	[self clearAllSelectedLetters];
	[self switchTo:1 countFlip:NO];
	
	for(int r = 0; r < rows ; r++) {
		for(int c = 0; c < cols; c++) {
			Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
			cell.letterSprite.visible = YES;
			if (r != rows - 1 || c != cols - 1) {
				[cell.letterSprite runAction:[CCSequence actions:[CCFadeOut actionWithDuration:3], nil]];
			} else {
				[cell.letterSprite runAction:[CCSequence actions:[CCFadeOut actionWithDuration:3], [CCCallFunc actionWithTarget:self selector:@selector(hideBoard)], nil]];
			}
		}
	}
}

- (void) hideBoard {
	for(int r = 0; r < rows ; r++) {
		for(int c = 0; c < cols; c++) {
			Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
			cell.letterSprite.visible = NO;
			[cell.letterSprite runAction:[CCFadeIn actionWithDuration:0.1f]];
		}
	}
	[self setStarPoints];
	[self openRandomLetters:2];
	gameCountdown = YES;
}

- (NSString*) createRandomString  {
	int totalLength = 0;
    int nIteration = 0;
	NSString *randomString = [NSString string];
	CCLOG(@"1. create randomString");
	while(totalLength <= rows * cols) {
		int index = arc4random() % [allWords count];
		CCLOG(@"2. createRandomString");
		NSString *newString = [allWords objectAtIndex:index];
        if (nIteration % 2 == 0 && [newString length] <= 5) {
            CCLOG(@"new string = %@", newString);
            randomString = [randomString stringByAppendingString:newString];
        } else if (nIteration % 2 != 0 && [newString length] > 5) {
            CCLOG(@"new string = %@", newString);
            randomString = [randomString stringByAppendingString:newString];
        }
        
        totalLength = [randomString length];
        nIteration++;
	}
	
	return randomString;
}


- (void) createLetterSlots:(int) rows columns:(int) cols firstGame:(BOOL) firstGameFlag{
	
	CCSprite *label;
	Cell *cell;
	NSString *letters = [self createRandomString];
	
	if (letters) {
		CCLOG(@"SINGLE PLAYER MODE:letters = %@", letters);
	}
	
	NSMutableDictionary *usedIdx = [NSMutableDictionary dictionary];
	
    CCLOG(@"********SINGLE PLAYER MODE START********");
	for(int r = 0; r < rows ; r++) {
		for(int c = 0; c < cols; c++) {
			int i = arc4random() % [letters length];
			NSString *key = [[NSNumber numberWithInt:i] stringValue];
			CCLOG(@"SINGLE PLAYER MODE:Key = %@", key);
			while([usedIdx valueForKey:key]) {
				CCLOG(@"SINGLE PLAYER MODE:Already Used Index = %@", key);
				i = arc4random() % [letters length];
				key = [[NSNumber numberWithInt:i] stringValue];
				CCLOG(@"SINGLE PLAYER MODE:Key = %@", key);
			}
			[usedIdx setObject:@"Y" forKey:key];
			CCLOG(@"SINGLE PLAYER MODE:adding character = %@", [NSString stringWithFormat:@"%c", [letters characterAtIndex:i]]);
			
			if (firstGameFlag) {
                
                cell = [self cellWithCharacter:[[letters lowercaseString] characterAtIndex:i] atRow:r atCol:c];
                [[wordMatrix objectAtIndex:r] insertObject:cell atIndex:c];
			
            } else {
				cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
				cell.letterSprite.visible = NO;
                cell.letterSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%c.png", [[letters lowercaseString] characterAtIndex:i]]];
				cell.value = [NSString stringWithFormat:@"%c", [letters characterAtIndex:i]];
				cell.star.visible = NO;
			}
		}
	}
	
    CCLOG(@"********SINGLE PLAYER MODE END********");
	[self startGame];
}

- (Cell*) cellWithCharacter:(char) ch atRow:(int) r atCol:(int) c {
    Cell *cell = [[[Cell alloc] init] autorelease];
    cell.letterSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%c.png", ch]];
    cell.letterSprite.position = ccp(125 + c * 60, 60 + r * 60);
    cell.letterSprite.visible = NO;
    cell.center = cell.letterSprite.position;
    cell.owner = 0;
    cell.value = [[NSString stringWithFormat:@"%c", ch] uppercaseString];
    [batchNode2 addChild:cell.letterSprite z:10];
    
    CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"Sqaure.png"];
    background.position = cell.letterSprite.position;
    [batchNode2 addChild:background z:-1];
    cell.letterBackground = background;
    
    CCSprite *selectedBackground = [CCSprite spriteWithSpriteFrameName:@"SelectedCell.png"];
    selectedBackground.position = cell.letterSprite.position;
    selectedBackground.visible = NO;
    [batchNode2 addChild:selectedBackground z:1];
    cell.letterSelected = selectedBackground;
    
    CCSprite *star = [CCSprite spriteWithSpriteFrameName:@"RedStarfishSmall.png"];
    star.position = ccp(cell.letterSprite.position.x + 20, cell.letterSprite.position.y - 20);
    star.visible = NO;
    [batchNode addChild:star z:10];
    cell.star = star;
    
    return cell;
}

- (void) clearAllSelectedLetters {
	
	//[player1Answer setString:@" "];
	//[player2Answer setString:@" "];
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
        // MCH -- play invalid word sound
        [soundEngine playEffect:@"dull_bell.mp3"];
		[midDisplay setString:@"Already Used"];
	} else {
		if ([s length] >= 3 && [dictionary objectForKey:s]) {
            [currentAnswer setColor:ccc3(124, 205, 124)];
			[foundWords setObject:s forKey:s];
            
            // MCH -- play success sound
            [soundEngine playEffect:@"success.mp3"];
            
            //MCH -- add to each player's word's array for results scene
            if (playerTurn == 1) {
                [player1Words addObject:s];
            }
            else
            {
                [player2Words addObject:s];
            }
            
			//[midDisplay setString:@"Correct"];
			int starCount = [self countStarPointandRemoveStars];
			int newPoint = pow(2, [s length]);
			[self addScore:newPoint toPlayer:playerTurn anchorCell: [userSelection objectAtIndex:0]];
            [self addMoreTime:(starCount * 10) toPlayer:playerTurn];
            if (starCount > 0 && playerTurn == 1) {
                [[CCNotifications sharedManager] addNotificationTitle:@"Time Extended !!" 
                                                              message:[NSString stringWithFormat:@"Congratulations, %i more seconds added.", starCount * 10] 
                                                                image:@"watchIcon.png" 
                                                                  tag:0 
                                                              animate:YES];
            }
		} else {
            [currentAnswer setColor:ccc3(238, 44, 44)];
            [soundEngine playEffect:@"dull_bell.mp3"];
			[midDisplay setString:@"Not a word"];
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
    currentAnswer.color = ccc3(237, 145, 33);
	[currentAnswer setString:s];
}

-(void) runAI:(ccTime) dt {
    CCLOG(@"*********RUN AI*********");
    if (playerTurn == 1) return;

    [self unschedule:@selector(runAI:)];
    int randomInterval = arc4random() % 5 + 1;
    id flip = [CCCallFunc actionWithTarget:self selector:@selector(aiFlip)];
    id delay = [CCDelayTime actionWithDuration:randomInterval];
    id play = [CCCallFunc actionWithTarget:self selector:@selector(aiFindWords)];
    id aiDone = [CCCallFunc actionWithTarget:self selector:@selector(aiMoveComplete)];
    id delay2 = [CCDelayTime actionWithDuration:1];
    [transparentBoundingBox2 runAction:[CCSequence actions:flip, delay, play, delay2, aiDone, nil]];
}

-(void) aiFlip {
    
    if (playerTurn == 1) return;
    
    CCLOG(@"AI FLIP");
    NSMutableArray *nonVisibleCells = [NSMutableArray array];
    
	for(int r = 0; r < rows; r++) {
		for(int c = 0; c < cols; c++) {
			Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
            if (!cell.letterSprite.visible) {
                [nonVisibleCells addObject:cell];
            }
            
        }
	}
    
    int arraySize = [nonVisibleCells count];
    if (arraySize > 0) {
        Cell *cell = [nonVisibleCells objectAtIndex:(arc4random() % arraySize)];
        cell.letterSprite.visible = YES;
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

-(void) aiMoveComplete {
    
    if (playerTurn == 1) return;
    
    CCLOG(@"AI MOVE COMPLETE");
    if ([userSelection count] > 0) {
        [self checkAnswer];
    }
    [self switchTo:1 countFlip:NO];
    [self schedule:@selector(runAI:) interval:2.0f];
}

-(NSString *) getAllVisibleLetters {
    
    NSString *s = [NSString string];
    
    [visibleLetters removeAllObjects];
    
    for(int r = 0; r < rows; r++) {
		for(int c = 0; c < cols; c++) {
			Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
            if (cell.letterSprite.visible) {
                s = [s stringByAppendingString:cell.value];
                NSMutableArray *cellList = [visibleLetters objectForKey:cell.value];
                if (cellList == nil) {
                    cellList = [NSMutableArray array];
                    [cellList addObject:cell];
                    [visibleLetters setObject:cellList forKey:cell.value];
                } else {
                    [cellList addObject:cell];
                    [visibleLetters setObject:cellList forKey:cell.value];
                }
            }
        }
	}
    return s;
}

-(BOOL) aiCheckAnswer:(NSString *) answer {
    BOOL match = YES;
    NSString *openedLetters = [self getAllVisibleLetters];
    int openLetters[26] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    int idx = 0;
    
    for(int i = 0; i < [openedLetters length]; i++) {
        idx = [openedLetters characterAtIndex:i] - 'A';
        openLetters[idx] = openLetters[idx] + 1;
    }
    
    for(int i = 0; match && i < [answer length]; i++) {
        idx = [answer characterAtIndex:i] - 'A';
        if (openLetters[idx] > 0) {
            openLetters[idx] = openLetters[idx] - 1;
        } else {
            match = NO;
        }
    }
    
    return match;
}

-(void) aiFindWords {
    
    if (playerTurn == 1) return;
    
    BOOL match = NO;
    NSString *ans;
    CCLOG(@"AI FIND WORDS");
    for(int i = 0; !match && i < 10; i++) {
        int idx = arc4random() % [aiAllWords count];
        ans = [aiAllWords objectAtIndex:idx];
        CCLOG(@"AI ANSWERS = %@", ans);
        match = [self aiCheckAnswer:ans];
    }
    
    if (match) {
        CCLOG(@"FOUND ANSWER = %@", ans);
        for(int i = 0; i < [ans length]; i++) {
            
            NSMutableArray *cellList = [visibleLetters objectForKey:[NSString stringWithFormat:@"%c", [ans characterAtIndex:i]]];
            
            if (cellList == nil) {
                CCLOG(@"SOMETHING IS WRONG !!. THIS CONDITION SHOULD NOT HAPPEN");
            } else {
                CCLOG(@"CELL FOUND. ADDING IT TO THE USER SELECTION");
                Cell *cell = [cellList objectAtIndex:0];
                cell.letterSelected.visible = YES;
                [userSelection addObject:cell];
                [self updateAnswer];
            }
        }
    }
}

- (void) updateTimer:(ccTime) dt {
	int p1 = [[player1Timer string] intValue];
	int p2 = [[player2Timer string] intValue];
	
	BOOL play1Done = NO;
	BOOL play2Done = NO;
	
    CCLOG(@"SINGLE PLAYER MODE:updateTimer() START");
    
	if (gameCountdown) {
		CCLOG(@"SINGLE PLAYER MODE:gameCountdown start");
		NSString *status = [gameCountDownLabel string];
		gameCountDownLabel.visible = YES;
		if ([status isEqualToString:@"Go!"]) {
			gameCountdown = NO;
			gameCountDownLabel.visible = NO;
            enableTouch = YES;
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
        [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"level" Value:[NSString stringWithFormat:@"%i", [aiLevel intValue]+1]];
        
		enableTouch = NO;
		int p1score = [[player1Score string] intValue];
		int p2score = [[player2Score string] intValue];
		if (p1score > p2score) {
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"progressive_score" Value:[NSString stringWithFormat:@"%i", [progressiveScore intValue]+1]];
			[midDisplay setString:@"Player 1 Wins"];
		} else if (p1score < p2score) {
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"progressive_score" Value:[NSString stringWithFormat:@"%i", [progressiveScore intValue]-1]];
			[midDisplay setString:@"Player 2 Wins"];
		} else {
			[midDisplay setString:@"Tie Game"];
		}
		[midDisplay runAction:[CCFadeIn actionWithDuration:1]];        
        
        //MCH - display results layer 
        [[CCDirector sharedDirector] replaceScene:[ResultsLayer scene:[player1Score string]
                                                   WithPlayerTwoScore:[player2Score string] 
                                                   WithPlayerOneWords:player1Words 
                                                   WithPlayerTwoWords:player2Words
                                                       ForMultiPlayer:FALSE
                                                   ]];
        
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

- (void) onEnter {
	[super onEnter];
	
     adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
     adView.delegate = self;
     adView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
     adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
     [[[CCDirector sharedDirector] openGLView] addSubview:adView];
     CGSize windowSize = [[CCDirector sharedDirector] winSize];
     adView.center = CGPointMake(adView.frame.size.width/2, windowSize.height - adView.frame.size.height/2);
     adView.hidden = YES;
     
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
    CCLOG(@"**********I-AD FAILED**********");
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