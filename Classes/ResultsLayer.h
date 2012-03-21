//
//  ResultsLayer.h
//  HundredSeconds
//
//  Created by Michael Ho on 3/23/11.
//  Copyright 2011 self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ResultPages.h"
#import "Constants.h"

@interface ResultsLayer : CCLayerColor {
	CCSpriteBatchNode *batchNode;
    CCLabelTTF *player1Score;
	CCLabelTTF *player2Score;
	CCSprite *rematchButton;
    CCSprite *mainMenuButton;
    // del NSMutableDictionary *definition;
    NSMutableArray *dupPlayer1Words;
    NSMutableArray *dupPlayer2Words;
    NSMutableArray *p1WordLabels;
    NSMutableArray *arrayPagesPlayer1;
    NSMutableArray *arrayPagesPlayer2;
    CGSize      winSize;
    int         currentPage;
    int         player1TotalPages;
    int         player2TotalPages;
    GameMode    theGameMode;
    CCLabelTTF *pageNumDisplay;
    //delete CCSprite   *surfBackground;
    //delete CCSprite   *surfBackground2;
    CCSprite   *whiteBackground;
    CCSprite   *nextPageButton;
    CCSprite   *prevPageButton;
    CCSprite   *nextPageButtonDisabled;
    CCSprite   *prevPageButtonDisabled;
    CCSprite   *woodenSign;
}

//@property (nonatomic, retain) CCSpriteBatchNode *batchNode;
//@property (nonatomic, retain) CCLabelTTF *player1Score;
//@property (nonatomic, retain) CCLabelTTF *player2Score;
//@property (nonatomic, retain) CCLabelTTF *pageNumDisplay;
//@property (nonatomic, retain) CCSprite *rematchButton;
//@property (nonatomic, retain) CCSprite *mainMenuButton;
//@property (nonatomic, retain) NSMutableArray *dupPlayer1Words;
//@property (nonatomic, retain) NSMutableArray *dupPlayer2Words;
//@property (nonatomic, retain) NSMutableArray *p1WordLabels;
//@property (nonatomic, retain) NSMutableArray *arrayPagesPlayer1;
//@property (nonatomic, retain) NSMutableArray *arrayPagesPlayer2;
//@property (nonatomic, retain) CCSprite *surfBackground;
//@property (nonatomic, retain) CCSprite *surfBackground2;
//@property (nonatomic, retain) CCSprite *whiteBackground;
//@property (nonatomic, retain) CCSprite *nextPageButton;
//@property (nonatomic, retain) CCSprite *prevPageButton;
//@property (nonatomic, retain) CCSprite *nextPageButtonDisabled;
//@property (nonatomic, retain) CCSprite *prevPageButtonDisabled;
//@property (nonatomic, retain) CCSprite *woodenSign;
@property (nonatomic, assign) CGSize winSize;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int player1TotalPages;
@property (nonatomic, assign) int player2TotalPages;
// delete @property (nonatomic, assign) BOOL flagMultiPlayer;


-(id) init;
+(id) scene;
- (void) displayPlayerWords2:(int) playerNumber
                   withWords:(NSMutableArray *)pWords
              withResultPage:(ResultPages *)pResultPage;
- (BOOL) clearCurrentPage:(int) playerNum;
-(int) getLongestWordIndexInArray:(NSArray *) playerWordsArray;


@end
