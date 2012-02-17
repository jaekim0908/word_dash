//
//  LoadingScene.m
//  HundredSeconds
//
//  Created by Jae Kim on 3/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "LoadingScene.h"
#import "GameManager.h"


@implementation LoadingScene

+(id) sceneWithTargetScene:(SceneTypes) targetScene {
	return [[[self alloc] initWithTargetScene:targetScene] autorelease];
}

-(id) initWithTargetScene:(SceneTypes) targetScene {
	NSLog(@"LoadingScene initWithTargetScene");
	if ((self = [super init])) {
		_targetScene = targetScene;
        
        
        CCSprite *titlePage = [CCSprite spriteWithFile:@"loadingPage2.png"];
        //CCSprite *titlePage = [CCSprite spriteWithFile:@"whiteSandBg.png"];
        titlePage.position = ccp(240,160);
		[self addChild:titlePage];
        
        //CCSprite *loadingLiteral = [CCSprite spriteWithFile:@"loadingLiteral.png"];
        //loadingLiteral.position = ccp(240,48);
		//[self addChild:loadingLiteral z:5];
        
        //CCLabelTTF *label = [CCLabelTTF labelWithString:@"Loading ..." fontName:@"Verdana" fontSize:48];
		//CGSize size = [[CCDirector sharedDirector] winSize];
        //label.color = ccc3(255, 255, 0);
		//label.position = ccp(240, 160);
        //[self addChild:label z:5];

		[self scheduleUpdate];
	}
	
	return self;
}

-(void) update:(ccTime) delta {
	[self unscheduleAllSelectors];
	[[GameManager sharedGameManager] runSceneWithId: _targetScene];
}

@end
