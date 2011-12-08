//
//  PauseMenu.h
//  HundredSeconds
//
//  Created by Michael Ho on 11/14/11.
//  Copyright 2011 experiencesquad. All rights reserved.
//

#import "cocos2d.h"
#import "Constants.h"


@interface PauseMenu : NSObject {
    CCSprite *pauseButton;
    CCSprite *pauseBackground;
    CCSprite *wavesAndBeach;
    CCSprite *rematchButton;
    CCSprite *mainMenuButton;
    CCSprite *resumeButton;
    CCSprite *howToPlayButton; 
    CCSpriteBatchNode *batchNode;
    
}

@property (nonatomic, retain) CCSprite *pauseButton;
@property (nonatomic, retain) CCSprite *pauseBackground;
@property (nonatomic, retain) CCSprite *wavesAndBeach;
@property (nonatomic, retain) CCSprite *rematchButton;
@property (nonatomic, retain) CCSprite *mainMenuButton;
@property (nonatomic, retain) CCSprite *resumeButton;
@property (nonatomic, retain) CCSprite *howToPlayButton;

-(BOOL) addToMyScene:(CCLayer *) myScene;
-(BOOL) showPauseMenu:(CCLayer *) myScene;
-(BOOL) execPauseMenuActions:(CGPoint) touchLocation forScene:(CCLayer *) myScene withId:(SceneTypes)sceneId;

@end
