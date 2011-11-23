//
//  SinglePlayGameHistory.m
//  HundredSeconds
//
//  Created by Jae Kim on 11/2/11.
//  Copyright 2011 experiencesquad. All rights reserved.
//

#import "SinglePlayGameHistory.h"
#import "Parse/Parse.h"
#import "GameManager.h"

#define GAME_HISTORY_COUNT_TAG 1000
#define HISTORY_PER_PAGE 15
#define PAGE_INDEX_TAG 777
#define CURRENT_HISTORY_TAG 888
#define NUMBER_OF_COLUMNS 4

@implementation SinglePlayGameHistory

+(id) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SinglePlayGameHistory *layer = [SinglePlayGameHistory node];
	
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
        
        titleRow = [CCLabelTTF labelWithString:@"Name        Score        Result        When" fontName:@"Zapfino" fontSize:16.0];
        titleRow.color = ccc3(255, 255, 255);
        titleRow.position = ccp(10, 310);
        titleRow.anchorPoint = ccp(0, 1);
        [self addChild:titleRow];
        
        PFQuery *query = [PFQuery queryWithClassName:@"SinglePlayGameHistory"];
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        [query whereKey:@"gameUUID" equalTo:[[GameManager sharedGameManager] gameUUID]];
        [query countObjectsInBackgroundWithTarget:self
                                         selector:@selector(countCallback:error:)];
        
        query.limit = [NSNumber numberWithInt:HISTORY_PER_PAGE];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithTarget:self
                                        selector:@selector(findCallback:error:)];     
        
        paginationMatrix = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)findCallback:(NSArray *)results error:(NSError *)error {
    if (!error) {
        // The find succeeded.
        CCLOG(@"RESULT COUNT = %i", (int) results.count);
        for(int i = 0; i < (int) results.count; i++) {
            NSString *player1 = [[results objectAtIndex:i] objectForKey:@"player1Name"];
            NSString *player2 = [[results objectAtIndex:i] objectForKey:@"player2Name"];
            NSString *score1 = [[[results objectAtIndex:i] objectForKey:@"score1"] stringValue];
            NSString *score2 = [[[results objectAtIndex:i] objectForKey:@"score2"] stringValue];
            NSString *result = [[results objectAtIndex:i] objectForKey:@"gameResult"];
            NSString *when = [[[[results objectAtIndex:i] createdAt] description] substringToIndex:19];
            [self createRowLabelWithName:[NSString stringWithFormat:@"%@ vs %@", player1, player2] 
                               withScore: [NSString stringWithFormat:@"%@ : %@", score1, score2]  
                              withResult:result 
                                withWhen:when 
                                  forRow:i];
        }
    } else {
        // Log details of the failure
        CCLOG(@"Error: %@ %@", error, [error userInfo]);
    }
}

- (NSNumber *) getSkipCount {
    CCLabelTTF *pageIndex = (CCLabelTTF *) [self getChildByTag:PAGE_INDEX_TAG];
    int skipCount = 0;
    if (pageIndex) {
        skipCount = [[pageIndex string] intValue] * HISTORY_PER_PAGE;
    }
    
    return [NSNumber numberWithInt:skipCount];
}

- (NSNumber *) getLimitCount {
    CCLabelTTF *countIndex = (CCLabelTTF *) [self getChildByTag:GAME_HISTORY_COUNT_TAG];
    CCLabelTTF *pageIndex = (CCLabelTTF *) [self getChildByTag:PAGE_INDEX_TAG];
    int limitCount = 0;
    
    if (pageIndex) {
        int currentCount = [[pageIndex string] intValue] * HISTORY_PER_PAGE;
        int totalCount = [[countIndex string] intValue];
        int diffCount = totalCount - currentCount;
        
        if (diffCount > HISTORY_PER_PAGE) {
            limitCount = HISTORY_PER_PAGE;
        } else if (diffCount > 0) {
            limitCount = diffCount;
        }
    }
    
    return [NSNumber numberWithInt:limitCount];
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
        PFQuery *query = [PFQuery queryWithClassName:@"SinglePlayGameHistory"];
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        [query whereKey:@"gameUUID" equalTo:[[GameManager sharedGameManager] gameUUID]];
        [query countObjectsInBackgroundWithTarget:self
                                         selector:@selector(countCallback:error:)];
        query.limit = [self getLimitCount];
        query.skip = [self getSkipCount];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithTarget:self
                                        selector:@selector(findCallback:error:)];
    }
}

