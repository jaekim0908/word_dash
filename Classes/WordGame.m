//
//  HelloWorldLayer.m
//  BattleWord
//
//  Created by Jae Kim on 1/18/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "WordGame.h"
#import "Cell.h"
#import "GameManager.h"
#import "Dictionary.h"
#import "ResultsLayer.h"
#import "SimpleAudioEngine.h"
#import "Parse/Parse.h"
#import "CCNotifications.h"
#import "Util.h"
#import "PauseMenu.h"

@implementation WordGame

@synthesize rows;
@synthesize cols;
@synthesize playButton = _playButton;
@synthesize tapToChangeLeft = _tapToChangeLeft;
@synthesize tapToChangeRight = _tapToChangeRight;
@synthesize player1LongName;
@synthesize player2LongName;
@synthesize leftSideBackground = _leftSideBackground;
@synthesize rightSideBackground = _rightSideBackground;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	WordGame *layer = [WordGame node];
	
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
        cols = 5;
		rows = 4;
		width = 80;
		height = 60;
		y_offset = 30;
		playerTurn = 1;
		gameOver = NO;
		player1TileFlipped = NO;
		player2TileFlipped = NO;
		enableTouch = NO;
		countNoTileFlips = 1;
		currentStarPoints = 8;
		gameCountdown = YES;
        initOpponentOutOfTime = NO;
        playButtonReady = NO;
        tapToNameLeftActive = NO;
        tapToNameRightActive = NO;
        tripleTabUsed = NO;
        
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
		
		CGSize windowSize = [[CCDirector sharedDirector] winSize];
        
		allWords = [[Dictionary sharedDictionary] allWords];
		dictionary = [[Dictionary sharedDictionary] dict];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ImageAssets.plist"];
        batchNode = [[CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"ImageAssets.png"]] retain];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ImageAssets2.plist"];
        batchNode2 = [[CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"ImageAssets2.png"]] retain];
        
        [self addChild:batchNode z:5];
        [self addChild:batchNode2];
        
        self.player1LongName = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"player1_name"];
        self.player2LongName = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"player2_name"];
        
        self.player1LongName = [Util trimName:player1LongName];
        self.player2LongName = [Util trimName:player2LongName];
        
        if (!self.player1LongName) {
            self.player1LongName = @"Player 1";
        }
        
        if (!self.player2LongName) {
            self.player2LongName = @"Player 2...";
        }
        
        self.tapToChangeLeft = [CCSprite spriteWithFile:@"tap_to_change_left.png"];
        self.tapToChangeLeft.position = ccp(130, 295);
        [self addChild:self.tapToChangeLeft];
        
        self.tapToChangeRight = [CCSprite spriteWithFile:@"tap_to_change_right.png"];
        //tapToChangeRight.position = ccp(360, 295);
        self.tapToChangeRight.position = ccp(330, 295);
        [self addChild:self.tapToChangeRight];
        
        player1Name = [[CCLabelTTF labelWithString:[Util formatName:self.player1LongName withLimit:8] fontName:@"MarkerFelt-Thin" fontSize:18] retain];
        player1Name.color = ccc3(0, 0, 0);
        player1Name.position = ccp(50, 260);
        [self addChild:player1Name];
        
        player2Name = [[CCLabelTTF labelWithString:[Util formatName:self.player2LongName withLimit:8] fontName:@"MarkerFelt-Thin" fontSize:18] retain];
        player2Name.color = ccc3(0, 0, 0);
        player2Name.position = ccp(440, 260);
        [self addChild:player2Name];
        
        player1Timer = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", 100] fontName:@"MarkerFelt-Thin" fontSize:28] retain];
		player1Timer.color = ccc3(155, 48, 255);
		player1Timer.position = ccp(50, 190);
		[self addChild:player1Timer];
        
		player2Timer = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", 100] fontName:@"MarkerFelt-Thin" fontSize:28] retain];
		player2Timer.color = ccc3(155, 48, 255);
		player2Timer.position = ccp(440, 190);
		[self addChild:player2Timer];
        
        CCLabelTTF *time1Label = [CCLabelTTF labelWithString:@"Time" fontName:@"MarkerFelt-Thin" fontSize:18];
		time1Label.color = ccc3(0, 0, 0);
		time1Label.position = ccp(50, 220);
		[self addChild:time1Label];
        
		CCLabelTTF *time2Label = [CCLabelTTF labelWithString:@"Time" fontName:@"MarkerFelt-Thin" fontSize:18];
		time2Label.color = ccc3(0, 0, 0);
		time2Label.position = ccp(440, 220);
		[self addChild:time2Label];
        
        player1Score = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", 0] fontName:@"MarkerFelt-Thin" fontSize:28] retain];
		player1Score.color = ccc3(0,0,255);
		player1Score.position = ccp(50, 130);
		[self addChild:player1Score];
        
		player2Score = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", 0] fontName:@"MarkerFelt-Thin" fontSize:28] retain];
		player2Score.color = ccc3(0,0,255);
		player2Score.position = ccp(440, 130);
		[self addChild:player2Score];
        
        CCLabelTTF *score1Label = [CCLabelTTF labelWithString:@"Score" fontName:@"MarkerFelt-Thin" fontSize:18];
		score1Label.color = ccc3(0, 0, 0);
		score1Label.position = ccp(50, 160);
		[self addChild:score1Label];
        
		CCLabelTTF *score2Label = [CCLabelTTF labelWithString:@"Score" fontName:@"MarkerFelt-Thin" fontSize:18];
		score2Label.color = ccc3(0, 0, 0);
		score2Label.position = ccp(440, 160);
		[self addChild:score2Label];
		
		currentAnswer = [[CCLabelTTF labelWithString:@"" fontName:@"Verdana-Bold" fontSize:24] retain];
		currentAnswer.color = ccc3(0, 0, 0);
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
        
        passButton1 = [[CCSprite spriteWithSpriteFrameName:@"PassButton.png"] retain];
		passButton1.position = ccp(50, 70);
        passButton1.visible = NO;
		[batchNode addChild:passButton1];
        
        solveButton1 = [[CCSprite spriteWithSpriteFrameName:@"SubmitButton.png"] retain];
		solveButton1.position = ccp(50, 70);
        solveButton1.visible = NO;
		[batchNode addChild:solveButton1];
        
		transparentBoundingBox1 = [[CCSprite spriteWithSpriteFrameName:@"transparentBoundingBox.png"] retain];
		transparentBoundingBox1.position = ccp(50, 70);
		[batchNode addChild:transparentBoundingBox1];
		
        passButton2 = [[CCSprite spriteWithSpriteFrameName:@"PassButton.png"] retain];
		passButton2.position = ccp(440, 70);
		[batchNode addChild:passButton2];
        
		solveButton2 = [[CCSprite spriteWithSpriteFrameName:@"SubmitButton.png"] retain];
		solveButton2.position = ccp(440, 70);
        solveButton2.visible = NO;
		[batchNode addChild:solveButton2];
        
        transparentBoundingBox2 = [[CCSprite spriteWithSpriteFrameName:@"transparentBoundingBox.png"] retain];
		transparentBoundingBox2.position = ccp(440, 70);
		[batchNode addChild:transparentBoundingBox2];
        
        greySolveButton1 = [[CCSprite spriteWithSpriteFrameName:@"WhiteSandDollar.png"] retain];
		greySolveButton1.position = ccp(50, 74);
		[batchNode addChild:greySolveButton1];
		greySolveButton1.visible = NO;
        
		greySolveButton2 = [[CCSprite spriteWithSpriteFrameName:@"WhiteSandDollar.png"] retain];
		greySolveButton2.position = ccp(440, 74);
		[batchNode addChild:greySolveButton2];
        
		userSelection = [[NSMutableArray alloc] init];
		
		foundWords = [[NSMutableDictionary dictionary] retain];
		
		player1Words = [[NSMutableArray array] retain];
		player2Words = [[NSMutableArray array] retain];
		
		midDisplay = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"", 10] fontName:@"MarkerFelt-Thin" fontSize:48] retain];
		midDisplay.position = ccp(windowSize.width/2, windowSize.height/1.5);
		midDisplay.color = ccc3(255, 193, 37);
		[self addChild:midDisplay z:40];
		
		[self createLetterSlots:rows columns:cols firstGame:YES];
		
		starPoints = [[NSMutableArray array] retain];
		
		gameCountDownLabel = [[CCLabelTTF labelWithString:@"4" fontName:@"MarkerFelt-Wide" fontSize:100] retain];
		gameCountDownLabel.position = ccp(240, 160);
		gameCountDownLabel.color = ccc3(135, 206, 250);
		gameCountDownLabel.visible = NO;
		[self addChild:gameCountDownLabel z:30];        
        
        CCSprite *beachImg = [CCSprite spriteWithFile:@"whiteSandBg.png"];
        beachImg.position = ccp(windowSize.width/2, windowSize.height/2);
        beachImg.opacity = 0;
        [self addChild:beachImg z:1 tag:7777];
        
        CCSprite *beachImg2 = [CCSprite spriteWithFile:@"whiteSandBg.png"];
        beachImg2.position = ccp(windowSize.width/2, windowSize.height/2);
        [self addChild:beachImg2 z:-12 tag:8888];
        
        //soundEngine = [SimpleAudioEngine sharedEngine];
        [[GameManager sharedGameManager] setSoundEngine:[SimpleAudioEngine sharedEngine]];
        
        self.playButton = [CCSprite spriteWithSpriteFrameName:@"GameStartButton.png"];
        self.playButton.position = ccp(windowSize.width/2, windowSize.height/2);
        [batchNode addChild:self.playButton z:30];
        
        // Initialize TextFields
        enterPlayer1Name = [[UITextField alloc] initWithFrame:CGRectMake(210, 30, 80, 30)];
        [enterPlayer1Name setDelegate:self]; 
        [enterPlayer1Name setBorderStyle:UITextBorderStyleRoundedRect];
        enterPlayer1Name.textAlignment = UITextAlignmentCenter;
        [enterPlayer1Name setTextColor:[UIColor blackColor]];
        [enterPlayer1Name setAdjustsFontSizeToFitWidth:YES];
        [enterPlayer1Name setBounds:CGRectMake(0, 0, 80, 30)];
        enterPlayer1Name.backgroundColor = [UIColor whiteColor];
        enterPlayer1Name.transform = CGAffineTransformConcat(enterPlayer1Name.transform, CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(90)));
        
        enterPlayer2Name = [[UITextField alloc] initWithFrame:CGRectMake(210, 425, 80, 30)];
        [enterPlayer2Name setDelegate:self];
        [enterPlayer2Name setBorderStyle:UITextBorderStyleRoundedRect];
        enterPlayer2Name.textAlignment = UITextAlignmentCenter;
        [enterPlayer2Name setTextColor:[UIColor blackColor]];
        [enterPlayer2Name setAdjustsFontSizeToFitWidth:YES];
        [enterPlayer2Name setBounds:CGRectMake(0, 0, 80, 30)];
        enterPlayer2Name.backgroundColor = [UIColor whiteColor];
        enterPlayer2Name.transform = CGAffineTransformConcat(enterPlayer2Name.transform, CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(90)));
        
        self.leftSideBackground = [CCSprite spriteWithSpriteFrameName:@"small-checkmark.png"];
        self.leftSideBackground.position = ccp(50, 70);
        self.leftSideBackground.visible = NO;
        [batchNode addChild:self.leftSideBackground z:100];
        
        self.rightSideBackground = [CCSprite spriteWithSpriteFrameName:@"small-checkmark.png"];
        self.rightSideBackground.position = ccp(440, 70);
        self.rightSideBackground.visible = NO;
        [batchNode addChild:self.rightSideBackground z:100];
        
        waitForYourTurn = [[CCSprite spriteWithSpriteFrameName:@"Wait-Button002.png"] retain];
        waitForYourTurn.position = ccp(245, 150);
        waitForYourTurn.visible = NO;
        waitForYourTurn.opacity = 200;
        [batchNode addChild:waitForYourTurn z:100];
    }
	return self;
}

