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

@synthesize thisGameBeatAIAward;
@synthesize thisGameTotalPointsAward;
@synthesize thisGameLongWordAward;
@synthesize awardPopupFrame;
@synthesize awardPopupTintedBackground;
@synthesize nextLevelBtn;
@synthesize getResultsBtn;
@synthesize rematchBtn;
@synthesize mainMenuBtn;
@synthesize awardsMenu;
@synthesize thisGameBeatAIAwardSprite;
@synthesize thisGameTotalPointsAwardSprite;
@synthesize thisGameLongWordAwardSprite;
@synthesize singlePlayerScore;
@synthesize levelStatus;
@synthesize levelDisplay;
@synthesize aiMaxWaitTime;


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
        
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        
        //MCH aiAllWords = [[AIDictionary sharedDictionary] allWords];
        //aiAllWords = [[Dictionary sharedDictionary] allWords];
        aiAllWords = [[AIDictionary sharedDictionary] loadAllWords];
        passButton2.visible = NO;
        solveButton2.visible = NO;
        transparentBoundingBox2.visible = NO;
		greySolveButton2.visible = NO;        
        self.tapToChangeRight.visible = NO;
        visibleLetters = [[NSMutableDictionary dictionary] retain];
        
        aiLevel = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"level"];
        progressiveScore = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"progressive_score"];
        numOfWinsAI = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"num_of_wins_vs_ai"];
        numOfLossesAI = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"num_of_losses_vs_ai"];
        numOfTiesAI = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"num_of_ties_vs_ai"];
        longestAnswer = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"longest_answer"];
        self.player1LongName  = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"player1_name"];
        
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
            self.player1LongName = @"Player 1";
        }
        
        pauseState = FALSE;
        pauseMenuPlayAndPass = [[PauseMenu alloc] init];
        [pauseMenuPlayAndPass addToMyScene:self];
   
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"AwardsScreenAssets.plist"];
        awardsScreenBatchNode = [[CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"AwardsScreenAssets.png"]] retain];
        [self addChild:awardsScreenBatchNode z:55];
        
        //CREATE AWARDS POPUP FOR THE END OF THE GAME
        awardsState = FALSE;
        awardPopupTintedBackground = [CCSprite spriteWithFile:@"pause_background.png"];
        awardPopupTintedBackground.position = ccp(240,160);
        awardPopupTintedBackground.visible = NO;
        [self addChild:awardPopupTintedBackground z:45];

        
        awardPopupFrame = [CCSprite spriteWithSpriteFrameName:@"Results-Screen_Scroll.png"];
        awardPopupFrame.position = ccp(240,175);
        awardPopupFrame.visible = NO;
        [awardsScreenBatchNode addChild:awardPopupFrame z:50];
        
        levelDisplay = [CCLabelTTF labelWithString:@"LEVEL 1"
                                         fontName:@"MarkerFelt-Thin" 
                                         fontSize:22]; 
        //has retain on result layer, discuss double retain with jae
		levelDisplay.color = ccc3(255,255,255);
		levelDisplay.position = ccp(120+5,255-15);
        levelDisplay.anchorPoint = ccp(0,0);
        levelDisplay.visible = NO;
		[self addChild:levelDisplay z:55];
        
        levelStatus = [CCLabelTTF labelWithString:@"LEVEL STATUS: "
                                         fontName:@"MarkerFelt-Thin" 
                                         fontSize:22]; 
        //has retain on result layer, discuss double retain with jae
		levelStatus.color = ccc3(255,255,255);
		levelStatus.position = ccp(120+5,210);
        levelStatus.anchorPoint = ccp(0,0);
        levelStatus.visible = NO;
		[self addChild:levelStatus z:55];
        
        singlePlayerScore = [CCLabelTTF labelWithString:@"SCORE: "
                                               fontName:@"MarkerFelt-Thin" 
                                               fontSize:22]; 
		singlePlayerScore.color = ccc3(255,255,255);;
		singlePlayerScore.position = ccp(120+5,185);
        singlePlayerScore.anchorPoint = ccp(0,0);
        singlePlayerScore.visible = NO;
		[self addChild:singlePlayerScore z:55];
      
        nextLevelBtn = [CCMenuItemImage 
                                         itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"next_level.png"] 
                                         selectedSprite:[CCSprite spriteWithSpriteFrameName:@"next_level.png"] 
                                         target:self
                                         selector:@selector(nextLevelPressed)];
        nextLevelBtn.visible = FALSE;
        nextLevelBtn.position = ccp(148, 125); 
        
        //nextLevelBtn = [CCSprite spriteWithSpriteFrameName:@"next_level.png"];
        //nextLevelBtn.position = ccp(148,125);
        //nextLevelBtn.visible = NO;
        //[awardsScreenBatchNode addChild:nextLevelBtn z:55];
        
        getResultsBtn = [CCMenuItemImage 
                                    itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"get_results.png"] 
                                    selectedSprite:[CCSprite spriteWithSpriteFrameName:@"get_results.png"] 
                                    target:self
                                    selector:@selector(getResultsPressed)];
        getResultsBtn.position = ccp(218, 125); 

        //getResultsBtn = [CCSprite spriteWithSpriteFrameName:@"get_results.png"];
        //getResultsBtn.position = ccp(218,125);
        //getResultsBtn.visible = NO;
        //[awardsScreenBatchNode addChild:getResultsBtn z:55];
        
        rematchBtn = [CCMenuItemImage 
                                     itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"rematch.png"] 
                                     selectedSprite:[CCSprite spriteWithSpriteFrameName:@"rematch.png"] 
                                     target:self
                                     selector:@selector(rematchBtnPressed)];
        rematchBtn.position = ccp(283, 124); 

        //rematchBtn = [CCSprite spriteWithSpriteFrameName:@"rematch.png"];
        //rematchBtn.position = ccp(283,124);
        //rematchBtn.visible = NO;
        //[awardsScreenBatchNode addChild:rematchBtn z:55];
        
        mainMenuBtn = [CCMenuItemImage 
                                  itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"main_menu_btn.png"] 
                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"main_menu_btn.png"] 
                                  target:self
                                  selector:@selector(mainMenuBtnPressed)];
        mainMenuBtn.position = ccp(348, 124); 
        
        
        //mainMenuBtn = [CCSprite spriteWithSpriteFrameName:@"main_menu_btn.png"];
        //mainMenuBtn.position = ccp(348,124); 
        //mainMenuBtn.visible = NO;
        //[awardsScreenBatchNode addChild:mainMenuBtn z:55];
        
        awardsMenu = [CCMenu menuWithItems:nextLevelBtn, getResultsBtn, rematchBtn, mainMenuBtn, nil];
        awardsMenu.position = CGPointZero;
        awardsMenu.isTouchEnabled = FALSE;
        awardsMenu.visible = FALSE;
        [self addChild:awardsMenu z:55];

        thisGameBeatAIAwardSprite = [CCSprite spriteWithSpriteFrameName:@"Trophy001-small.png"];
        thisGameBeatAIAwardSprite.position = ccp(210,168);
        thisGameBeatAIAwardSprite.visible = NO;
        [awardsScreenBatchNode addChild:thisGameBeatAIAwardSprite  z:55];
       
        thisGameTotalPointsAwardSprite = [CCSprite spriteWithSpriteFrameName:@"Coins001-small.png"];
        thisGameTotalPointsAwardSprite.position = ccp(240,168);
        thisGameTotalPointsAwardSprite.visible = NO;
        [awardsScreenBatchNode addChild:thisGameTotalPointsAwardSprite  z:55];
        
        thisGameLongWordAwardSprite = [CCSprite spriteWithSpriteFrameName:@"Book002-small.png"];
        thisGameLongWordAwardSprite.position = ccp(270,168);
        thisGameLongWordAwardSprite.visible = NO;
        [awardsScreenBatchNode addChild:thisGameLongWordAwardSprite  z:55];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[activityIndicator setCenter:CGPointMake(windowSize.width/2, 30)]; // I do this because I'm in landscape mode
        [activityIndicator setColor:[UIColor blackColor]];
		[[[CCDirector sharedDirector] openGLView] addSubview:activityIndicator];
	}
	return self;
}

