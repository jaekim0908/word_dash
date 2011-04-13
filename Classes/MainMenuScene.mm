//
//  MainMenuScene.m
//  HundredSeconds
//
//  Created by Jae Kim on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"


@implementation MainMenuScene

-(id) init {
	
	if ((self = [super init])) {
		mainMenuLayer = [MainMenuLayer node];
		mainMenuLayer.tag = 1;
		[self addChild:mainMenuLayer];
	}
	return self;
}
@end
