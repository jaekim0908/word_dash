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
}

-(BOOL) allLettersOpened;
-(BOOL) stopTimer;
-(BOOL) startTimer;
@end
