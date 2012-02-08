//
//  SinglePlayGameHistory.m
//  HundredSeconds
//
//  Created by Jae Kim on 11/2/11.
//  Copyright 2011 experiencesquad. All rights reserved.
//

#import "ScoreSummary.h"
#import "Parse/Parse.h"
#import "GameManager.h"
#import "Util.h"

#define GAME_SUMMARY_COUNT_TAG 1001
#define SUMMARY_PER_PAGE 10
#define PAGE_INDEX_TAG 777
#define CURRENT_HISTORY_TAG 888
#define NUMBER_OF_COLUMNS 6
#define MENU_TAG 100

@implementation ScoreSummary

+(id) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ScoreSummary *layer = [ScoreSummary node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        self.isTouchEnabled = YES;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        titleRow = [CCLabelTTF labelWithString:@"     Players                           Win   Lost   Tie" fontName:@"Verdana-BoldItalic" fontSize:18.0];
        titleRow.color = ccc3(255, 140, 0);
        titleRow.position = ccp(10, 310);
        titleRow.anchorPoint = ccp(0, 1);
        [self addChild:titleRow];
        
        CCSprite *backGround = [CCSprite spriteWithFile:@"black-background.png"];
        backGround.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:backGround z:-10];
        
        CCSprite *silverLine = [CCSprite spriteWithFile:@"silver_line.png"];
        silverLine.position = ccp(winSize.width/2, 280);
        [self addChild:silverLine z:-10];
        
        CCMenuItem *goBackToMainMenuItem = [CCMenuItemImage 
                                            itemFromNormalSprite:[CCSprite spriteWithFile:@"main_menu_btn_small.png"] 
                                            selectedSprite:[CCSprite spriteWithFile:@"main_menu_btn_small.png"] 
                                            target:self
                                            selector:@selector(goBackToMainMenu)];
        goBackToMainMenuItem.position = ccp(50, 20);
        
        CCMenu *goBackToMainMenu = [CCMenu menuWithItems:goBackToMainMenuItem, nil];
        goBackToMainMenu.position = CGPointZero;
        [self addChild:goBackToMainMenu z:10 tag:MENU_TAG];
        goBackToMainMenu.isTouchEnabled = NO;
        
        noRecordFound = [CCLabelTTF labelWithString:@"No Records yet. Play some more games and come back." 
                                           fontName:@"Marker Felt" 
                                           fontSize:20];
        noRecordFound.position = ccp(winSize.width/2, winSize.height/2);
        noRecordFound.color = ccc3(255, 255, 255);
        [self addChild:noRecordFound];
        noRecordFound.visible = NO;        
        paginationMatrix = [[NSMutableArray alloc] init];
        keysOrderByCreatedAt = [[NSMutableArray alloc] init];
        gameScoreSummary = [[NSMutableDictionary alloc] init];
        
        PFQuery *query = [PFQuery queryWithClassName:@"SinglePlayGameHistory"];
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        [query whereKey:@"gameUUID" equalTo:[[GameManager sharedGameManager] gameUUID]];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithTarget:self
                                    selector:@selector(findCallback:error:)];
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setCenter:CGPointMake(winSize.width/2, winSize.height/2)];
        [[[CCDirector sharedDirector] openGLView] addSubview:spinner];
        [spinner startAnimating];        
    }
    return self;
}

