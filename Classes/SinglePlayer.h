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
#import "WordGame.h"

@class Cell;
@class PauseMenu;


// HelloWorld Layer
@interface SinglePlayer : WordGame
{
       
    NSMutableArray* aiAllWords;
    NSMutableDictionary *visibleLetters;
    NSString *aiLevel;
    NSString *progressiveScore;
    NSString *numOfWinsAI;
    NSString *numOfLossesAI;
    NSString *numOfTiesAI;
    NSString *longestAnswer;
    UITextField *enterYourName;
    PauseMenu *pauseMenu;
    BOOL      pauseState;
    //BOOL      awardsState;
    BOOL    thisGameBeatAIAward;
    BOOL    thisGameTotalPointsAward;
    BOOL    thisGameLongWordAward;
    
    BOOL    finalCountDownAlreadyPlaying;
    ALuint  soundId;
    
    //CCSprite *awardPopupFrame;
    //CCSprite *awardPopupTintedBackground;
    //CCMenuItem *nextLevelBtn;
    //CCMenuItem *getResultsBtn;
    //CCMenuItem *rematchBtn;
    //CCMenuItem *mainMenuBtn;
    
    //CCMenu *awardsMenu;
    
    //CCSprite *thisGameBeatAIAwardSprite;
    //CCSprite *thisGameTotalPointsAwardSprite;
    //CCSprite *thisGameLongWordAwardSprite;
    
    CCLabelTTF *singlePlayerScore;
    CCLabelTTF *levelDisplay;
    //CCLabelTTF *lowerDisplay;
    
    int         aiMaxWaitTime;
    
    UIActivityIndicatorView *activityIndicator;
    
    //CCSpriteBatchNode *awardsScreenBatchNode;

}

@property BOOL thisGameBeatAIAward;
@property BOOL thisGameTotalPointsAward;
@property BOOL thisGameLongWordAward;
//@property (nonatomic,retain) CCSprite *awardPopupFrame;
//@property (nonatomic,retain) CCSprite *awardPopupTintedBackground;
//@property (nonatomic,retain) CCMenuItem *nextLevelBtn;
//@property (nonatomic,retain) CCMenuItem *getResultsBtn;
//@property (nonatomic,retain) CCMenuItem *rematchBtn;
//@property (nonatomic,retain) CCMenuItem *mainMenuBtn;
//@property (nonatomic,retain) CCMenu *awardsMenu;
//@property (nonatomic,retain) CCSprite *thisGameBeatAIAwardSprite;
//@property (nonatomic,retain) CCSprite *thisGameTotalPointsAwardSprite;
//@property (nonatomic,retain) CCSprite *thisGameLongWordAwardSprite;
@property (nonatomic,retain) CCLabelTTF *singlePlayerScore;
@property (nonatomic,retain) CCLabelTTF *levelDisplay;
//@property (nonatomic,retain) CCLabelTTF *lowerDisplay;
@property int aiMaxWaitTime;


-(BOOL) allLettersOpened;
-(BOOL) stopTimer;
-(BOOL) startTimer;
-(void) displayAwardsPopup;
-(void) determineAwardsForSinglePlayer:(int)p1Score AIScore:(int)aiScore Player1Words:(NSMutableArray *)player1WordsArray;
-(void) showAIActivity;
-(void) hideAIActivity;
-(void) clearCurrentAnswer;
- (BOOL) determineNextLevelLock:(int)currentLevel beatAIFlag:(BOOL)beatAIFlag AllGameLevelDict:(NSMutableDictionary *)allGameLevels;
-(void) aiFindWords;
-(void) aiMoveComplete;
-(void) aiFlip;
-(void) aiTripleTab;
-(BOOL) aiCheckAnswer:(NSString *) answer;
- (BOOL) nextLevelPressed;
- (BOOL) getResultsPressed;
- (BOOL) rematchBtnPressed;
- (BOOL) mainMenuBtnPressed;
-(NSString *) getAllVisibleLetters;

@end
