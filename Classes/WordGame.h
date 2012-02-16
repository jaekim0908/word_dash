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
//#import "SimpleAudioEngine.h"

@class Cell;
@class PauseMenu;

// HelloWorld Layer
@interface WordGame : CCLayer <ADBannerViewDelegate, UITextFieldDelegate>
{
	ADBannerView *adView;
    //SimpleAudioEngine *soundEngine;    
    
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
    CCSprite *passButton1;
    CCSprite *passButton2;
    CCSprite *solveButton1;
    CCSprite *solveButton2;
    CCSprite *greySolveButton1;
    CCSprite *greySolveButton2;
    CCSprite *transparentBoundingBox1;
    CCSprite *transparentBoundingBox2;
    NSMutableArray *userSelection;
    BOOL player1TileFlipped;
    BOOL player2TileFlipped;
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
    CCSprite *_tapToChangeLeft;
    CCSprite *_tapToChangeRight;
    UITextField *enterPlayer1Name;
    UITextField *enterPlayer2Name;
    NSString *player1LongName;
    NSString *player2LongName;
    BOOL tapToNameRightActive;
    BOOL tapToNameLeftActive;
    CCSprite *_leftSideBackground;
    CCSprite *_rightSideBackground;
    BOOL tripleTabUsed;
    CCSprite *waitForYourTurn;
}

@property int cols;
@property int rows;
@property (nonatomic, retain) CCSprite *playButton;
@property (nonatomic, retain) CCSprite *tapToChangeLeft;
@property (nonatomic, retain) CCSprite *tapToChangeRight;
@property (nonatomic, retain) NSString *player1LongName;
@property (nonatomic, retain) NSString *player2LongName;
@property (nonatomic, retain) CCSprite *leftSideBackground;
@property (nonatomic, retain) CCSprite *rightSideBackground;


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
- (void) removeCellAtRow:(int) r Col:(int) c;
- (void) fadeInLetters;
- (void) fadeOutLetters;
- (void) displayLetters;
- (void) showPlayButton;
- (void) getPlayer1Name;
- (void) getPlayer2Name;
- (void) removeCellAtRow:(int) r Col:(int) c;
- (BOOL) isVowel:(NSString *) str;
- (BOOL) isGameOver;
- (void) showLeftChecker;
- (void) showRightChecker;
- (void) hideLeftChecker;
- (void) hideRightChecker;
- (void) handleTripleTapWithCell:(Cell *) cell AtRow:(int) r Col:(int) c;
- (BOOL) allLettersOpened;
- (void) addMoreTime:(int) timeInSeconds toPlayer:(int) playerId;
- (void) turnOnPassButtonForPlayer1;
- (void) turnOnPassButtonForPlayer2;
- (void) turnOnSubmitButtonForPlayer1;
- (void) turnOnSubmitButtonForPlayer2;
- (void) cleanUpSprite:(CCSprite *) sprite;
- (void) showRedSquareAtCell:(Cell *) cell;
- (void) deselectCellsAt:(Cell *) cell;
@end
