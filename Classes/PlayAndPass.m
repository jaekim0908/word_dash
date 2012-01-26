// Import the interfaces
#import "PlayAndPass.h"
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

@implementation PlayAndPass

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayAndPass *layer = [PlayAndPass node];
	
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
        pauseState = FALSE;
        pauseMenuPlayAndPass = [[PauseMenu alloc] init];
        [pauseMenuPlayAndPass addToMyScene:self];
	}
	return self;
}

- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {
    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
     if(CGRectContainsPoint(pauseMenuPlayAndPass.pauseButton.boundingBox, touchLocation) && !pauseState){
         pauseState = TRUE;
         [pauseMenuPlayAndPass showPauseMenu:self];
     }
     
     // FUNCTIONS ON THE PAUSE MENU                     
     if (pauseState) {
         CCLOG(@"In a pause state.");
         pauseState = [pauseMenuPlayAndPass execPauseMenuActions:touchLocation forScene:self withId:kPlayAndPassScene];        
     }
     
     //MCH - JAE PROGRAMMING STYLE QUESTION, ONE RETURN POINT OR MULTIPLE?
     //DON'T EXECUTE GAME SCREEN FUNCTIONS FURTHER IF IN A PAUSE STATE
     if (pauseState) {
     return TRUE;
     }
    
    //PLAY BUTTON PRESSED
    if (playButtonReady && CGRectContainsPoint(_playButton.boundingBox, touchLocation)) {
        [self fadeOutLetters];
        self.playButton.visible = NO;
        playButtonReady = NO;
        self.tapToChangeLeft.visible = NO;
        self.tapToChangeRight.visible = NO;
        [self showLeftChecker];
        [self schedule:@selector(updateTimer:) interval:1.0f];
        
    } else if (playButtonReady && !tapToNameLeftActive && !tapToNameRightActive && CGRectContainsPoint(player1Name.boundingBox, touchLocation)) {
        [self getPlayer1Name];
    } else if (playButtonReady && !tapToNameRightActive && !tapToNameLeftActive && CGRectContainsPoint(player2Name.boundingBox, touchLocation)) {
        [self getPlayer2Name];
    } else if (playButtonReady && !tapToNameLeftActive && !tapToNameRightActive && CGRectContainsPoint(self.tapToChangeLeft.boundingBox, touchLocation)) {
        [self getPlayer1Name];
    } else if (playButtonReady && !tapToNameRightActive && !tapToNameLeftActive && CGRectContainsPoint(self.tapToChangeRight.boundingBox, touchLocation)) {
        [self getPlayer2Name];
    }
    
    if (!gameOver && !enableTouch) {
		return TRUE;
	}
    
	if (playerTurn == 1 && CGRectContainsPoint(transparentBoundingBox1.boundingBox, touchLocation)) {
		if ([userSelection count] > 0) {
			[self checkAnswer];
			[self switchTo:2 countFlip:NO notification:YES];
		} else {
			[self switchTo:2 countFlip:YES notification:YES];
		}
	}
	
	if (playerTurn == 2 && CGRectContainsPoint(transparentBoundingBox2.boundingBox, touchLocation)) {
		if ([userSelection count] > 0) {
			[self checkAnswer];
			[self switchTo:1 countFlip:YES notification:YES];
		} else {
			[self switchTo:1 countFlip:YES notification:YES];
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
                    if ([self allLettersOpened] && touch.tapCount > 2 && !tripleTabUsed) {
                        [self handleTripleTapWithCell:cell AtRow:r Col:c];
                    } else {
                        cell.letterSelected.visible = YES;
                        [userSelection addObject:cell];
                        [self updateAnswer];
                    }
				} else {
					if (playerTurn == 1 && !player1TileFlipped) {
						cell.letterSprite.visible = YES;
						player1TileFlipped = YES;
						if ([self isVowel:cell.value]) {
							[self addScore:8 toPlayer:playerTurn anchorCell:cell];
						}
						if ([self isThisStarPoint:cell]) {
							cell.star.visible = YES;
						}
					} else if (playerTurn == 2 && !player2TileFlipped) {
						cell.letterSprite.visible = YES;
						player2TileFlipped = YES;
						if ([self isVowel:cell.value]) {
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
            
			int starCount = [self countStarPointandRemoveStars];
			int newPoint = pow(2, [s length]);
			[self addScore:newPoint toPlayer:playerTurn anchorCell: [userSelection objectAtIndex:0]];
            [self addMoreTime:(starCount * 10) toPlayer:playerTurn];
            if (starCount > 0) {
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

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [pauseMenuPlayAndPass release];
	[super dealloc];
}

@end