//
//  PlayAndPass.h
//  HundredSeconds
//
//  Created by Jae Kim on 12/7/11.
//  Copyright (c) 2011 experiencesquad. All rights reserved.
//

#import "cocos2d.h"
#import <iAd/iAd.h>
#import "SimpleAudioEngine.h"
#import "WordGame.h"

@class Cell;
@class PauseMenu;

@interface PlayAndPass : WordGame
{
    PauseMenu *pauseMenuPlayAndPass;
    BOOL      pauseState;
}

-(BOOL) stopTimer;
-(BOOL) startTimer;

@end

