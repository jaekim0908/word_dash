//
//  MultiPlayerScene.mm
//  HundredSeconds
//
//  Created by Jae Kim on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiPlayerScene.h"
#import "MultiPlayerLayer.h"

@implementation MultiPlayerScene

-(id) init {
	if ((self = [super init])) {
		multiPlayerLayer = [MultiPlayerLayer node];
		[self addChild:multiPlayerLayer];
	}
	
	return self;
}
@end