- (void) showLeftChecker {
    self.leftSideBackground.visible = YES;
}

- (void) showRightChecker {
    self.rightSideBackground.visible = YES;    
}

- (void) hideLeftChecker {
    [self.leftSideBackground stopAllActions];
    self.leftSideBackground.visible = NO;
}

- (void) hideRightChecker {
    [self.rightSideBackground stopAllActions];
    self.rightSideBackground.visible = NO;
}

- (void) showPlayButton {
    playButtonReady = YES;
}

- (void) getPlayer1Name {
    CCLOG(@"getPlayer1Name Started");
    tapToNameLeftActive = YES;
    player1Name.visible = NO;
    if (enterPlayer1Name) { 
        [[[[CCDirector sharedDirector] openGLView] window] addSubview:enterPlayer1Name];
        [enterPlayer1Name becomeFirstResponder];
    }
    CCLOG(@"getPlayer1Name Ended");
}

- (void) getPlayer2Name {
    CCLOG(@"getPlayer2Name Started");
    tapToNameRightActive = YES;
    player2Name.visible = NO;
    if (enterPlayer2Name) {
        [[[[CCDirector sharedDirector] openGLView] window] addSubview:enterPlayer2Name];
        [enterPlayer2Name becomeFirstResponder];
    }
    CCLOG(@"getPlayer2Name Ended");
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == enterPlayer1Name) {
        CCLOG(@"textFieldShouldReturn 1 Started");
        [enterPlayer1Name resignFirstResponder];
        return YES;
    } else if (textField == enterPlayer2Name) {
        CCLOG(@"textFieldShouldReturn 2 Started");
        [enterPlayer2Name resignFirstResponder];
        return YES;
    }
    return NO;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if (textField == enterPlayer1Name) {
        CCLOG(@"textFieldDidEndEditing 1 Started");
        [enterPlayer1Name endEditing:YES];
        if (enterPlayer1Name.text && [enterPlayer1Name.text length] > 0) {
            [player1Name setString:[NSString stringWithString:[Util formatName:enterPlayer1Name.text withLimit:8]]];
            self.player1LongName = [NSString stringWithString:enterPlayer1Name.text];
        }
        [enterPlayer1Name removeFromSuperview];
        [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"player1_name" Value:self.player1LongName];
        player1Name.visible = YES;
        tapToNameLeftActive = NO;
        CCLOG(@"textFieldDidEndEditing 1 Ended");
    } else if (textField == enterPlayer2Name) {
        CCLOG(@"textFieldDidEndEditing 2 Started");
        [enterPlayer2Name endEditing:YES];
        if (enterPlayer2Name.text && [enterPlayer2Name.text length] > 0) {
            [player2Name setString:[NSString stringWithString:[Util formatName:enterPlayer2Name.text withLimit:8]]];
            self.player2LongName = [NSString stringWithString:enterPlayer2Name.text];
        }
        [enterPlayer2Name removeFromSuperview];
        [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"player2_name" Value:self.player2LongName];
        player2Name.visible = YES;
        tapToNameRightActive = NO;
        CCLOG(@"textFieldDidEndEditing 2 Ended");
    }
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

