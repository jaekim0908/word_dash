//
//  Multiplayer.h
//  WordMatrix
//
//  Created by Jae Kim on 1/25/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import <iAd/iAd.h>
#import "OpenFeint.h"
#import "OFMultiplayerGame.h"
#import "OFMultiplayer.h"

@class Cell;

// HelloWorld Layer
@interface Multiplayer : CCLayer <ADBannerViewDelegate>
{
	ADBannerView *adView;	
	int cols;
	int rows;
	int width;
	int height;
	int y_offset;
    int numPauseRequests;//MCH
	
	CCLabelTTF *player1Timer;
	CCLabelTTF *player2Timer;
	CCLabelTTF *wordDefinition;
	CCLabelTTF *player1Answer;
	CCLabelTTF *player2Answer;
	CCLabelTTF *gameTimer;
	CCLabelTTF *midDisplay;
    CCLabelTTF *midDisplaySmall;//MCH
	CCLabelTTF *currentAnswer;
	int playerTurn;
	BOOL gameOver;
	NSMutableArray* allWords;
	NSMutableDictionary *dictionary;
	NSMutableArray* wordMatrix;
	CCSpriteBatchNode *batchNode;
	CCSprite *solveButton1;
	CCSprite *solveButton2;
	CCSprite *greySolveButton1;
	CCSprite *greySolveButton2;
	CCSprite *goButton1;
	CCSprite *goButton2;
	CCSprite *stopButton1;
	CCSprite *stopButton2;
	NSMutableArray *userSelection;
	BOOL player1TileFipped;
	BOOL player2TileFipped;
	NSMutableDictionary *foundWords;
	NSMutableArray *player1Words;
	NSMutableArray *player2Words;
	CCLabelTTF *player1Score;
	CCLabelTTF *player2Score;
	BOOL enableTouch;
	int countNoTileFlips;
	NSMutableArray *specialEffects;
	int currentStarPoints;
	NSMutableArray *starPoints;
	BOOL gameCountdown;
	CCLabelTTF *gameCountDownLabel;
	CCSprite *gameSummary;
	OFMultiplayerGame *thisGame;
	BOOL isThisPlayerChallenger;
    CCSprite *pauseButton;//MCH
}

@property int cols;
@property int rows;
@property (nonatomic, assign) int numPauseRequests;
@property (nonatomic, retain) OFMultiplayerGame *thisGame;
@property BOOL isThisPlayerChallenger;

// returns a Scene that contains the HelloWorld as the only child
+ (id) scene;
- (void) createLetterSlots:(int) rows columns:(int) cols firstGame:(BOOL) firstGameFlag;
- (void) createDictionary;
- (void) updateAnswer;
- (void) checkAnswer;
- (void) switchTo:(int) player countFlip:(BOOL) flag;
- (void) clearAllSelectedLetters;
- (void) clearLetters;
- (void) updateCellOwnerTo:(int) playerId;
- (void) addScore:(int) point toPlayer:(int) playerId anchorCell:(Cell *) cell;
- (void) openRandomLetters:(int) n;
- (BOOL) isThisStarPoint:(Cell *) cell;
- (void) setStarPoints;
- (int) countStarPointandRemoveStars;
- (void) sendInitMoveRow:(int) r Col:(int) c value:(NSString *) val visible:(BOOL) isVisible starPoint:(BOOL) isThisStar endTurn:(BOOL) turn;
- (void) sendMove:(NSString *) moveType rowNum:(int) r colNum:(int) c value:(NSString *) val endTurn:(BOOL) turn;
- (void) setCellRow:(int) r Col:(int) c withValue:(NSString *) val;
- (void) tileFlipRow:(int) r Col:(int) c;
- (void) selectCellRow:(int)r Col:(int)c;
- (void) deselectCellRow:(int)r Col:(int)c;
- (void) scheduleUpdateTimer;
- (void) clearStarPoints;
- (void) setSPRow:(int) r Col:(int) c;
- (void) setTimer:(NSString *) t;
- (void) addMoreTime:(int) timeInSeconds toPlayer:(int) playerId;
- (void) pauseGame;//MCH
- (void) sendPauseRequest;

@end
