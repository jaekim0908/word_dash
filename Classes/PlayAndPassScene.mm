//
//  PlayAndPassScene.mm
//  HundredSeconds
//
//  Created by Jae Kim on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayAndPassScene.h"


@implementation PlayAndPassScene

-(id) init {
	if ((self = [super init])) {
		pnpLayer = [PlayAndPassLayer node];
		[self addChild:pnpLayer];
	}
	return self;
}

@end
