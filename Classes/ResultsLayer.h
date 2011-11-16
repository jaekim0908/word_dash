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
    NSMutableDictionary *definition;
    NSMutableArray *copyPlayer1Words;
    NSMutableArray *copyPlayer2Words;
    NSMutableArray *p1WordLabels;
    NSMutableArray *arrayPagesPlayer1;
    NSMutableArray *arrayPagesPlayer2;
    CGSize      winSize;
    int         currentPage;
    int         player1TotalPages;
    int         player2TotalPages;
    GameMode    mbrGameMode;
    CCLabelTTF *pageNumDisplay;
    CCSprite   *surfBackground;
    CCSprite   *surfBackground2;
    CCSprite   *whiteBackground;
    CCSprite   *nextPageButton;
    CCSprite   *prevPageButton;
    CCSprite   *nextPageButtonDisabled;
    CCSprite   *prevPageButtonDisabled;
    CCSprite   *woodenSign;
    
}

@property (nonatomic, retain) CCSpriteBatchNode *batchNode;
@property (nonatomic, retain) CCLabelTTF *player1Score;
@property (nonatomic, retain) CCLabelTTF *player2Score;
@property (nonatomic, retain) CCLabelTTF *pageNumDisplay;
@property (nonatomic, retain) CCSprite *rematchButton;
@property (nonatomic, retain) CCSprite *mainMenuButton;
@property (nonatomic, retain) NSMutableDictionary *definition;
@property (nonatomic, retain) NSMutableArray *copyPlayer1Words;
@property (nonatomic, retain) NSMutableArray *copyPlayer2Words;
@property (nonatomic, retain) NSMutableArray *p1WordLabels;
@property (nonatomic, retain) NSMutableArray *arrayPagesPlayer1;
@property (nonatomic, retain) NSMutableArray *arrayPagesPlayer2;
@property (nonatomic, retain) CCSprite *surfBackground;
@property (nonatomic, retain) CCSprite *surfBackground2;
@property (nonatomic, retain) CCSprite *whiteBackground;
@property (nonatomic, retain) CCSprite *nextPageButton;
@property (nonatomic, retain) CCSprite *prevPageButton;
@property (nonatomic, retain) CCSprite *nextPageButtonDisabled;
@property (nonatomic, retain) CCSprite *prevPageButtonDisabled;
@property (nonatomic, retain) CCSprite *woodenSign;
@property (nonatomic, assign) CGSize winSize;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int player1TotalPages;
@property (nonatomic, assign) int player2TotalPages;
@property (nonatomic, assign) GameMode mbrGameMode;


-(BOOL) initWithPlayerOneScore:(NSString *) p1Score WithPlayerTwoScore:(NSString *) p2Score WithPlayerOneWords:(NSMutableArray *) p1Words WithPlayerTwoWords:(NSMutableArray *) p2Words ForMultiPlayer:(GameMode)gameMode;
+(id) scene:(NSString *) p1Score WithPlayerTwoScore:(NSString *) p2Score WithPlayerOneWords:(NSMutableArray *) p1Words WithPlayerTwoWords:(NSMutableArray *) p2Words ForMultiPlayer:(GameMode)gameMode;
- (void) displayPlayerWords:(int) playerNumber
                  withWords:(NSMutableArray *)pWords 
                     startAt:(int)startIndex 
            xPosColumn1of1At:(float) xPos1of1 
            xPosColumn1of2At:(float) xPos1of2 
           xPosColumn2of2At:(float) xPos2of2;
- (BOOL) clearCurrentPage:(int) playerNum;


@end
