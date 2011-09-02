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
#import "OFSocialNotification.h"
#import "OFSocialNotificationApi.h"

@interface MainMenuLayer : CCLayer <OFSocialNotificationApiDelegate, UIActionSheetDelegate> {
	CCMenu *mainMenu;
	CCLabelTTF *challengeCancelledLabel;
	CCLabelTTF *challengeRejectedLabel;
    CCSprite *playWithFriendsImg;
    CCSprite *playAndPassImg;
    CCSprite *howToPlayImg;
    CCSprite *rankingsImg;
}

-(void) showCancelChallengeMsg;
-(void) enableMainMenu;
-(void) disableMainMenu;
@end
