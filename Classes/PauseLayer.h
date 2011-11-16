//
//  PauseLayer.h
//  HundredSeconds
//
//  Created by Michael Ho on 3/21/11.
//  Copyright 2011 self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PauseLayer : CCLayerColor {
	CCSprite *resumeButton;
    CCSprite *restartButton;
    CCLabelTTF *midDisplay;
    CCLabelTTF *midDisplayNote;
    CCLabelTTF *midDisplayNote0;
}

@property (nonatomic, retain) CCSprite *resumeButton;
@property (nonatomic, retain) CCSprite *restartButton;
@property (nonatomic, retain) CCLabelTTF *midDisplay;

+(id) scene;
-(void) checkMyTurnThenResume:(ccTime) dt;
-(void) processTimeoutCountdownRequest:(NSString *)timeRemaining;
-(void) timeoutCountdown:(ccTime) dt;
- (void) sendTimeoutCountdownValue;
- (void) remoteResumeRequest;
-(void) sendResumeRequestAndResume;
-(void) restartGame;

@end
