//
//  PauseMenu.mm
//  HundredSeconds
//
//  Created by Michael Ho on 11/14/11.
//  Copyright 2011 experiencesquad. All rights reserved.
//

#import "PauseMenu.h"
#import "GameManager.h"
#import "HowToPlay.h"


@implementation PauseMenu

@synthesize pauseButton;
@synthesize pauseBackground;
@synthesize wavesAndBeach;
@synthesize rematchButton;
@synthesize mainMenuButton;
@synthesize resumeButton;
@synthesize howToPlayButton;
@synthesize batchNode;





-(id) init
{
    // Retina Display Support
    if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"PauseMenuAssets-hd.plist"];
        batchNode = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"PauseMenuAssets-hd.png"]];
    } else {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"PauseMenuAssets.plist"];
        batchNode = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"PauseMenuAssets.png"]];
    }

     

    
    
    return self;
}

-(BOOL) addToMyScene:(CCLayer *) myScene
{
    
 
    [myScene addChild:batchNode z:100];

    self.pauseButton = [CCSprite spriteWithFile:@"pause_btn.png"];
    self.pauseButton.position = ccp(438, 300);
    [myScene addChild:self.pauseButton z:10];
    
    //MCH
    self.pauseBackground = [CCSprite spriteWithFile:@"pause_background.png"];
    self.pauseBackground.position = ccp(240,160);
    self.pauseBackground.visible = NO;
    [myScene addChild:self.pauseBackground z:80];
    
    self.wavesAndBeach = [CCSprite spriteWithSpriteFrameName:@"st_waves_top_view.png"];
    self.wavesAndBeach.anchorPoint = ccp(0,0);
    self.wavesAndBeach.position = ccp(0,0);
    self.wavesAndBeach.visible=NO;
    [batchNode addChild:self.wavesAndBeach z:10];
    
    //id actionBy = [CCMoveBy actionWithDuration:5 position:ccp(240,0)];
    //[wavesAndBeach runAction:actionBy];
    
    self.rematchButton = [CCSprite spriteWithSpriteFrameName:@"rematch.png"];
    self.rematchButton.position = ccp(35,220);
    self.rematchButton.visible=NO;
    [batchNode addChild:self.rematchButton z:10];
    
    self.mainMenuButton = [CCSprite spriteWithSpriteFrameName:@"main_menu_btn.png"];
    self.mainMenuButton.position = ccp(35,120);
    self.mainMenuButton.visible=NO;
    [batchNode addChild:self.mainMenuButton z:10];
    
    self.resumeButton = [CCSprite spriteWithSpriteFrameName:@"resume_btn.png"];
    self.resumeButton.position = ccp(110,170);
    self.resumeButton.visible=NO;
    [batchNode addChild:self.resumeButton z:10];
    
    self.howToPlayButton = [CCSprite spriteWithSpriteFrameName:@"help_btn.png"];
    self.howToPlayButton.position = ccp(70,50);
    self.howToPlayButton.visible=NO;
    [batchNode addChild:self.howToPlayButton z:10];

    return TRUE;
     
}

-(BOOL) showPauseMenu:(CCLayer *) myScene
{
    self.pauseBackground.visible=YES;
    self.wavesAndBeach.visible=YES;
    self.rematchButton.visible=YES;
    self.mainMenuButton.visible=YES;
    self.resumeButton.visible=YES;
    self.howToPlayButton.visible=YES;
    
    [myScene stopTimer];
    
    return TRUE;
}

-(BOOL) execPauseMenuActions:(CGPoint) touchLocation forScene:(CCLayer *)myScene withId:(SceneTypes)sceneId
{
    BOOL pauseState = YES;
    
    if(CGRectContainsPoint(self.mainMenuButton.boundingBox, touchLocation)){
        pauseState = NO;
        [[GameManager sharedGameManager] runSceneWithId:kMainMenuScene];
    }
    else if(CGRectContainsPoint(self.rematchButton.boundingBox, touchLocation)){
        pauseState = NO;
        [[GameManager sharedGameManager] runSceneWithId:sceneId];
    }
    else if(CGRectContainsPoint(self.howToPlayButton.boundingBox, touchLocation)){
        pauseState = YES;
        [[CCDirector sharedDirector] pushScene:[HowToPlay scene]];
    }
    else if(CGRectContainsPoint(self.resumeButton.boundingBox, touchLocation)){
        pauseState = NO;
        
        self.pauseBackground.visible=NO;
        self.wavesAndBeach.visible=NO;
        self.rematchButton.visible=NO;
        self.mainMenuButton.visible=NO;
        self.resumeButton.visible=NO;
        self.howToPlayButton.visible=NO;
        [myScene startTimer];
    }
    return pauseState;
}

@end
