//
//  ResultsLayer.m
//  HundredSeconds
//
//  Created by Michael Ho on 3/23/11.
//  Copyright 2011 self. All rights reserved.
//

#import "ResultsLayer.h"
#import "GameManager.h"
#import "Parse/Parse.h"

@implementation ResultsLayer

//@synthesize batchNode;
//@synthesize player1Score;
//@synthesize player2Score;
//@synthesize rematchButton;
//@synthesize mainMenuButton;
//del @synthesize definition;

//@synthesize dupPlayer1Words;
//@synthesize dupPlayer2Words;
//@synthesize p1WordLabels;
@synthesize winSize;
@synthesize currentPage;
//@synthesize pageNumDisplay;
//@synthesize arrayPagesPlayer1;
//@synthesize arrayPagesPlayer2;
@synthesize player1TotalPages;
@synthesize player2TotalPages;
//del @synthesize surfBackground;
//del @synthesize surfBackground2;
//@synthesize whiteBackground;
//@synthesize nextPageButton;
//@synthesize prevPageButton;
//@synthesize nextPageButtonDisabled;
//@synthesize prevPageButtonDisabled;
//@synthesize woodenSign;
//delete @synthesize flagMultiPlayer;

#define HDR_POS_X_P1 (18.0f/63.0f)
#define HDR_POS_X_P2 (44.0f/63.0f)
#define HDR_POS_Y (290.0f/320.0f)

#define SCORE_POS_X_P1  (19.0f/63.0f)
#define SCORE_POS_X_P2 (44.0f/63.0f)

#define SCORE_POS_Y     (225.0f/320.0f)

#define WORDS_POS_Y     (200.0f/320.0f)
#define WORDS_POS_X_P1     (48.0f/63.0f)
#define WORDS_POS_X_P2     (16.0f/63.0f)

#define WORDS_POS_X_P1_COL1OF2 (40.0f/63.0f)
#define WORDS_POS_X_P1_COL2OF2 (56.0f/63.0f)

#define WORDS_POS_X_P2_COL1OF2 (8.0f/63.0f)
#define WORDS_POS_X_P2_COL2OF2 (24.0f/63.0f)

//#define WORDS_SPACING   (14.0f/320.f)
#define WORDS_SPACING   (12.0f/320.f)

#define MAX_WORDS_PER_PAGE  11


//+(id) scene:(NSString *) p1Score WithPlayerTwoScore:(NSString *) p2Score WithPlayerOneWords:(NSMutableArray *) p1Words WithPlayerTwoWords:(NSMutableArray *) p2Words ForGameMode:(GameMode)gameMode{
+(id) scene{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
	ResultsLayer	*layer = [ResultsLayer node];
    /****
    [layer initWithPlayerOneScore:p1Score 
               WithPlayerTwoScore:p2Score 
               WithPlayerOneWords:p1Words 
               WithPlayerTwoWords:p2Words
                      ForGameMode:gameMode]; 
     */
	[scene addChild:layer];  
    
	// return the scene
	return scene;
}

-(int) getLongestWordIndexInArray:(NSMutableArray *) playerWordsArray
{
    
    NSString *tmpWord;
    int longestLength=0, longestWordIndex=-1, currentWordLength, i=0;
    
    for (i=0;i < playerWordsArray.count;i++)  {
        
        tmpWord = [playerWordsArray objectAtIndex:i];
        currentWordLength = [tmpWord length];
        if(currentWordLength > longestLength){
            longestLength = currentWordLength;
            longestWordIndex = i;
        }
    }
    
    return longestWordIndex;
    
}


