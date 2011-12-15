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
#import "SimpleAudioEngine.h"

@class Cell;
@class PauseMenu;


// HelloWorld Layer
@interface SinglePlayer : CCLayer <ADBannerViewDelegate, UITextFieldDelegate>
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
    CCLabelTTF *statusMessage;//MCH
	int playerTurn;
	BOOL gameOver;
    BOOL initOpponentOutOfTime;
	NSMutableArray* allWords;
	NSMutableDictionary *dictionary;
	NSMutableArray* wordMatrix;
	CCSpriteBatchNode *batchNode;
    CCSpriteBatchNode *batchNode2;
	CCSprite *solveButton1;
	CCSprite *solveButton2;
    CCSprite *transparentBoundingBox1;
    CCSprite *transparentBoundingBox2;
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
	int currentStarPoints;
	NSMutableArray *starPoints;
	BOOL gameCountdown;
	CCLabelTTF *gameCountDownLabel;
	BOOL isThisPlayerChallenger;
    CCSprite *pauseButton;//MCH
    SimpleAudioEngine *soundEngine;
    NSMutableArray* aiAllWords;
    NSMutableDictionary *visibleLetters;
    NSString *aiLevel;
    NSString *progressiveScore;
    NSString *numOfWinsAI;
    NSString *numOfLossesAI;
    NSString *numOfTiesAI;
    NSString *longestAnswer;
    NSString *player1Name;
    UITextField *enterYourName;
    
    PauseMenu *pauseMenuPlayAndPass;
    BOOL      pauseState;
    
    BOOL thisGameBeatAIAward;
    BOOL thisGameTotalPointsAward;
    BOOL thisGameLongWordAward;

}

@property int cols;
@property int rows;
@property (nonatomic, assign) int numPauseRequests;
@property (nonatomic, retain) SimpleAudioEngine *soundEngine;
@property BOOL isThisPlayerChallenger;
@property BOOL initOpponentOutOfTime;
@property (nonatomic, retain) NSString *player1Name;
@property BOOL pauseState;
@property (nonatomic, retain) PauseMenu *pauseMenuPlayAndPass;
@property BOOL thisGameBeatAIAward;
@property BOOL thisGameTotalPointsAward;
@property BOOL thisGameLongWordAward;



// returns a Scene that contains the HelloWorld as the only child
+ (id) scene;
- (void) createLetterSlots:(int) nRows columns:(int) nCols firstGame:(BOOL) firstGameFlag;
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
- (void) tileFlipRow:(int) r Col:(int) c checkScore:(BOOL) check;
- (void) selectCellRow:(int)r Col:(int)c;
- (void) deselectCellRow:(int)r Col:(int)c;
- (void) scheduleUpdateTimer;
- (void) clearStarPoints;
- (void) setSPRow:(int) r Col:(int) c;
- (void) setTimer:(NSString *) t;
- (void) addMoreTime:(int) timeInSeconds toPlayer:(int) playerId;
- (void) pauseGame;//MCH
- (void) sendPauseRequest;
- (void) setGameStartCountdownTimer:(NSString *) t;
- (Cell*) cellWithCharacter:(char) ch atRow:(int) r atCol:(int) c;
- (void) getPlayerName;
- (BOOL) allLettersOpened;
- (BOOL) stopTimer;
- (BOOL) startTimer;
- (void) determineAwardsForSinglePlayer:(int)p1Score AIScore:(int)aiScore LongestWordLength:(int)longestWordLength;
- (int) getLongestWordLengthInArray:(NSMutableArray *) playerWordsArray;



@end