- (void) switchTo:(int) player countFlip:(BOOL) flag {
	
	if (flag) {
		if (playerTurn == 1 && !player1TileFlipped) {
			countNoTileFlips++;
		} else if (playerTurn == 2 && !player2TileFlipped) {
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
    player1TileFlipped = NO;
    player2TileFlipped = NO;
    tripleTabUsed = YES;
		
	if (player == 1 && [[player1Timer string] intValue] > 0) {
        playerTurn = 1;	
        greySolveButton1.visible = NO;
        greySolveButton2.visible = NO; 
        //[self showLeftChecker];
        [self turnOnPassButtonForPlayer1];
        
        /*
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
        */
	} else if (player == 2 && [[player2Timer string] intValue] > 0) {
        playerTurn = 2;
        greySolveButton1.visible = YES;
        greySolveButton2.visible = NO;
        //[self hideLeftChecker];
	}
}

-(void) showAIActivity {
    [self clearCurrentAnswer];
    [activityIndicator startAnimating];
}

-(void) hideAIActivity {
    [activityIndicator stopAnimating];
}

-(void) clearCurrentAnswer {
    [currentAnswer setString:@""];
}

-(BOOL) stopTimer
{
    [transparentBoundingBox2 stopAllActions];
    [self unscheduleAllSelectors];    
    return TRUE;
}

-(BOOL) startTimer
{
    if (!playButtonReady) {
        [self schedule:@selector(updateTimer:) interval:1.0f];
        [self schedule:@selector(runAI:) interval:2.0f];
        if (playerTurn == 2) {
            [self clearLetters];
            [self clearCurrentAnswer];
        }
    }
    
    return TRUE;
}

- (BOOL) nextLevelPressed
{
    int batchSize, currentLevel,nextLevel;
    
    //NEXT -- CURRENT LEVEL - CALCULATE NEXT LEVEL
    currentLevel = [GameManager sharedGameManager].singlePlayerLevel;
    
    if (currentLevel <= 5){
        nextLevel = currentLevel+1;
    }
    else{
        //OPEN ISSUE: Determine what to do if at the top level
        nextLevel = currentLevel;
    }
    
    NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] 
                                      objectForKey:[NSString stringWithFormat:@"Level%i",nextLevel]];
    batchSize = [[levelInfo objectForKey:@"batchSize"] intValue];
    
    [[GameManager sharedGameManager] setSinglePlayerBatchSize:batchSize];
    [[GameManager sharedGameManager] setSinglePlayerLevel:nextLevel];
    [ [GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];
    
    return TRUE;
    
}

- (BOOL) getResultsPressed
{
    [[GameManager sharedGameManager] setPlayer1Score:[player1Score string]];
    [[GameManager sharedGameManager] setPlayer2Score:[player2Score string]];
    [[GameManager sharedGameManager] setPlayer1Words:player1Words];
    [[GameManager sharedGameManager] setPlayer2Words:player2Words];
    [[GameManager sharedGameManager] setGameMode:kSinglePlayer];
    
    [[GameManager sharedGameManager] runLoadingSceneWithTargetId:kWordSummaryScene];
}

- (BOOL) rematchBtnPressed
{
   [[GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene]; 
}

- (BOOL) mainMenuBtnPressed
{
   [[GameManager sharedGameManager] runLoadingSceneWithTargetId:kMainMenuScene]; 
}


- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {
    
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    /**************
    CCLOG(@"awardsState: %@",(awardsState) ? @"TRUE":@"FALSE");
    if(awardsState){
        
        if(CGRectContainsPoint(nextLevelBtn.boundingBox, touchLocation) && nextLevelBtn.visible){
            int batchSize, currentLevel,nextLevel;
            
            //NEXT -- CURRENT LEVEL - CALCULATE NEXT LEVEL
            currentLevel = [GameManager sharedGameManager].singlePlayerLevel;
            
            if (currentLevel <= 5){
                nextLevel = currentLevel+1;
            }
            else{
                //OPEN ISSUE: Determine what to do if at the top level
                nextLevel = currentLevel;
            }
            
            NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] 
                                              objectForKey:[NSString stringWithFormat:@"Level%i",nextLevel]];
            batchSize = [[levelInfo objectForKey:@"batchSize"] intValue];
            
            [[GameManager sharedGameManager] setSinglePlayerBatchSize:batchSize];
            [[GameManager sharedGameManager] setSinglePlayerLevel:nextLevel];
            [ [GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];
            
        }
        else if(CGRectContainsPoint(getResultsBtn.boundingBox, touchLocation)){
            
            //self.isTouchEnabled=NO;
            [[GameManager sharedGameManager] setPlayer1Score:[player1Score string]];
            [[GameManager sharedGameManager] setPlayer2Score:[player2Score string]];
            [[GameManager sharedGameManager] setPlayer1Words:player1Words];
            [[GameManager sharedGameManager] setPlayer2Words:player2Words];
            [[GameManager sharedGameManager] setGameMode:kSinglePlayer];
            
            [[GameManager sharedGameManager] runLoadingSceneWithTargetId:kWordSummaryScene];
            
            //NEXT: Fix Result Layer init functions and change call from play and pass -- comment out first to test single player
             
        }
        else if(CGRectContainsPoint(rematchBtn.boundingBox, touchLocation)){
            [[GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];
        }
        else if(CGRectContainsPoint(mainMenuBtn.boundingBox, touchLocation)){
            [[GameManager sharedGameManager] runLoadingSceneWithTargetId:kMainMenuScene];
        }
       
    

   
        return TRUE;
    }
     ************/
    //MCH - DISPLAY THE PAUSE MENU
    if(CGRectContainsPoint(pauseMenuPlayAndPass.pauseButton.boundingBox, touchLocation) && !pauseState){
        pauseState = TRUE;
        [pauseMenuPlayAndPass showPauseMenu:self];
        [self hideAIActivity];
    }
	
    // FUNCTIONS ON THE PAUSE MENU                     
    if (pauseState) {
        CCLOG(@"In a pause state.");
        pauseState = [pauseMenuPlayAndPass execPauseMenuActions:touchLocation forScene:self withId:kSinglePlayerScene]; 
        return TRUE;
    }

        
    //PLAY BUTTON PRESSED
    if (playButtonReady && CGRectContainsPoint(_playButton.boundingBox, touchLocation)) {
        [self fadeOutLetters];
        _playButton.visible = NO;
        playButtonReady = NO;
        self.tapToChangeLeft.visible = NO;
        self.tapToChangeRight.visible = NO;
        [self schedule:@selector(updateTimer:) interval:1.0f];
        [self schedule:@selector(runAI:) interval:2.0f];
        //[self showLeftChecker];
    } else if (playButtonReady && !tapToNameLeftActive && !tapToNameRightActive && CGRectContainsPoint(player1Name.boundingBox, touchLocation)) {
        [self getPlayer1Name];
    } else if (playButtonReady && !tapToNameLeftActive && !tapToNameRightActive && CGRectContainsPoint(self.tapToChangeLeft.boundingBox, touchLocation)) {
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
            // JK - penalty
            [self openRandomLetters:1];
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

- (void) ccTouchEnded:(UITouch *) touch withEvent:(UIEvent *) event {
}

/*
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
*/

 -(void) runAI:(ccTime) dt {

     CCLOG(@"*********RUN AI*********");
     
     int maxDelay = [[GameManager sharedGameManager] aiMaxWaitTime];
     
     CCLOG(@"*********maxDelay: %i *********",maxDelay);
     
    if (playerTurn == 1 || [[player2Timer string] intValue] <= 0) return;

    [self unschedule:@selector(runAI:)];
    [self showAIActivity];
    int randomInterval = arc4random() % maxDelay + 1;
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
        player2TileFlipped = YES;
        if ([self isVowel:cell.value]) {
            [self addScore:8 toPlayer:playerTurn anchorCell:cell];
        }
        if ([self isThisStarPoint:cell]) {
            cell.star.visible = YES;
        }
    }
}

-(void) aiMoveComplete {
        
    if (playerTurn == 1) return;

    [self hideAIActivity];
    
    if ([[player2Timer string] intValue] <= 0) return;
    
    CCLOG(@"AI MOVE COMPLETE");
    if ([userSelection count] > 0) {
        [self checkAnswer];
    } else {
        // JK - penalty
        [self openRandomLetters:1];
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
        
    batchSize = 500;
    
    for(int i = 0; !match && i < batchSize; i++) {
        int idx = arc4random() % [aiAllWords count];
        ans = [aiAllWords objectAtIndex:idx];
        //CCLOG(@"AI ANSWERS = %@", ans);
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

- (BOOL) determineNextLevelLock:(int)currentLevel BeatAIFlag:(BOOL)beatAIFlag AllGameLevelDict:(NSMutableDictionary *)allGameLevels
{
    int nextLevel;


    if (currentLevel < 5) {
        
        nextLevel = currentLevel+1;
        
        NSString *lookupKeyNextLevel = [NSString stringWithFormat:@"Level%i",nextLevel];
        NSMutableDictionary *nextLevelInfo = [ allGameLevels objectForKey:lookupKeyNextLevel];
        
        BOOL nextLevelLocked = [[nextLevelInfo objectForKey:@"levelLocked"] boolValue];
        
        //IF NEXT LEVEL IS UNLOCKED OR THE PLAYER JUST BEAT THE AI, ENABLE THE NEXT LEVEL BUTTON
        if(!nextLevelLocked || beatAIFlag){
            //ENABLE
            nextLevelBtn.visible=YES;
            getResultsBtn.position = ccp(218,125);
            rematchBtn.position = ccp(283,124);
            mainMenuBtn.position = ccp(348,124); 
        }
        else{
            getResultsBtn.position = ccp(210-43,125);
            rematchBtn.position = ccp(275-43,124);
            mainMenuBtn.position = ccp(340-43,124); 
        }
        
        //UNLOCK THE NEXT LEVEL IF THEY JUST BEAT THE AI AND NEXT LEVEL IS CURRENTLY LOCKED
        if( nextLevelLocked && beatAIFlag){
            [nextLevelInfo setObject:[NSNumber numberWithBool:FALSE] forKey:@"levelLocked"];
        }
        
    }
    //IF IT'S THE LAST LEVEL THEN DISABLE THE NEXT LEVEL BUTTON
    else{
        getResultsBtn.position = ccp(210-43,124);
        rematchBtn.position = ccp(275-43,124);
        mainMenuBtn.position = ccp(340-43,124); 
    } 
    
    return TRUE;
    
    
}
- (void) determineAwardsForSinglePlayer:(int)p1Score AIScore:(int)aiScore Player1Words:(NSMutableArray *)player1WordsArray
{
    NSMutableDictionary *allGameLevels = [[GameManager sharedGameManager] getGameLevelDictionary];
    NSString *currentLevel = [NSString stringWithFormat:@"Level%i",[GameManager sharedGameManager].singlePlayerLevel];
    NSMutableDictionary *levelInfo = [ allGameLevels objectForKey:currentLevel];
    
    BOOL alreadyHasBeatAIAward = [[levelInfo objectForKey:@"beatAIAward"] boolValue];
    BOOL alreadyHasTotalPointsAward = [[levelInfo objectForKey:@"totalPointsAward"] boolValue];
    BOOL alreadyHasLongWordAward = [[levelInfo objectForKey:@"totalPointsAward"] boolValue];
    
    //BOOL beatAIAward,totalPointsAward,longWordAward;
    BOOL updatePList = NO;
    
    //BEAT AI AWARD        
    //IF THE PLAYER BEAT THE AI
    if (p1Score > aiScore) {
        self.thisGameBeatAIAward = TRUE;
    }
    else{
        self.thisGameBeatAIAward = FALSE;
    }
    //UNLOCK THE NEXT LEVEL (if currently locked)
    [self determineNextLevelLock:[GameManager sharedGameManager].singlePlayerLevel BeatAIFlag:self.thisGameBeatAIAward AllGameLevelDict:allGameLevels];

    if (!alreadyHasBeatAIAward) {
        updatePList = YES;
        [levelInfo setObject:[NSNumber numberWithBool:self.thisGameBeatAIAward] forKey:@"beatAIAward"];
    }
    
         
    //TOTAL POINT AWARD
    int totalPointsForStar = [[levelInfo objectForKey:@"totalPointsForStar"] intValue];
    //IF THE PLAYER PASSED THE TOTAL POINTS THRESHOLD
    (p1Score >= totalPointsForStar) ? self.thisGameTotalPointsAward = TRUE : self.thisGameTotalPointsAward = FALSE;
    
    if (!alreadyHasTotalPointsAward) {
        updatePList = YES;
        [levelInfo setObject:[NSNumber numberWithBool:self.thisGameTotalPointsAward] forKey:@"totalPointsAward"];
    }
    
    //LONG WORD AWARD
    int wordLengthForStar = [[levelInfo objectForKey:@"wordLengthForStar"] intValue];
    int longestWordLength = [self getLongestWordLengthInArray:player1WordsArray];
    //IF THE LONGEST WORD IS GREATER THAN THE THRESHOLD
    (longestWordLength >= wordLengthForStar) ? self.thisGameLongWordAward = TRUE : self.thisGameLongWordAward = FALSE;
    
    if (!alreadyHasLongWordAward) {
        updatePList = YES;
        [levelInfo setObject:[NSNumber numberWithBool:thisGameLongWordAward] forKey:@"longWordAward"];
    }
    
    //UPDATE THE PLIST FILE IF ANY NEW AWARDS WERE WON THIS GAME
    if (updatePList) {
        [allGameLevels setObject:levelInfo forKey:currentLevel];
        NSString *path = [[GameManager sharedGameManager] getGameLevelPListPath];
        [allGameLevels writeToFile:path atomically:YES];
    }                  
    
}

- (void) displayAwardsPopup
{
    NSString *achievedLevelStatus=@"INCOMPLETE";
    
    awardsMenu.isTouchEnabled=TRUE;
    awardsMenu.visible=TRUE;
    
    
    awardsState = TRUE;
    
    awardPopupTintedBackground.visible = YES;
    awardPopupFrame.visible = YES; 
    getResultsBtn.visible = YES; 
    rematchBtn.visible = YES;
    mainMenuBtn.visible = YES;
    levelDisplay.visible = YES;
    levelStatus.visible = YES;
    singlePlayerScore.visible = YES;
    
    if (self.thisGameBeatAIAward) {
        thisGameBeatAIAwardSprite.visible = YES;
        achievedLevelStatus = @"COMPLETED";
    }
    if (self.thisGameTotalPointsAward) {
        thisGameTotalPointsAwardSprite.visible = YES;
    }
    if (self.thisGameLongWordAward) {
        thisGameLongWordAwardSprite.visible = YES;
    }
        

    [levelDisplay setString:[NSString stringWithFormat:@"LEVEL %i",
                             [GameManager sharedGameManager].singlePlayerLevel]];

    [levelStatus setString:[NSString stringWithFormat:@"STATUS: %@",
                            achievedLevelStatus]];
    [singlePlayerScore setString:[NSString stringWithFormat:@"SCORE: %@",
                                  [player1Score string]]];

    
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
    
    if (p1 <= 0) {
		play1Done = YES;
	}
	
	if (p2 <= 0) {
		play2Done = YES;
        [self hideAIActivity];
	}
	
	if (p1+p2 <= 0) {
		gameOver = YES;
	}
    
    // End game if human players don't have time and AI is winning.
    if (p1 <= 0 && [[player2Score string] intValue] > [[player1Score string] intValue]) {
        gameOver = YES;
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
        [self determineAwardsForSinglePlayer:[[player1Score string] intValue] AIScore:[[player2Score string] intValue] Player1Words:player1Words];
        
        
        [self displayAwardsPopup];
        
        //MCH - display results layer
        /*******
        [[CCDirector sharedDirector] replaceScene:[ResultsLayer scene:[player1Score string]
                                                   WithPlayerTwoScore:[player2Score string] 
                                                   WithPlayerOneWords:player1Words 
                                                   WithPlayerTwoWords:player2Words
                                                       ForGameMode:kSinglePlayer
                                                   ]];   
         ********/
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
    [activityIndicator release];
	[super dealloc];
}

@end