//-(BOOL) initWithPlayerOneScore:(NSString *) p1Score WithPlayerTwoScore:(NSString *) p2Score WithPlayerOneWords:(NSMutableArray *) p1Words WithPlayerTwoWords:(NSMutableArray *) p2Words ForGameMode:(GameMode)gameMode
-(id) init
{
    winSize = [[CCDirector sharedDirector] winSize];
    arrayPagesPlayer1 = [[NSMutableArray array] retain];
    arrayPagesPlayer2 = [[NSMutableArray array] retain];
    
	if( (self=[super initWithColor:ccc4(0, 0, 0, 225)] )) {
        
    
        theGameMode = [[GameManager sharedGameManager] gameMode];
        
        //SETUP SPRITE SHEET
        if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"result_layer_retina.plist"];
            batchNode = [[CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"result_layer_retina.png"]] retain];           
        }
        else{
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"result_layer_3g.plist"];
            batchNode = [[CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"result_layer_3g.png"]] retain];    
        }
        
        [self addChild:batchNode];
        
        //SETUP BACKGROUND
        whiteBackground = [[CCSprite spriteWithFile:@"Surfboard03_kparrish.png"] retain];
        whiteBackground.position = ccp(240,160);
        [self addChild:whiteBackground];
        
        //GET THE PLAYER 1 AND PLAYER 2 SCORE FROM GAME MANAGER
        NSString *p1Score = [[GameManager sharedGameManager] player1Score];
        NSString *p2Score = [[GameManager sharedGameManager] player2Score];
        
        //MAKE A COPY OF THE WORDS ARRAY FOR PAGING
        NSMutableArray *p1Words = [[GameManager sharedGameManager] player1Words];
        NSMutableArray *p2Words = [[GameManager sharedGameManager] player2Words];
        dupPlayer1Words = [[NSMutableArray array] retain];
        dupPlayer2Words = [[NSMutableArray array] retain];
        [dupPlayer1Words setArray:p1Words];
        [dupPlayer2Words setArray:p2Words];
        
        p1WordLabels = [[NSMutableArray array] retain];
        
        currentPage=0;
        
		[GameManager sharedGameManager].gameStatus = kGameFinished;
		NSLog(@"Inside results layer.");
		self.isTouchEnabled = YES;
        
        //QUERY FOR LONGEST WORD
        PFQuery *query = [PFQuery queryWithClassName:@"LongestWord"];
        query.limit = [NSNumber numberWithInt:10];
        [query orderByDescending:@"longestWordInGame"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d scores.", objects.count);
                
                if (objects.count > 0) {
                    PFObject *longestWordResult = [objects objectAtIndex:0];
                    int longestWordLength = [[longestWordResult objectForKey:@"longestWordLength"] intValue];
                    NSString *longestWordLetters = [longestWordResult objectForKey:@"longestWordLetters"];
                    NSLog(@"LONGEST WORD LENGTH:%d, LONGEST WORD:%@", longestWordLength, longestWordLetters);
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
        //DETERMINE LONGEST WORD FOR EACH PLAYER AND 
        NSString *player1LongestWord, *player2LongestWord;
        int p1LongestWordIndex, p2LongestWordIndex;
        
        
        p1LongestWordIndex = [self getLongestWordIndexInArray:dupPlayer1Words];
        if (!dupPlayer1Words || (p1LongestWordIndex == -1)) {
            player1LongestWord=@"";
        }
        else{
            player1LongestWord = [dupPlayer1Words objectAtIndex:p1LongestWordIndex];
        }
        
        
        //PLAYER 1 ON RIGHT FOR NOW, DON'T WRITE AI's SCORES  -- SWITCH SOON AFTER GETTING JAE'S CODE
        if (theGameMode != kSinglePlayer) {
            p2LongestWordIndex = [self getLongestWordIndexInArray:dupPlayer2Words];
            
            if(!dupPlayer2Words || (p2LongestWordIndex == -1)){
              player2LongestWord=@"";      
            }
            else{
                player2LongestWord = [dupPlayer2Words objectAtIndex:p2LongestWordIndex];
            }
        }
        
        CCLOG(@"PLAYER 1 LONGEST WORD:%@",player1LongestWord);
        //CCLOG(@"PLAYER 1 LONGEST WORD:%@ , PLAYER 2 LONGEST WORD:%@",player1LongestWord, player2LongestWord);
        
		NSString *p1Name = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"player1_name"];
        if (!p1Name) {
            p1Name=@"Player 1";
        }
        
        NSString *p2Name,*tmp;
        
        if (theGameMode == kSinglePlayer) {
            p2Name = @"AI";
        }
        else{
            tmp = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"player2_name"];
            (tmp) ? p2Name = tmp : p2Name = @"Player 2";
        }
        

        //WRITE TO PARSE
        PFObject *longestWordObject = [PFObject objectWithClassName:@"LongestWord"];
        [longestWordObject setObject:p1Name forKey:@"playerName"];
        [longestWordObject setObject:[NSNumber numberWithInt:[player1LongestWord length]] forKey:@"longestWordLength"];
        [longestWordObject setObject:player1LongestWord forKey:@"longestWordLetters"];
        [longestWordObject setObject:[GameManager sharedGameManager].gameUUID forKey:@"gameUUID"];
        [longestWordObject saveInBackground];
        
        
        /*****************************/
		//PLAYER 1
        /*****************************/
        //HEADER
        //CCLabelTTF *player1Header = [[CCLabelTTF labelWithString:@"Player 1 Score"
        
		CCLabelTTF *player1Header = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ Score",p1Name]
										   fontName:@"MarkerFelt-Thin" 
										   fontSize:24] retain];
		player1Header.color = ccc3(0,0,255);
		player1Header.position = ccp(HDR_POS_X_P1 * winSize.width, HDR_POS_Y * winSize.height);
		[self addChild:player1Header z:1];
        
        //SCORE 
		player1Score = [[CCLabelTTF labelWithString:p1Score
										   fontName:@"Marker Felt" 
										   fontSize:20] 
						retain];
		player1Score.color = ccc3(255,255,0);
		player1Score.position = ccp(winSize.width * SCORE_POS_X_P1, winSize.height * SCORE_POS_Y);
		[self addChild:player1Score];
		
                
        //ALLOCATE A RESULTS PAGE
        [arrayPagesPlayer1 addObject:[ [ [ResultPages alloc] init:winSize]  autorelease]];
        ResultPages *pResultPagePlayer1 = [arrayPagesPlayer1 objectAtIndex:0];
        
        int playerNum=1,pageNum=0;
        
        //OPEN: HANDLE CASE OF NO WORDS TO PRINT OUT
        if(![pResultPagePlayer1 getPageLayout:p1Words forPlayer:playerNum forPageNum:pageNum])
        {            
            int partialPages=0;
            int fullPages = [p1Words count] / (pResultPagePlayer1.maxWordsPerColumn * pResultPagePlayer1.maxColumnsPerPlayer);
            
            if ([p1Words count] % (pResultPagePlayer1.maxWordsPerColumn * pResultPagePlayer1.maxColumnsPerPlayer) > 0)
            {
                partialPages=1;
            }
            player1TotalPages = fullPages + partialPages;

        }
        
        // NEED TO DETERMINE PAGE NUM 
        [self displayPlayerWords2:1 withWords:p1Words withResultPage:pResultPagePlayer1];
 		/*****************************/
		//PLAYER 2
        /*****************************/
        
        //HEADER
		CCLabelTTF *player2Header = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ Score",p2Name]
														fontName:@"MarkerFelt-Thin" 
														fontSize:24] retain];
		player2Header.color = ccc3(0,0,255);
		player2Header.position = ccp(HDR_POS_X_P2 * winSize.width, HDR_POS_Y * winSize.height);
		[self addChild:player2Header];
        
 		//SCORE
        player2Score = [[CCLabelTTF labelWithString:p2Score
										   fontName:@"Marker Felt" 
										   fontSize:20] 
						retain];
		player2Score.color = ccc3(255,255,0);
		player2Score.position = ccp(winSize.width * SCORE_POS_X_P2, winSize.height * SCORE_POS_Y);
		[self addChild:player2Score];
		
        
        //WORDS
        //[self displayPlayerWords:2 withWords:p2Words startAt:0 xPosColumn1of1At:WORDS_POS_X_P2 xPosColumn1of2At:WORDS_POS_X_P2_COL1OF2 xPosColumn2of2At:WORDS_POS_X_P2_COL2OF2];
       	//ALLOCATE A RESULTS PAGE
        [arrayPagesPlayer2 addObject:[ [ [ResultPages alloc] init:winSize]  autorelease]];
        ResultPages *pResultPagePlayer2 = [arrayPagesPlayer2 objectAtIndex:0];
        
        if(![pResultPagePlayer2 getPageLayout:p2Words forPlayer:2 forPageNum:0])
        {            
            int partialPages=0;
            int fullPages = [p2Words count] / (pResultPagePlayer2.maxWordsPerColumn * pResultPagePlayer2.maxColumnsPerPlayer);
            
            if ([p2Words count] % (pResultPagePlayer2.maxWordsPerColumn * pResultPagePlayer2.maxColumnsPerPlayer) > 0)
            {
                partialPages=1;
            }
            player2TotalPages = fullPages + partialPages;
        }
        
        [self displayPlayerWords2:2 withWords:p2Words withResultPage:pResultPagePlayer2];
	
        
        //SETUP WOODEN SIGN
        //woodenSign = [CCSprite spriteWithFile:@"blank-wooden-sign-3b.png"];
        woodenSign = [[CCSprite spriteWithSpriteFrameName:@"blank-wooden-sign.png"] retain];
        woodenSign.position = ccp(240,50);
        [self addChild:woodenSign];

		NSMutableString *winText = [NSMutableString string];
		if ([p1Score intValue] == [p2Score intValue]){
			[winText setString:@"Tie Game!"];
		}
		else if([p1Score intValue] > [p2Score intValue]){
			[winText setString:[NSString stringWithFormat:@"%@ Wins",p1Name]];
		}
		else {
			[winText setString:[NSString stringWithFormat:@"%@ Wins",p2Name]];
		}

        //WINNER BANNER
		CCLabelTTF *midDisplay = [[CCLabelTTF labelWithString:winText 
													 fontName:@"MarkerFelt-Thin" 
													 fontSize:22] 
								  retain];
		midDisplay.position = ccp(240, 60);
        midDisplay.color = ccc3(255, 255, 0);
		[self addChild:midDisplay z:30];
		
        //NEXT PAGE BUTTON
        nextPageButton = [[CCSprite spriteWithSpriteFrameName:@"next.png"] retain];
        nextPageButton.position = ccp(320,48);
        nextPageButton.visible = NO;
        [self addChild:nextPageButton];
        
        //PREV PAGE BUTTON
        prevPageButton = [[CCSprite spriteWithSpriteFrameName:@"prev.png"] retain];
        prevPageButton.position = ccp(152,51);
        prevPageButton.visible = NO;
        [self addChild:prevPageButton];
        
        //NEXT PAGE BUTTON DISABLED
        nextPageButtonDisabled = [[CCSprite spriteWithSpriteFrameName:@"next_disabled.png"] retain];
        nextPageButtonDisabled.position = ccp(320,48);
        nextPageButtonDisabled.visible = YES;
        [self addChild:nextPageButtonDisabled];
        
        //PREV PAGE BUTTON DISABLED
        prevPageButtonDisabled = [[CCSprite spriteWithSpriteFrameName:@"prev_disabled.png"] retain];
        prevPageButtonDisabled.position = ccp(152,51);
        prevPageButtonDisabled.visible = YES;
        [self addChild:prevPageButtonDisabled];

        
        //PAGE DISPLAY - DISPLAY "page 1 of X" IF MORE THAN ONE PAGE OF WORDS
        //if([p1Words count] > MAX_WORDS_PER_PAGE || [p2Words count] > MAX_WORDS_PER_PAGE ){
        if(player1TotalPages > 1 || player2TotalPages > 1 ){
            
            nextPageButton.visible = YES;
            nextPageButtonDisabled.visible = NO;
            
            int totalPages = (player1TotalPages > player2TotalPages) ? player1TotalPages : player2TotalPages;
            
            pageNumDisplay = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"1 of %i",totalPages] 
                                                          fontName:@"MarkerFelt-Thin" 
                                                          fontSize:16] 
                                                            retain];
            pageNumDisplay.position = ccp(240, 40);
            //pageNumDisplay.color = ccc3(0, 0, 255);
            pageNumDisplay.color = ccc3(255, 255, 0);
            
            [self addChild:pageNumDisplay];
        }
        
        
        
        //REMATCH BUTTON   
		rematchButton = [[CCSprite spriteWithSpriteFrameName:@"rematch.png"] retain];
		rematchButton.position = ccp(430, 40);
		[self addChild:rematchButton];
        
        //MAIN MENU BUTTON   
		mainMenuButton = [[CCSprite spriteWithSpriteFrameName:@"main_menu_btn.png"] retain];
		mainMenuButton.position = ccp(50, 40);
		[self addChild:mainMenuButton];
        
		//[[GameManager sharedGameManager] closeGame];
		//[OFMultiplayerService startViewingGames];
	}
    return self;
    
}