- (void)countCallback:(NSNumber *)count error:(NSError *)error {
    if (!error) {
        int numPage = [count intValue] / HISTORY_PER_PAGE;
        if ([count intValue] % HISTORY_PER_PAGE > 0) {
            numPage++;
        }
        CCLOG(@"NUM PAGE = %i", numPage);
        for(int i = 0; i < numPage; i++) {
            NSMutableArray *row = [NSMutableArray arrayWithCapacity:NUMBER_OF_COLUMNS];
            [paginationMatrix addObject:row];
        }
        // The count request succeeded. Log the count
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *gameHistoryCount = [CCLabelTTF labelWithString:[count stringValue] fontName:@"Marker Felt" fontSize:15];
        gameHistoryCount.color = ccc3(255, 255, 255);
        gameHistoryCount.position = ccp(windowSize.width/2, 20);
        gameHistoryCount.visible = NO;
        [self addChild:gameHistoryCount z:10 tag:GAME_HISTORY_COUNT_TAG];
        [self updatePagination];
    } else {
        // The request failed
        CCLOG(@"*******************PARSE COUNT CALLBACK FAILED*******************");
    }
}

- (void) updatePagination {
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    CCLabelTTF *pageIndex = (CCLabelTTF *) [self getChildByTag:PAGE_INDEX_TAG];
    CCLabelTTF *historyCount = (CCLabelTTF *) [self getChildByTag:GAME_HISTORY_COUNT_TAG];
        
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
    
    if ([[pageIndex string] intValue] * HISTORY_PER_PAGE < [[historyCount string] intValue]) {
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
    int totalCount = [[(CCLabelTTF *) [self getChildByTag:GAME_HISTORY_COUNT_TAG] string] intValue];
    startIndex = (page - 1) * HISTORY_PER_PAGE + 1;
    endIndex = startIndex + HISTORY_PER_PAGE - 1;
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

- (void) createRowLabelWithName:(NSString *) name withScore:(NSString *) score withResult:(NSString *) result withWhen:(NSString *) when forRow:(int) row {
    NSString *localFontName = @"Marker Felt";
    int localFontSize = 12;
    
    NSMutableArray *currentRow = [paginationMatrix objectAtIndex:[self getCurrentPageIndex]];
    
    CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:name fontName:localFontName fontSize:localFontSize];
    nameLabel.color = ccc3(255, 255, 255);
    nameLabel.position = ccp(20, 250 - row * 15);
    nameLabel.anchorPoint = ccp(0, 0);
    [self addChild:nameLabel];
    [currentRow insertObject:nameLabel atIndex:0];
    
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:score fontName:localFontName fontSize:localFontSize];
    scoreLabel.color = ccc3(255, 255, 255);
    scoreLabel.position = ccp(140, 250 - row * 15);
    scoreLabel.anchorPoint = ccp(0, 0);
    [self addChild:scoreLabel];
    [currentRow insertObject:scoreLabel atIndex:1];
    
    CCLabelTTF *resultLabel = [CCLabelTTF labelWithString:result fontName:localFontName fontSize:localFontSize];
    resultLabel.color = ccc3(255, 255, 255);
    resultLabel.position = ccp(260, 250 - row * 15);
    resultLabel.anchorPoint = ccp(0, 0);
    [self addChild:resultLabel];
    [currentRow insertObject:resultLabel atIndex:2];
    
    CCLabelTTF *whenLabel = [CCLabelTTF labelWithString:when fontName:localFontName fontSize:localFontSize];
    whenLabel.color = ccc3(255, 255, 255);
    whenLabel.position = ccp(350, 250 - row * 15);
    whenLabel.anchorPoint = ccp(0, 0);
    [self addChild:whenLabel];
    [currentRow insertObject:whenLabel atIndex:3];
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    //CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    
    return TRUE;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CCLOG(@"*******************ccTouchEnded*******************");
    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    if (nextHistoryActive && CGRectContainsPoint(nextHistory.boundingBox, touchLocation)) {
        CCLOG(@"Next History button pushed");
        [self clearCurrentPage];
        [self displayNextPage];
        [self incrementPage];
        [self updatePagination];
    } else if (previousHistoryActive && CGRectContainsPoint(previousHistory.boundingBox, touchLocation)) {
        CCLOG(@"Previous History button pushed");
        [self clearCurrentPage];
        [self displayPreviousPage];
        [self decrementPage];
        [self updatePagination];
    }
}

- (void) dealloc {
    [paginationMatrix release];
}


@end