- (void)findCallback:(NSArray *)results error:(NSError *)error {
    
    [spinner stopAnimating];
    CCMenu *menu = (CCMenu *) [self getChildByTag:MENU_TAG];
    menu.isTouchEnabled = YES;
    
    if (!error) {
        // The find succeeded.
        CCLOG(@"RESULT COUNT = %i", (int) results.count);
        for(int i = 0; i < (int) results.count; i++) {
            NSString *player1Name = [[results objectAtIndex:i] objectForKey:@"player1Name"];
            NSString *player2Name = [[results objectAtIndex:i] objectForKey:@"player2Name"];
            NSString *hashKey = [NSString stringWithFormat:@"%@|%@", player1Name, player2Name];
            if ([gameScoreSummary objectForKey:hashKey]) {
                NSMutableArray *existingSummary = [gameScoreSummary objectForKey:hashKey];
                [existingSummary addObject:[results objectAtIndex:i]];
                
            } else {
                // New Key
                [keysOrderByCreatedAt addObject:hashKey];
                NSMutableArray *summary = [NSMutableArray array];
                [summary addObject:[results objectAtIndex:i]];
                [gameScoreSummary setValue:summary forKey:hashKey];
            }
        }
        
        CCLOG(@"GAME SCORE SUMMARY = %i", [gameScoreSummary count]);
        if (results.count > 0) {
            [self initPagination:[gameScoreSummary count]];
            [self displaySummaryatPage:0 from:0 toEnd:MIN([gameScoreSummary count], SUMMARY_PER_PAGE)];
        } else {
            noRecordFound.visible = YES;
        }
    } else {
        // Log details of the failure
        CCLOG(@"Error: %@ %@", error, [error userInfo]);
    }
}

- (int) getCurrentPageIndex {
    CCLabelTTF *currentPage = (CCLabelTTF *) [self getChildByTag:PAGE_INDEX_TAG];
    int page = 0;
    if (currentPage) {
        page = [[currentPage string] intValue] - 1;
    }
    
    return (page > 0 ? page : 0);
}

- (void) incrementPage {
    CCLabelTTF *pageIndex = (CCLabelTTF *) [self getChildByTag:PAGE_INDEX_TAG];
    [pageIndex setString:[NSString stringWithFormat:@"%i", [[pageIndex string] intValue] + 1]];
}

- (void) decrementPage {
    CCLabelTTF *pageIndex = (CCLabelTTF *) [self getChildByTag:PAGE_INDEX_TAG];
    [pageIndex setString:[NSString stringWithFormat:@"%i", [[pageIndex string] intValue] - 1]];
}

- (void) clearCurrentPage {
    
    CCLOG(@"Clear Current Page");
    NSMutableArray *currentPage = [paginationMatrix objectAtIndex:[self getCurrentPageIndex]];
    if (currentPage) {
        for(int i = 0; i < [currentPage count]; i++) {
            CCLabelTTF *label = (CCLabelTTF *) [currentPage objectAtIndex:i];
            if (label) {
                label.visible = NO;
            }
        }
    }
}

- (void) displayPreviousPage {
    
    NSMutableArray *prevPage = [paginationMatrix objectAtIndex:[self getCurrentPageIndex] - 1];
    if ([prevPage count] > 0) {
        for(int i = 0; i < [prevPage count]; i++) {
            CCLabelTTF *label = [prevPage objectAtIndex:i];
            label.visible = YES;
        }
    }
    
    [self decrementPage];
    [self updatePagination];
}

- (void) displayNextPage {
    
    // Check to see if we have visited this page
    NSMutableArray *nextPage = [paginationMatrix objectAtIndex:[self getCurrentPageIndex] + 1];
    CCLOG(@"NEXT PAGE = %@", nextPage);
    if ([nextPage count] > 0) {
        CCLOG(@"DISPLAY NEXT PAGE - LABELS EXIST !!");
        for(int i = 0; i < [nextPage count]; i++) {
            CCLabelTTF *label = [nextPage objectAtIndex:i];
            label.visible = YES;
        }
    } else {
        int start = ([self getCurrentPageIndex] + 1) * SUMMARY_PER_PAGE;
        int end = MIN([gameScoreSummary count], start + SUMMARY_PER_PAGE);
        [self displaySummaryatPage:([self getCurrentPageIndex] + 1) from:start toEnd:end];
    }
    
    [self incrementPage];
    [self updatePagination];
}

