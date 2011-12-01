//
//  HelloWorldLayer.h
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
@interface HelloWorld : CCLayer <ADBannerViewDelegate, UITextFieldDelegate>
{
	ADBannerView *adView;
    SimpleAudioEngine *soundEngine;    
    
    int cols;
    int rows;
    int width;
    int height;
    int y_offset;
    
    CCLabelTTF *player1Name;
    CCLabelTTF *player2Name;
    CCLabelTTF *player1Timer;
    CCLabelTTF *player2Timer;
    CCLabelTTF *wordDefinition;
    CCLabelTTF *player1Answer;
    CCLabelTTF *player2Answer;
    CCLabelTTF *gameTimer;
    CCLabelTTF *midDisplay;
    CCLabelTTF *currentAnswer;
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
    CCSprite *greySolveButton1;
    CCSprite *greySolveButton2;
    CCSprite *transparentBoundingBox1;
    CCSprite *transparentBoundingBox2;
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
    CCSprite *_playButton;
    BOOL playButtonReady;
    CCSprite *tapToChangeLeft;
    CCSprite *tapToChangeRight;
    UITextField *enterPlayer1Name;
    UITextField *enterPlayer2Name;
    NSString *player1LongName;
    NSString *player2LongName;
    BOOL tapToNameRightActive;
    BOOL tapToNameLeftActive;
    
    PauseMenu *pauseMenuPlayAndPass;
    BOOL      pauseState;
    BOOL      pauseActive;
}

@property int cols;
@property int rows;
@property (nonatomic, retain) CCSprite *playButton;
@property (nonatomic, retain) CCSprite *tapToChangeLeft;
@property (nonatomic, retain) CCSprite *tapToChangeRight;
@property (nonatomic, retain) NSString *player1LongName;
@property (nonatomic, retain) NSString *player2LongName;
@property (nonatomic, retain) PauseMenu *pauseMenuPlayAndPass;
@property BOOL pauseState;
@property BOOL pauseActive;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
- (void) createLetterSlots:(int) nRows columns:(int) nCols firstGame:(BOOL) firstGameFlag;
- (void) createDictionary;
- (void) updateAnswer;
- (void) checkAnswer;
- (void) switchTo:(int) player countFlip:(BOOL) flag notification:(BOOL) notify;
- (void) clearAllSelectedLetters;
- (void) clearLetters;
- (void) updateCellOwnerTo:(int) playerId;
- (void) addScore:(int) point toPlayer:(int) playerId anchorCell:(Cell *) cell;
- (void) openRandomLetters:(int) n;
- (BOOL) isThisStarPoint:(Cell *) cell;
- (void) setStarPoints;
- (int) countStarPointandRemoveStars;
- (Cell*) cellWithCharacter:(char) ch atRow:(int) r atCol:(int) c;
- (void) fadeInLetters;
- (void) fadeOutLetters;
- (void) displayLetters;
- (void) showPlayButton;
- (BOOL) stopTimer;
- (BOOL) startTimer;

@end
