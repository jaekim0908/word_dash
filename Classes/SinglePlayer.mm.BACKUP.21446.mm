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
#import "Dictionary.h"
#import "GameManager.h"
#import "ResultsLayer.h"
#import "PauseLayer.h"
#import "SimpleAudioEngine.h"
#import "AIDictionary.h"
#import "Parse/Parse.h"
#import "CCNotifications.h"
#import "PauseMenu.h"
#import "Constants.h"

@implementation SinglePlayer

<<<<<<< HEAD
@synthesize rows;
@synthesize cols;
@synthesize isThisPlayerChallenger;
@synthesize numPauseRequests;
@synthesize soundEngine;
@synthesize initOpponentOutOfTime;
@synthesize player1Name;
@synthesize pauseState;
@synthesize pauseMenuPlayAndPass;
@synthesize thisGameBeatAIAward;
@synthesize thisGameTotalPointsAward;
@synthesize thisGameLongWordAward;

=======
>>>>>>> origin/wordanista_v1
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
        aiAllWords = [[AIDictionary sharedDictionary] allWords];
        solveButton2.visible = NO;
        transparentBoundingBox2.visible = NO;
		greySolveButton2.visible = NO;        
        tapToChangeRight.visible = NO;
        visibleLetters = [[NSMutableDictionary dictionary] retain];
        
        aiLevel = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"level"];
        progressiveScore = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"progressive_score"];
        numOfWinsAI = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"num_of_wins_vs_ai"];
        numOfLossesAI = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"num_of_losses_vs_ai"];
        numOfTiesAI = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"num_of_ties_vs_ai"];
        longestAnswer = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"longest_answer"];
        player1LongName  = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"player1_name"];
        
        if (!aiLevel) {
            aiLevel = [NSString stringWithFormat:@"0"];
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"level" Value:aiLevel];
        }
        
        if (!progressiveScore) {
            progressiveScore = [NSString stringWithFormat:@"0"];
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"progressive_score" Value:progressiveScore];
        }
        
        if (!numOfWinsAI) {
            numOfWinsAI = [NSString stringWithFormat:@"0"];
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"num_of_wins_vs_ai" Value:numOfWinsAI];
        }
        
        if (!numOfLossesAI) {
            numOfLossesAI = [NSString stringWithFormat:@"0"];
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"num_of_losses_vs_ai" Value:numOfLossesAI];
        }
        
        if (!numOfTiesAI) {
            numOfTiesAI = [NSString stringWithFormat:@"0"];
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"num_of_ties_vs_ai" Value:numOfTiesAI];
        }
        
        if (!longestAnswer) {
            longestAnswer = @"";
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"longest_answer" Value:longestAnswer];
        }
        
        if (!player1LongName) {
            player1LongName = @"Player 1";
        }
        
        pauseState = FALSE;
        pauseMenuPlayAndPass = [[PauseMenu alloc] init];
        [pauseMenuPlayAndPass addToMyScene:self];
	}
	return self;
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
    player1TileFipped = NO;
    player2TileFipped = NO;
		
	if (player == 1 && [[player1Timer string] intValue] > 0) {
        playerTurn = 1;	
        greySolveButton1.visible = NO;
        greySolveButton2.visible = NO;
        NSString *turnMessage;
    
        if (player1LongName && [player1LongName length] > 0) {
            turnMessage = [NSString stringWithFormat:@"%@'s Turn", player1LongName];
        } else {
            turnMessage = @"Your Turn";
        }
    
        [[CCNotifications sharedManager] addNotificationTitle:nil
                                                      message:turnMessage 
                                                        image:@"watchIcon.png" 
                                                          tag:0 
                                                      animate:YES];
	} else if (player == 2 && [[player2Timer string] intValue] > 0) {
        playerTurn = 2;
        greySolveButton1.visible = YES;
        greySolveButton2.visible = NO;
	}
}


-(BOOL) stopTimer
{
    [self unschedule:@selector(updateTimer:)];
    
    return TRUE;
}

-(BOOL) startTimer
{
    if (!playButtonReady) {
        [self schedule:@selector(updateTimer:) interval:1.0f];
    }
    
    return TRUE;
}


- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {
    
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    //MCH - DISPLAY THE PAUSE MENU
    if(CGRectContainsPoint(pauseMenuPlayAndPass.pauseButton.boundingBox, touchLocation) && !pauseState){
        pauseState = TRUE;
        [pauseMenuPlayAndPass showPauseMenu:self];
    }
	
    // FUNCTIONS ON THE PAUSE MENU                     
    if (pauseState) {
        CCLOG(@"In a pause state.");
        pauseState = [pauseMenuPlayAndPass execPauseMenuActions:touchLocation forScene:self withId:kSinglePlayerScene];        
    }
    else {
        
        //PLAY BUTTON PRESSED
        if (playButtonReady && CGRectContainsPoint(_playButton.boundingBox, touchLocation)) {
            [self fadeOutLetters];
            _playButton.visible = NO;
            playButtonReady = NO;
            tapToChangeLeft.visible = NO;
            tapToChangeRight.visible = NO;
            [self schedule:@selector(updateTimer:) interval:1.0f];
            [self schedule:@selector(runAI:) interval:2.0f];
            
        } else if (playButtonReady && !tapToNameLeftActive && !tapToNameRightActive && CGRectContainsPoint(player1Name.boundingBox, touchLocation)) {
            [self getPlayer1Name];
        } else if (playButtonReady && !tapToNameLeftActive && !tapToNameRightActive && CGRectContainsPoint(tapToChangeLeft.boundingBox, touchLocation)) {
            [self getPlayer1Name];
        }
    
        if (gameOver || !enableTouch || playerTurn == 2) {
            return TRUE;
        }
        
        
        if (playerTurn == 1 && CGRectContainsPoint(transparentBoundingBox1.boundingBox, touchLocation)) {
            if ([userSelection count] > 0) {
                [self checkAnswer];
                [self switchTo:2 countFlip:NO];
            } else {
                [midDisplay setString:@"Pass"];
                [midDisplay runAction:[CCFadeOut actionWithDuration:1.0f]]; 
                [self switchTo:2 countFlip:YES];
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

<<<<<<< HEAD
- (void) startGame {
	
	gameOver = NO;
	playerTurn = 1;
	currentStarPoints = 8;
	[foundWords removeAllObjects];
	[starPoints removeAllObjects];
	//[player1Timer setString:@"100"];
	//[player2Timer setString:@"100"];
    [player1Timer setString:@"60"];
	[player2Timer setString:@"60"];
	[player1Score setString:@"0"];
	[player2Score setString:@"0"];
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


- (void) createLetterSlots:(int) nRows columns:(int) nCols firstGame:(BOOL) firstGameFlag{
	
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
            
            //JHK - check to see if this is the longest word
            if ([longestAnswer length] < [s length]) {
                longestAnswer = s;
            }
            
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
=======
 -(void) runAI:(ccTime) dt {
>>>>>>> origin/wordanista_v1
    CCLOG(@"*********RUN AI*********");
    if (playerTurn == 1 || [[player2Timer string] intValue] <= 0) return;

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
    else{
        [midDisplay setString:@"Pass"];
        [midDisplay runAction:[CCFadeOut actionWithDuration:1.0f]];
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
    int batchSize;
    
    batchSize = [GameManager sharedGameManager].singlePlayerBatchSize;
    
    CCLOG(@"BATCH SIZE: %i",batchSize);
    
    if (progressiveScore != nil) {
        batchSize += [progressiveScore intValue];
    }
    
    if (batchSize <= 0) batchSize = 5;
    
    for(int i = 0; !match && i < batchSize; i++) {
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

-(int) getLongestWordLengthInArray:(NSMutableArray *) playerWordsArray
{
    
    NSString *tmpWord=nil;
    int longestLength=0, longestWordIndex=0, currentWordLength, i=0;
    
    for (i=0;i < playerWordsArray.count;i++)  {
        
        tmpWord = [playerWordsArray objectAtIndex:i];
        currentWordLength = [tmpWord length];
        if(currentWordLength > longestLength){
            longestLength = currentWordLength;
            longestWordIndex = i;
        }
    }

    return longestLength;
    
}

- (void) determineAwardsForSinglePlayer:(int)p1Score AIScore:(int)aiScore Player1Words:(NSMutableArray *)player1WordsArray
{
    NSMutableDictionary *allGameLevels = [[GameManager sharedGameManager] getGameLevelDictionary];
    NSString *currentLevel = [NSString stringWithFormat:@"Level%i",[GameManager sharedGameManager].singlePlayerLevel];
    NSMutableDictionary *levelInfo = [ allGameLevels objectForKey:currentLevel];
    
    BOOL beatAIAward = [[levelInfo objectForKey:@"beatAIAward"] boolValue];
    BOOL totalPointsAward = [[levelInfo objectForKey:@"totalPointsAward"] boolValue];
    BOOL longWordAward = [[levelInfo objectForKey:@"totalPointsAward"] boolValue];
    BOOL updatePList = NO;
    
    //BEAT AI AWARD        
    //IF THE PLAYER BEAT THE AI
    if (p1Score > aiScore) {
        if (!beatAIAward) {
            updatePList = YES;
            [levelInfo setObject:[NSNumber numberWithBool:TRUE] forKey:@"beatAIAward"];
        }
        self.thisGameBeatAIAward = YES;
    }
        
    int totalPointsForStar = [[levelInfo objectForKey:@"totalPointsForStar"] boolValue];
    //IF THE PLAYER PAST THE TOTAL POINTS THRESHOLD
    if (p1Score >= totalPointsForStar){
        if(!totalPointsAward){
            updatePList = YES;
            [levelInfo setObject:[NSNumber numberWithBool:TRUE] forKey:@"totalPointsAward"];
        }
        self.thisGameTotalPointsAward = YES;
    }
    
    int wordLengthForStar = [[levelInfo objectForKey:@"wordLengthForStar"] boolValue];
    int longestWordLength = [self getLongestWordLengthInArray:player1WordsArray];
    //IF THE LONGEST WORD IS GREATER THAN THE THRESHOLD
    if (longestWordLength >= wordLengthForStar) {
        if(!longWordAward){
            updatePList = YES;
            [levelInfo setObject:[NSNumber numberWithBool:TRUE] forKey:@"longWordAward"];
        }
        self.thisGameLongWordAward = YES;
    }
        
    //UPDATE THE PLIST FILE IF ANY NEW AWARDS WERE WON THIS GAME
    if (updatePList) {
        [allGameLevels setObject:levelInfo forKey:currentLevel];
        NSString *path = [[GameManager sharedGameManager] getGameLevelPListPath];
        [allGameLevels writeToFile:path atomically:YES];
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
        
        [self unscheduleAllSelectors];
        [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"level" Value:[NSString stringWithFormat:@"%i", [aiLevel intValue]+1]];
        
		enableTouch = NO;
		int p1score = [[player1Score string] intValue];
		int p2score = [[player2Score string] intValue];
        
		if (p1score > p2score) {
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"progressive_score" Value:[NSString stringWithFormat:@"%i", [progressiveScore intValue]+10]];
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"num_of_wins_vs_ai" Value:[NSString stringWithFormat:@"%i", [numOfWinsAI intValue]+1]];
			[midDisplay setString:@"Player 1 Wins"];
		} else if (p1score < p2score) {
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"progressive_score" Value:[NSString stringWithFormat:@"%i", [progressiveScore intValue]-3]];
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"num_of_losses_vs_ai" Value:[NSString stringWithFormat:@"%i", [numOfLossesAI intValue]+1]];
			[midDisplay setString:@"Player 2 Wins"];
		} else {
			[midDisplay setString:@"Tie Game"];
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"num_of_ties_vs_ai" Value:[NSString stringWithFormat:@"%i", [numOfTiesAI intValue]+1]];
		}
        [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"longest_answer" Value:longestAnswer];
		[midDisplay runAction:[CCFadeIn actionWithDuration:1]]; 
        
        CCLOG(@"***************Creating SinglePlayGameHistory object***************");
        PFObject *singlePlayGameHistory = [[[PFObject alloc] initWithClassName:@"SinglePlayGameHistory"] autorelease];
        [singlePlayGameHistory setObject:[[GameManager sharedGameManager] gameUUID] forKey:@"gameUUID"];
        [singlePlayGameHistory setObject:[NSNumber numberWithInt:p1score] forKey:@"score1"];
        [singlePlayGameHistory setObject:[NSNumber numberWithInt:p2score] forKey:@"score2"];
        if (self.player1LongName && [self.player1LongName length] > 0) {
            [singlePlayGameHistory setObject:self.player1LongName forKey:@"player1Name"];
        } else {
            [singlePlayGameHistory setObject:@"-----" forKey:@"player1Name"];
        }
        [singlePlayGameHistory setObject:@"AI" forKey:@"player2Name"];
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
        
        
        //MCH - call determine awards for single player here
        //!!! CHANGE LONGEST WORD LENGTH
        [self determineAwardsForSinglePlayer:[[player1Score string] intValue] AIScore:[[player2Score string] intValue] Player1Words:player1Words];
        
        //MCH - display results layer
        [[CCDirector sharedDirector] replaceScene:[ResultsLayer scene:[player1Score string]
                                                   WithPlayerTwoScore:[player2Score string] 
                                                   WithPlayerOneWords:player1Words 
                                                   WithPlayerTwoWords:player2Words
                                                       ForGameMode:kSinglePlayer
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

- (int) didPlayer1Win {
    int p1score = [[player1Score string] intValue];
    int p2score = [[player2Score string] intValue];
    
    return (p1score - p2score);
}

- (void)saveCallback:(NSNumber *)result error:(NSError *)error {
    if (!error) {
        // The gameScore saved successfully.
        CCLOG(@"***************Transition to ScoreSummaryScene***************");
    } else {
        // There was an error saving the gameScore.
        CCLOG(@"***************SAVE CALLBACK ERROR***************");
        CCLOG(@"%@", error);
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [pauseMenuPlayAndPass release];
    [visibleLetters release];
	[super dealloc];
}

@end