- (void) initPagination:(int) count {
    int numPage = count / SUMMARY_PER_PAGE;
    if (count % SUMMARY_PER_PAGE > 0) {
        numPage++;
    }
    for(int i = 0; i < numPage; i++) {
        NSMutableArray *row = [NSMutableArray arrayWithCapacity:NUMBER_OF_COLUMNS];
        [paginationMatrix addObject:row];
    }
    
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    CCLabelTTF *gameSummaryCount = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", count] fontName:@"Marker Felt" fontSize:15];
    gameSummaryCount.color = ccc3(255, 255, 255);
    gameSummaryCount.position = ccp(windowSize.width/2, 20);
    gameSummaryCount.visible = NO;
    [self addChild:gameSummaryCount z:10 tag:GAME_SUMMARY_COUNT_TAG];
    [self updatePagination];
}

- (void) updatePagination {
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    CCLabelTTF *pageIndex = (CCLabelTTF *) [self getChildByTag:PAGE_INDEX_TAG];
    CCLabelTTF *summaryCount = (CCLabelTTF *) [self getChildByTag:GAME_SUMMARY_COUNT_TAG];
    
    if (!pageIndex) {
        pageIndex = [CCLabelTTF labelWithString:@"1" fontName:@"Marker Felt" fontSize:15];
        pageIndex.visible = NO;
        pageIndex.position = ccp(windowSize.width/2, 20);
        [self addChild:pageIndex z:10 tag:PAGE_INDEX_TAG];
    }
    
    [self createCurrentHistoryLabel:[[pageIndex string] intValue]];
    
    CGRect rect = [(CCLabelTTF *) [self getChildByTag:CURRENT_HISTORY_TAG] boundingBox];
    
    if (!previousHistory) {
        previousHistory = [CCLabelTTF labelWithString:@"<< Previous" fontName:@"Marker Felt" fontSize:15];
        previousHistory.position = ccp(windowSize.width/2 - (rect.size.width + 20), 20);
        [self addChild:previousHistory];
    }
    
    if ([[pageIndex string] intValue] > 1) {
        previousHistory.color = ccc3(255, 255, 255);
        previousHistoryActive = YES;
    } else {
        previousHistory.color = ccc3(183, 183, 183);
        previousHistoryActive = NO;
    }
    
    if (!nextHistory) {
        nextHistory = [CCLabelTTF labelWithString:@"Next >>" fontName:@"Marker Felt" fontSize:15];
        nextHistory.position = ccp(windowSize.width/2 + (rect.size.width + 20), 20);
        [self addChild:nextHistory];
    }
    
    if ([[pageIndex string] intValue] * SUMMARY_PER_PAGE < [[summaryCount string] intValue]) {
        nextHistory.color = ccc3(255, 255, 255);
        nextHistoryActive = YES;
    } else {
        nextHistory.color = ccc3(183, 183, 183);
        nextHistoryActive = NO;
    }
}

- (void) createCurrentHistoryLabel:(int) page {
    CCLabelTTF *currentHistory;
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    int startIndex, endIndex;
    int totalCount = [[(CCLabelTTF *) [self getChildByTag:GAME_SUMMARY_COUNT_TAG] string] intValue];
    startIndex = (page - 1) * SUMMARY_PER_PAGE + 1;
    endIndex = startIndex + SUMMARY_PER_PAGE - 1;
    if (endIndex > totalCount) {
        endIndex = totalCount;
    }
    
    currentHistory = (CCLabelTTF *) [self getChildByTag:CURRENT_HISTORY_TAG];
    
    if (currentHistory) {
        [currentHistory setString:[NSString stringWithFormat:@"%i - %i of %i", startIndex, endIndex, totalCount]];
    } else {
        currentHistory = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i - %i of %i", startIndex, endIndex, totalCount] fontName:@"Marker Felt" fontSize:15];
        currentHistory.color = ccc3(255, 255, 255);
        currentHistory.position = ccp(windowSize.width/2, 20);
        [self addChild:currentHistory z:10 tag:CURRENT_HISTORY_TAG];
    }
}

