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
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Loading ..." fontName:@"Verdana" fontSize:64];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position = CGPointMake(size.width/2, size.height/2);
		[self addChild:label];
		[self scheduleUpdate];
	}
	
	return self;
}

-(void) update:(ccTime) delta {
	[self unscheduleAllSelectors];
	[[GameManager sharedGameManager] runSceneWithId: _targetScene];
}

@end
