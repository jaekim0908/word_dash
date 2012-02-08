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

@interface MainMenuLayer : CCLayer <UIActionSheetDelegate> {
	CCMenu *mainMenu;
	CCLabelTTF *challengeCancelledLabel;
	CCLabelTTF *challengeRejectedLabel;
    //CCSprite *playWithFriendsImg;
    //CCSprite *playAndPassImg;
    CCSprite *howToPlayImg;
    CCSprite *rankingsImg;
    CCSprite *playWithFriendsLabel;
    CCSprite *playAndPassLabel;
    CCSprite *singlePlayerLabel;
    CCSprite *rankingsSelected;
    CCSprite *playAndPassSelected;
    CCSprite *playWithFriendsSelected;
    CCSprite *howToPlaySelected;
    CCSpriteBatchNode *batchNode;
    
    CCSprite *soundOnButton;
    CCSprite *soundOffButton;
}

@property (nonatomic, retain) CCSprite *soundOnButton;
@property (nonatomic, retain) CCSprite *soundOffButton;

-(void) showCancelChallengeMsg;
-(void) enableMainMenu;
-(void) disableMainMenu;
-(void) displayHowToPlay;
-(void) displaySinglePlayer;
@end