- (void) displaySummaryatPage:(int) pageIdx from:(int) start toEnd:(int) end {
    NSString *localFontName = @"Marker Felt";
    int localFontSize = 20;
    int yStart = 240;
    
    NSMutableArray *currentRow = [paginationMatrix objectAtIndex:pageIdx];
    
    for(int i = start, row = 0; i < end; i++, row++) {
        NSArray *gameRecords = [gameScoreSummary objectForKey:[keysOrderByCreatedAt objectAtIndex:i]];
        int winCount = 0, lostCount = 0, tieCount = 0;
        for(int j = 0; j < [gameRecords count]; j++) {
            NSString *result =  [[gameRecords objectAtIndex:j] objectForKey:@"gameResult"];
            if ([result isEqualToString:@"Win"]) {
                winCount++;
            } else if ([result isEqualToString:@"Lost"]) {
                lostCount++;
            } else {
                tieCount++;
            }
        }
        
        NSString *p1Name = [[gameRecords objectAtIndex:0] objectForKey:@"player1Name"];
        NSString *p2Name = [[gameRecords objectAtIndex:0] objectForKey:@"player2Name"];
        
        CCLabelTTF *name1Label = [CCLabelTTF labelWithString:[Util formatName:p1Name withLimit:11]  fontName:localFontName fontSize:localFontSize];
        name1Label.color = ccc3(255, 255, 255);
        name1Label.position = ccp(20, yStart - row * localFontSize);
        name1Label.anchorPoint = ccp(0, 0);
        [self addChild:name1Label];
        [currentRow addObject:name1Label];
        
        CCLabelTTF *vsLabel = [CCLabelTTF labelWithString:@"vs" fontName:localFontName fontSize:localFontSize];
        vsLabel.color = ccc3(255, 255, 255);
        vsLabel.position = ccp(130, yStart - row * localFontSize);
        vsLabel.anchorPoint = ccp(0, 0);
        [self addChild:vsLabel];
        [currentRow addObject:vsLabel];
    
        CCLabelTTF *name2Label = [CCLabelTTF labelWithString:[Util formatName:p2Name withLimit:11] fontName:localFontName fontSize:localFontSize];
        name2Label.color = ccc3(255, 255, 255);
        name2Label.position = ccp(160, yStart - row * localFontSize);
        name2Label.anchorPoint = ccp(0, 0);
        [self addChild:name2Label];
        [currentRow addObject:name2Label];
        
        CCLabelTTF *winLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", winCount] fontName:localFontName fontSize:localFontSize];
        winLabel.color = ccc3(0, 255, 0);
        winLabel.position = ccp(290, yStart - row * localFontSize);
        winLabel.anchorPoint = ccp(0, 0);
        [self addChild:winLabel];
        [currentRow addObject:winLabel];
        
        CCLabelTTF *lostLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", lostCount] fontName:localFontName fontSize:localFontSize];
        lostLabel.color = ccc3(255, 0, 0);
        lostLabel.position = ccp(350, yStart - row * localFontSize);
        lostLabel.anchorPoint = ccp(0, 0);
        [self addChild:lostLabel];
        [currentRow addObject:lostLabel];
        
        CCLabelTTF *tieLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", tieCount] fontName:localFontName fontSize:localFontSize];
        tieLabel.color = ccc3(255, 255, 255);
        tieLabel.position = ccp(410, yStart - row * localFontSize);
        tieLabel.anchorPoint = ccp(0, 0);
        [self addChild:tieLabel];
        [currentRow addObject:tieLabel];
    }
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    return TRUE;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CCLOG(@"*******************ccTouchEnded*******************");
    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    if (nextHistoryActive && CGRectContainsPoint(nextHistory.boundingBox, touchLocation)) {
        CCLOG(@"Next History button pushed");
        [self clearCurrentPage];
        [self displayNextPage];
    } else if (previousHistoryActive && CGRectContainsPoint(previousHistory.boundingBox, touchLocation)) {
        CCLOG(@"Previous History button pushed");
        [self clearCurrentPage];
        [self displayPreviousPage];
    }
}

- (void) goBackToMainMenu {
    [[GameManager sharedGameManager] runSceneWithId:kMainMenuScene];
}

- (void) dealloc {
    [spinner stopAnimating];
    [paginationMatrix release];
    [keysOrderByCreatedAt release];
    [gameScoreSummary release];
    [spinner release];
    [super dealloc];
}


@end

