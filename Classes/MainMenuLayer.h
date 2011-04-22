//
//  MainMenuLayer.h
//  HundredSeconds
//
//  Created by Jae Kim on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "GameManager.h"
#import "MyOFDelegate.h"

@interface MainMenuLayer : CCLayer {
	CCMenu *mainMenu;
	CCLabelTTF *challengeCancelledLabel;
	CCLabelTTF *challengeRejectedLabel;
}

-(void) showCancelChallengeMsg;
-(void) enableMainMenu;
-(void) disableMainMenu;
-(void) showCancelChallengeMsgWithChallengerName:(NSString *) chlName;
@end