- (void) cleanUpSprite:(CCSprite *)sprite {
    [sprite removeFromParentAndCleanup:YES];
    
}
- (void) showRedSquareAtCell:(Cell *) cell {
    CCSprite *redSquare = [CCSprite spriteWithSpriteFrameName:@"RedSquare.png"];
    redSquare.position = cell.letterSprite.position;
    [batchNode addChild:redSquare];
    [redSquare runAction:[CCSequence actions:[CCFadeOut actionWithDuration:1], [CCCallFuncN actionWithTarget:self selector:@selector(cleanUpSprite:)], nil]];
}

- (void) showBlueSquareAtCell:(Cell *) cell {
    CCSprite *blueSquare = [CCSprite spriteWithSpriteFrameName:@"BlueSquare.png"];
    blueSquare.position = cell.letterSprite.position;
    [batchNode addChild:blueSquare];
    [blueSquare runAction:[CCSequence actions:[CCFadeOut actionWithDuration:1], [CCCallFuncN actionWithTarget:self selector:@selector(cleanUpSprite:)], nil]];
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
            [self showRedSquareAtCell:cell];
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
    
    int n = 0;
    
    if ([starPoints count] > 0) {
        return;
    }
    
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

- (void) switchTo:(int) player countFlip:(BOOL) flag notification:(BOOL) notify {
		
	[self clearLetters];
    player1TileFlipped = NO;
    player2TileFlipped = NO;
    tripleTabUsed = NO;
    
    NSString *turnMessage;
    
    notify = NO;
    
    if (player == 1 && [[player1Timer string] intValue] > 0) {
        playerTurn = 1;	
        greySolveButton1.visible = NO;
        greySolveButton2.visible = YES;
        //[self hideRightChecker];
        //[self showLeftChecker];
        [self turnOnPassButtonForPlayer1];
        
        
        if (notify) {
            if (player1LongName && [player1LongName length] > 0) {
                turnMessage = [NSString stringWithFormat:@"%@'s Turn", player1LongName];
            } else {
                turnMessage = @"Player 1's Turn";
            }
            
            [[CCNotifications sharedManager] addNotificationTitle:nil
                                                          message:turnMessage 
                                                            image:@"watchIcon.png" 
                                                              tag:0 
                                                          animate:YES];
        }
	} else if (player == 2 && [[player2Timer string] intValue] > 0) {
        playerTurn = 2;
        greySolveButton1.visible = YES;
        greySolveButton2.visible = NO;
        [self turnOnPassButtonForPlayer2];
        //[self hideLeftChecker];
        //[self showRightChecker];
        
        if (notify) {
            if (player2LongName && [player2LongName length] > 0) {
                turnMessage = [NSString stringWithFormat:@"%@'s Turn", player2LongName];
            } else {
                turnMessage = @"Player 2's Turn";
            }
            
            [[CCNotifications sharedManager] addNotificationTitle:nil
                                                          message:turnMessage 
                                                            image:@"watchIcon.png" 
                                                              tag:0 
                                                          animate:YES];
        }
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
	float scaleFactor = 1.0 + (point/8.0 - 1.0) * 0.25;
	[scoreLabel runAction:[CCSpawn actions:[CCScaleBy actionWithDuration:1 scale:scaleFactor], [CCMoveBy actionWithDuration:1 position:ccp(0, 15)], [CCFadeOut actionWithDuration:1], nil]];
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
    [player1Timer setString:@"60"];
	[player2Timer setString:@"60"];
	[player1Score setString:@"0"];
	[player2Score setString:@"0"];
	[currentAnswer setString:@" "];
	[midDisplay runAction:[CCFadeOut actionWithDuration:0.1f]];
	[midDisplay setString:@""];
	[self clearAllSelectedLetters];
	[self switchTo:1 countFlip:NO notification:NO];
    [self displayLetters];
    [self showPlayButton];
    
}

- (void) displayLetters {
	for(int r = 0; r < rows ; r++) {
		for(int c = 0; c < cols; c++) {
			Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
			cell.letterSprite.visible = YES;
        }
	}      
}

- (void) fadeOutLetters {
	for(int r = 0; r < rows ; r++) {
		for(int c = 0; c < cols; c++) {
			Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
			if (r != rows - 1 || c != cols - 1) {
				[cell.letterSprite runAction:[CCSequence actions:[CCFadeOut actionWithDuration:3], nil]];
			} else {
				[cell.letterSprite runAction:[CCSequence actions:[CCFadeOut actionWithDuration:3], [CCCallFunc actionWithTarget:self selector:@selector(fadeInLetters)], nil]];
			}
		}
	}    
}
- (void) fadeInLetters {
	for(int r = 0; r < rows ; r++) {
		for(int c = 0; c < cols; c++) {
			Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
			cell.letterSprite.visible = NO;
			[cell.letterSprite runAction:[CCFadeIn actionWithDuration:0.1f]];
		}
	}
	[self setStarPoints];
	[self openRandomLetters:3];
	gameCountdown = YES;
}

- (NSString*) createRandomString  {
	int totalLength = 0;
	NSString *randomString = [NSString string];
    int acceptedCharacterList[26] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    int newStringCharacterList[26] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	while(totalLength <= rows * cols) {
        
        for(int i = 0; i < 26; i++) {
            newStringCharacterList[i] = 0;
        }
        
		int index = arc4random() % [allWords count];
		NSString *newString = [allWords objectAtIndex:index];
        CCLOG(@"NEW STRING = %@", newString);
        for(int i = 0; i < [newString length]; i++) {
            int idx = [newString characterAtIndex:i] - 'A';
            newStringCharacterList[idx]++;
        }
        
        totalLength = 0;
        
        for(int i = 0; i < 26; i++) {
            acceptedCharacterList[i] = MAX(acceptedCharacterList[i], newStringCharacterList[i]);
            totalLength += acceptedCharacterList[i];
        }
	}
    
    for(int i = 0; i < 26; i++) {
        for(int j = 0; j < acceptedCharacterList[i]; j++) {
            randomString = [randomString stringByAppendingString:[NSString stringWithFormat:@"%c", (i + 'A')]];
        }
    }
    
    CCLOG(@"FINAL RANDOM STRING = %@", randomString);
	
	return randomString;
}


- (void) createLetterSlots:(int) nRows columns:(int) nCols firstGame:(BOOL) firstGameFlag{
	
	Cell *cell;
	NSString *letters = [self createRandomString];
	
	if (letters) {
		CCLOG(@"letters = %@", letters);
	}
	
	NSMutableDictionary *usedIdx = [NSMutableDictionary dictionary];
	
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
	
    self.playButton.visible = YES;
	[self startGame];
}

- (void) handleTripleTapWithCell:(Cell *) cell AtRow:(int)r Col:(int)c {
    CCLOG(@"Triple-Tap detected !!");
    [self showBlueSquareAtCell:cell];
    char ch = (arc4random() % 26) + 'a';
    Cell *newCell = [self cellWithCharacter:ch atRow:r atCol:c];
    cell.letterSprite.visible = NO;
    newCell.letterSprite.visible = YES;
    [[wordMatrix objectAtIndex:r] removeObject:cell];
    [[wordMatrix objectAtIndex:r] insertObject:newCell atIndex:c];
    tripleTabUsed = YES;
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

- (void) removeCellAtRow:(int) r Col:(int) c {
    Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
    cell.letterSprite.visible = NO;
    cell.letterBackground.visible = NO;
    cell.star.visible = NO;
    cell.letterSelected.visible = NO;
    [cell.letterSprite removeFromParentAndCleanup:YES];
    [cell.letterBackground removeFromParentAndCleanup:YES];
    [cell.letterSelected removeFromParentAndCleanup:YES];
    [cell.star removeFromParentAndCleanup:YES];
    [[wordMatrix objectAtIndex:r] removeObjectAtIndex:c];
}

- (void) clearAllSelectedLetters {
	
	[currentAnswer setString:@" "];
    
	for(int r = 0; r < rows ; r++) {
		for(int c = 0; c < cols; c++) {
			Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
			cell.star.visible = NO;
		}
	}
	
	for(Cell *c in userSelection) {
		c.letterSelected.visible = NO;
	}
    
    [userSelection removeAllObjects];
}

- (void) clearLetters {
    
    for(int r = 0; r < rows ; r++) {
		for(int c = 0; c < cols; c++) {
			Cell *cell = [[wordMatrix objectAtIndex:r] objectAtIndex:c];
			cell.letterSelected.visible = NO;
		}
	}
	
	[userSelection removeAllObjects];
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
        //[soundEngine playEffect:@"dull_bell.mp3"];
        [[[GameManager sharedGameManager] soundEngine] playEffect:@"dull_bell.mp3"];
		[midDisplay setString:@"Already Used"];
        // JK - penalty
        [self openRandomLetters:1];
	} else {
		if ([s length] >= 3 && [dictionary objectForKey:s]) {
            [currentAnswer setColor:ccc3(124, 205, 124)];
			[foundWords setObject:s forKey:s];
            
            // MCH -- play success sound
            //[soundEngine playEffect:@"success.mp3"];
            [ [[GameManager sharedGameManager] soundEngine] playEffect:@"success.mp3"];
            
            //MCH -- add to each player's word's array for results scene
            if (playerTurn == 1) {
                [player1Words addObject:s];
            }
            else {
                [player2Words addObject:s];
            }
            
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
            //[soundEngine playEffect:@"dull_bell.mp3"];
            [[[GameManager sharedGameManager] soundEngine] playEffect:@"dull_bell.mp3"];
            
			[midDisplay setString:@"Not a word"];
            // JK - penalty
            [self openRandomLetters:1];
		}
	}
	[midDisplay runAction:[CCFadeOut actionWithDuration:1]];
	[userSelection removeAllObjects];
}

- (void) turnOnPassButtonForPlayer1 {
    passButton1.visible = YES;
    solveButton1.visible = NO;
}

- (void) turnOnPassButtonForPlayer2 {
    passButton2.visible = YES;
    solveButton2.visible = NO;
}

- (void) turnOnSubmitButtonForPlayer1 {
    passButton1.visible = NO;
    solveButton1.visible = YES;
}

- (void) turnOnSubmitButtonForPlayer2 {
    passButton2.visible = NO;
    solveButton2.visible = YES;
}

- (void) updateAnswer {
    
    if ([userSelection count] > 0) {
        [self turnOnSubmitButtonForPlayer1];
    } else {
        [self turnOnPassButtonForPlayer1];
    }
    
	NSString *s = [NSString string];
	for(Cell *c in userSelection) {
		s = [s stringByAppendingString:c.value];
	}
    
    currentAnswer.color = ccc3(237, 145, 33);
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
		enableTouch = NO;
		int p1score = [[player1Score string] intValue];
		int p2score = [[player2Score string] intValue];
        
        CCLOG(@"***************Creating SinglePlayGameHistory object***************");
        PFObject *singlePlayGameHistory = [[[PFObject alloc] initWithClassName:@"SinglePlayGameHistory"] autorelease];
        [singlePlayGameHistory setObject:[[GameManager sharedGameManager] gameUUID] forKey:@"gameUUID"];
        [singlePlayGameHistory setObject:[NSNumber numberWithInt:p1score] forKey:@"score1"];
        [singlePlayGameHistory setObject:[NSNumber numberWithInt:p2score] forKey:@"score2"];
        
        [singlePlayGameHistory setObject:player1LongName forKey:@"player1Name"];
        [singlePlayGameHistory setObject:player2LongName forKey:@"player2Name"];
        if (p1score > p2score) {
            [singlePlayGameHistory setObject:@"Win" forKey:@"gameResult"];
        } else if (p1score < p2score) {
            [singlePlayGameHistory setObject:@"Lost" forKey:@"gameResult"];
        } else {
            [singlePlayGameHistory setObject:@"Tie" forKey:@"gameResult"];
        }
        // TODO: change this to be a background process??
        //[singlePlayGameHistory saveInBackgroundWithTarget:self selector:@selector(saveCallback:error:)];
        [singlePlayGameHistory saveInBackground];
        
        CCLOG(@"***************Creating SinglePlayGameHistory 2 object***************");
        // Create a second record with player1 and player2 switched so we can display both records.
        PFObject *player2ScoreRecord = [[[PFObject alloc] initWithClassName:@"SinglePlayGameHistory"] autorelease];
        [player2ScoreRecord setObject:[[GameManager sharedGameManager] gameUUID] forKey:@"gameUUID"];
        [player2ScoreRecord setObject:[NSNumber numberWithInt:p2score] forKey:@"score1"];
        [player2ScoreRecord setObject:[NSNumber numberWithInt:p1score] forKey:@"score2"];
        
        [player2ScoreRecord setObject:player2LongName forKey:@"player1Name"];
        [player2ScoreRecord setObject:player1LongName forKey:@"player2Name"];
        if (p1score < p2score) {
            [player2ScoreRecord setObject:@"Win" forKey:@"gameResult"];
        } else if (p1score > p2score) {
            [player2ScoreRecord setObject:@"Lost" forKey:@"gameResult"];
        } else {
            [player2ScoreRecord setObject:@"Tie" forKey:@"gameResult"];
        }
        // TODO: change this to be a background process??
        //[singlePlayGameHistory saveInBackgroundWithTarget:self selector:@selector(saveCallback:error:)];
        [player2ScoreRecord saveInBackground];
        
        
        //MCH - display results layer
        
        [[GameManager sharedGameManager] setPlayer1Score:[player1Score string]];
        [[GameManager sharedGameManager] setPlayer2Score:[player2Score string]];
        [[GameManager sharedGameManager] setPlayer1Words:player1Words];
        [[GameManager sharedGameManager] setPlayer2Words:player2Words];
        [[GameManager sharedGameManager] setGameMode:kPlayAndPass];
        [[GameManager sharedGameManager] runLoadingSceneWithTargetId:kWordSummaryScene];
         
        /********
        [[CCDirector sharedDirector] replaceScene:[ResultsLayer scene:[player1Score string]
                                                   WithPlayerTwoScore:[player2Score string] 
                                                   WithPlayerOneWords:player1Words 
                                                   WithPlayerTwoWords:player2Words
                                                          ForGameMode:kPlayAndPass
                                                   ]];
         
         ******/
        
	} else {
		if (playerTurn == 1) {
			if (!play1Done) {
				--p1;
                if (p1 > 10) {
                    player1Timer.color = ccc3(155, 48, 255);
                } else {
                    player1Timer.color = ccc3(255, 0, 0);
                }
				[player1Timer setString:[NSString stringWithFormat:@"%i", p1]];
			} else {
				playerTurn = 2;
				[self switchTo:playerTurn countFlip:NO notification:YES];
			}
		} else {
			if (!play2Done) {
				--p2;
                if (p2 > 10) {
                    player2Timer.color = ccc3(155, 48, 255);
                } else {
                    player2Timer.color = ccc3(255, 0, 0);
                }
				[player2Timer setString:[NSString stringWithFormat:@"%i", p2]];
			} else {
				playerTurn = 1;
				[self switchTo:playerTurn countFlip:NO notification:YES];
			}
		}
	}	
}

- (BOOL) isVowel:(NSString *) str {
    return ([str isEqualToString:@"A"] ||
            [str isEqualToString:@"E"] ||
            [str isEqualToString:@"I"] ||
            [str isEqualToString:@"O"] ||
            [str isEqualToString:@"U"]);
}

- (BOOL) isGameOver {
    int p1 = [[player1Timer string] intValue];
	int p2 = [[player2Timer string] intValue];
    
    return (p1 + p2 == 0);
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    
    [wordMatrix release];
    [passButton1 release];
    [passButton2 release];
    [solveButton1 release];
    [solveButton2 release];
    [transparentBoundingBox1 release];
    [transparentBoundingBox2 release];
    [greySolveButton1 release];
    [greySolveButton2 release];
    [foundWords release];
    [player1Words release];
    [player2Words release];
    [starPoints release];
    [player1Name release];
    [player2Name release];
    [player1Timer release];
    [player2Timer release];
    [player1Score release];
    [player2Score release];
    [currentAnswer release];
    [midDisplay release];
    [gameCountDownLabel release];
    [self.playButton release];
    [self.tapToChangeLeft release];
    [self.tapToChangeRight release];
    [userSelection release];
    [player1LongName release];
    [player2LongName release];
    [enterPlayer1Name release];
    [enterPlayer2Name release];
    [batchNode release];
    [batchNode2 release];
    [waitForYourTurn release];
    
    [self.leftSideBackground release];
    [self.rightSideBackground release];
        
    wordMatrix = nil;
    solveButton1 = nil;
    solveButton2 = nil;
    transparentBoundingBox1 = nil;
    transparentBoundingBox2 = nil;
    greySolveButton1 = nil;
    greySolveButton2 = nil;
    foundWords = nil;
    player1Words = nil;
    player2Words = nil;
    starPoints = nil;
    player1Name = nil;
    player2Name = nil;
    player1Timer = nil;
    player2Timer = nil;
    player1Score = nil;
    player2Score = nil;
    currentAnswer = nil;
    midDisplay = nil;
    gameCountDownLabel = nil;
    userSelection = nil;
    player1LongName = nil;
    player2LongName = nil;
    enterPlayer1Name = nil;
    enterPlayer2Name = nil;
    batchNode = nil;
    batchNode2 = nil;
    waitForYourTurn = nil;
    
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

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    float THRESHOLD = 1.7;
    if (acceleration.x > THRESHOLD || acceleration.x < -THRESHOLD || 
        acceleration.y > THRESHOLD || acceleration.y < -THRESHOLD ||
        acceleration.z > THRESHOLD || acceleration.z < -THRESHOLD) {
        
        if (playerTurn == 1) {
            [self clearAllSelectedLetters];
            [self turnOnPassButtonForPlayer1];
        }
    }
}

@end