- (void) displayPlayerWords2:(int) playerNumber
                                withWords:(NSMutableArray *)pWords
                                withResultPage:(ResultPages *)pResultPage

{
    //PROCESS EACH COLUMN
    for(int i=0;i < pResultPage.numColumnsToDisplay;i++)
    {
        //MCH - THINK ABOUT MOVING THIS TO RESULT PAGES
        float y = winSize.height * WORDS_POS_Y;
        
        //DISPLAY EACH WORD IN THE COLUMN
        int colWordsArrayStartIndex = pResultPage.pageWordsArrayStartIndex + (i*pResultPage.maxWordsPerColumn);
        int colWordsArrayEndIndex = colWordsArrayStartIndex + (pResultPage.pNumWordsInColumn)[i];
        
        for(int j=colWordsArrayStartIndex;
            j<colWordsArrayEndIndex;
            j++)
        {
            
            NSString *s = [pWords objectAtIndex:j];
            //NSLog(@"Player 1 WORDS: %@",s );
            CCLabelTTF *wordLabel = [[CCLabelTTF labelWithString:s fontName:@"Marker Felt" fontSize:12] retain];//MCH - used to be 12
            wordLabel.color = ccc3(255,255,255);
            wordLabel.position = ccp((pResultPage.pColumnIndentFromLeftEdge)[i], y);
            //MCH
            //NOW CENTER -- wordLabel.anchorPoint = ccp(0,0);
            //TO DO -- DETERMINE STRATEGY FOR UNIQUE TAGS - word number?
            wordLabel.tag = j + (playerNumber * 100);
            
            [p1WordLabels addObject:wordLabel];
            [self addChild:wordLabel];
            y = y - (WORDS_SPACING * winSize.height);

        }
        
    }
    
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL) clearCurrentPage:(int) playerNum
{
    ResultPages *pResultPagePlayer;
    int startIndex;
    
    if (playerNum == 1)
    {
        pResultPagePlayer = [arrayPagesPlayer1 objectAtIndex:currentPage];
        startIndex = 100;
    }
    else
    {
        pResultPagePlayer = [arrayPagesPlayer2 objectAtIndex:currentPage];
        startIndex = 200; 
    }
    
    //CLEAR WORDS FROM CURRENT PAGE
    int startClearIndex=startIndex+currentPage*pResultPagePlayer.maxWordsPerColumn*pResultPagePlayer.maxColumnsPerPlayer;
    for(int i=startClearIndex;
        i<startClearIndex+pResultPagePlayer.numWordsOnPage;i++){
        [self removeChildByTag:i cleanup:YES];
    }
    
    return 0;

    
}
- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {
	
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    

    
    // TO DO: CHECK THAT THE NEXT PAGE BUTTON IS ENABLED/VISIBLE
    if (CGRectContainsPoint(nextPageButton.boundingBox, touchLocation) && (nextPageButton.visible == YES)) {
 
        
        //BOOL incrementPage=0;
        ResultPages *pResultPagePlayer1,*pResultPagePlayer2;
        //CLEANUP CURRENT PAGE FOR PLAYER 1 AND 2
        
        //CHECK THAT A RESULT PAGE EXISTS FOR THE PLAYER FOR A GIVEN PAGE
        //SINCE ONE PLAYER MAY HAVE MULT PAGES OF WORDS WHILE THE OTHER DOES NOT
        if(currentPage < player1TotalPages)
        {
            [self clearCurrentPage:1];
            
        }
        
        //CHECK THAT A RESULT PAGE EXISTS FOR THE PLAYER FOR A GIVEN PAGE
        //SINCE ONE PLAYER MAY HAVE MULT PAGES OF WORDS WHILE THE OTHER DOES NOT
        if(currentPage < player2TotalPages)
        {
            [self clearCurrentPage:2];
                        
        }
       

        currentPage++;
        //DISPLAY THE NEW PAGE
        if (currentPage < player1TotalPages)
        {
            // IF WE HAVEN'T DISPLAYED THE PAGE PREVIOUSLY ALLOCATE A RESULT PAGE
            if (currentPage < [arrayPagesPlayer1 count]) 
            {
                pResultPagePlayer1 = [arrayPagesPlayer1 objectAtIndex:currentPage];
                
            }
            else
            {
                pResultPagePlayer1 = [[[ResultPages alloc] init:winSize] autorelease];
                [arrayPagesPlayer1 addObject:pResultPagePlayer1];

            }
            
            [pResultPagePlayer1 getPageLayout:dupPlayer1Words forPlayer:1 forPageNum:currentPage];
            [self displayPlayerWords2:1 withWords:dupPlayer1Words withResultPage:pResultPagePlayer1];
        }
        if (currentPage < player2TotalPages)
        {
            // IF WE HAVEN'T DISPLAYED THE PAGE PREVIOUSLY ALLOCATE A RESULT PAGE
            if (currentPage < [arrayPagesPlayer2 count]) 
            {
                pResultPagePlayer2 = [arrayPagesPlayer2 objectAtIndex:currentPage];
            }
            else
            {
                pResultPagePlayer2 = [[[ResultPages alloc] init:winSize] autorelease];
                [arrayPagesPlayer2 addObject:pResultPagePlayer2];
            }

            [pResultPagePlayer2 getPageLayout:dupPlayer2Words forPlayer:2 forPageNum:currentPage];
            [self displayPlayerWords2:2 withWords:dupPlayer2Words withResultPage:pResultPagePlayer2];
        }
        
        //DISPLAY THE PAGE NUMBER
        int totalPages = (player1TotalPages > player2TotalPages) ? player1TotalPages : player2TotalPages;        
        NSString *pageListing = [NSString stringWithFormat:@"Page %i of %i",currentPage+1,totalPages];
        [pageNumDisplay setString:pageListing];
        
        //TO DO: CREATE A FUNCTION TO MANAGE THE PREV AND NEXT PAGE BUTTONS
        prevPageButton.visible = YES;
        prevPageButtonDisabled.visible = NO;
        
        //IF NOT THE LAST PAGE THEN KEEP THE NEXT PAGE ENABLED
        if (currentPage < (totalPages - 1)) {
            nextPageButton.visible = YES;
            nextPageButtonDisabled.visible = NO;
        }
        else{
            nextPageButton.visible = NO;
            nextPageButtonDisabled.visible = YES;
        }
        
     } //END NEXT PAGE BUTTON
    
    //CHECK IF THE PREVIOUS BUTTON WAS PRESSED
    if (CGRectContainsPoint(prevPageButton.boundingBox, touchLocation) && (prevPageButton.visible == YES)) {
        
        ResultPages *pResultPagePlayer1,*pResultPagePlayer2;
        //CHECK THAT A RESULT PAGE EXISTS FOR THE PLAYER FOR A GIVEN PAGE
        //SINCE ONE PLAYER MAY HAVE MULT PAGES OF WORDS WHILE THE OTHER DOES NOT
        if(currentPage < player1TotalPages)
        {
            [self clearCurrentPage:1];
            
        }
        
        //CHECK THAT A RESULT PAGE EXISTS FOR THE PLAYER FOR A GIVEN PAGE
        //SINCE ONE PLAYER MAY HAVE MULT PAGES OF WORDS WHILE THE OTHER DOES NOT
        if(currentPage < player2TotalPages)
        {
            [self clearCurrentPage:2];
             
        }
        
        //NOW DISPLAY THE PREVIOUS PAGE
        currentPage--;
        
        if (currentPage < player1TotalPages)
        {
            pResultPagePlayer1 = [arrayPagesPlayer1 objectAtIndex:currentPage];
              
            [pResultPagePlayer1 getPageLayout:dupPlayer1Words forPlayer:1 forPageNum:currentPage];
            [self displayPlayerWords2:1 withWords:dupPlayer1Words withResultPage:pResultPagePlayer1];
        }
        if (currentPage < player2TotalPages)
        {
            pResultPagePlayer2 = [arrayPagesPlayer2 objectAtIndex:currentPage];
               
            [pResultPagePlayer2 getPageLayout:dupPlayer2Words forPlayer:2 forPageNum:currentPage];
            [self displayPlayerWords2:2 withWords:dupPlayer2Words withResultPage:pResultPagePlayer2];
        }
        
        int totalPages = (player1TotalPages > player2TotalPages) ? player1TotalPages : player2TotalPages;
        
        NSString *pageListing = [NSString stringWithFormat:@"Page %i of %i",currentPage+1,totalPages];
        [pageNumDisplay setString:pageListing];
        
        //TO DO: CREATE A FUNCTION TO MANAGE THE PREV AND NEXT PAGE BUTTONS
        nextPageButton.visible = YES;
        nextPageButtonDisabled.visible = NO;
        
        //IF NOT FIRST PAGE, KEEP THE PREV BUTTON ENABLED
        if (currentPage > 0) {
            prevPageButton.visible = YES;
            prevPageButtonDisabled.visible = NO;
        }
        else{
            prevPageButton.visible = NO;
            prevPageButtonDisabled.visible = YES;
        }


    }
    
    if (CGRectContainsPoint(mainMenuButton.boundingBox, touchLocation)) {
        [[GameManager sharedGameManager] runSceneWithId:kMainMenuScene];
    }

	
	if (CGRectContainsPoint(rematchButton.boundingBox, touchLocation)) {
        
        switch (theGameMode) {
            case kPlayAndPass:
                [[GameManager sharedGameManager] runSceneWithId:kPlayAndPassScene];
                break;
            case kSinglePlayer:
                [[GameManager sharedGameManager] runSceneWithId:kSinglePlayerScene];
                break;
            case kMultiplayer:
                [[GameManager sharedGameManager] runSceneWithId:kMutiPlayerScene];
            default:
                break;
        }
 
        
             /*
            [[GameManager sharedGameManager] closeGame];
            CCLOG(@"--------------------------------------------");
            CCLOG(@"Rematch button pressed");
            NSString *opponentId = nil;
            NSString *localUserId = [[OpenFeint localUser] userId];
            if ( [localUserId isEqualToString:[GameManager sharedGameManager].challengerId] ) {
                CCLOG(@"Local user is a pervious challenger");
                opponentId = [GameManager sharedGameManager].challengeeId;
            } else {
                CCLOG(@"Local user is a pervious challengee");
                opponentId = [GameManager sharedGameManager].challengerId;
            }
            NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@"CONFIG STUFF", OFMultiplayer::   LOBBY_OPTION_CONFIG,
								 [NSNumber numberWithUnsignedInt:5*60], OFMultiplayer::LOBBY_OPTION_TURN_TIME,
								 [NSArray arrayWithObject:opponentId], OFMultiplayer::LOBBY_OPTION_CHALLENGE_OF_IDS,
								 nil];
            CCLOG(@"Creating Game");
            CCLOG(@"--------------------------------------------");
            OFMultiplayerGame *game = [OFMultiplayerService getSlot:0];
            [game createGame:@"HundredSeconds" withOptions:options];
            [GameManager sharedGameManager].isChallenger = YES;
            [OFUser getUser:opponentId];
             */
        
	}
 
 
    
	return YES;
}

-(void) dealloc {
    
    [batchNode release];
    [pageNumDisplay release];
    [dupPlayer1Words release];
    [dupPlayer2Words release];
    [arrayPagesPlayer1 release];
    [arrayPagesPlayer2 release];
	[player1Score release];
    [player2Score release];
	[rematchButton release];
    [mainMenuButton release];
    [p1WordLabels release];
    [whiteBackground release];
    [nextPageButton release];
    [prevPageButton release];
    [nextPageButtonDisabled release];
    [prevPageButtonDisabled release];
    [woodenSign release];
    
	CCLOG(@"rematchButton released");
   
	//DEBUG WHY IT CRASHEs WHEN DEALLOC WAS CALLED
	[super dealloc];
	CCLOG(@"ResultLayer dealloc end");
}

@end
