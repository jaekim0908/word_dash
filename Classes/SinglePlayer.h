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
    PauseMenu *pauseMenuPlayAndPass;
    BOOL      pauseState;
    BOOL      awardsState;
    BOOL    thisGameBeatAIAward;
    BOOL    thisGameTotalPointsAward;
    BOOL    thisGameLongWordAward;
    
    CCSprite *awardPopupFrame;
    CCSprite *awardPopupTintedBackground;
    CCSprite *nextLevelBtn;
    CCSprite *getResultsBtn;
    CCSprite *rematchBtn;
    CCSprite *mainMenuBtn;
    
    CCSprite *thisGameBeatAIAwardSprite;
    CCSprite *thisGameTotalPointsAwardSprite;
    CCSprite *thisGameLongWordAwardSprite;
    
    CCLabelTTF *singlePlayerScore;
    CCLabelTTF *levelStatus;
    
    int         aiMaxWaitTime;
    
    UIActivityIndicatorView *activityIndicator;

}

@property BOOL thisGameBeatAIAward;
@property BOOL thisGameTotalPointsAward;
@property BOOL thisGameLongWordAward;
@property (nonatomic,retain) CCSprite *awardPopupFrame;
@property (nonatomic,retain) CCSprite *awardPopupTintedBackground;
@property (nonatomic,retain) CCSprite *nextLevelBtn;
@property (nonatomic,retain) CCSprite *getResultsBtn;
@property (nonatomic,retain) CCSprite *rematchBtn;
@property (nonatomic,retain) CCSprite *mainMenuBtn;
@property (nonatomic,retain) CCSprite *thisGameBeatAIAwardSprite;
@property (nonatomic,retain) CCSprite *thisGameTotalPointsAwardSprite;
@property (nonatomic,retain) CCSprite *thisGameLongWordAwardSprite;
@property (nonatomic,retain) CCLabelTTF *singlePlayerScore;
@property (nonatomic,retain) CCLabelTTF *levelStatus;
@property int aiMaxWaitTime;


-(BOOL) allLettersOpened;
-(BOOL) stopTimer;
-(BOOL) startTimer;
-(void) displayAwardsPopup;
-(void) determineAwardsForSinglePlayer:(int)p1Score AIScore:(int)aiScore Player1Words:(NSMutableArray *)player1WordsArray;
-(void) showAIActivity;
-(void) hideAIActivity;
-(void) clearCurrentAnswer;

@end
