//
//  Cell.h
//  WordToo
//
//  Created by Jae Kim on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import	"cocos2d.h"

@interface Cell : NSObject {
	CCLabelTTF *_letter;
	CCSprite *_letterBackground;
	CCSprite *_letterSelected;
	CCSprite *_letterSelected2;
	CCSprite *_redBackground;
	NSString *_value;
	CGPoint _center;
	int _owner;
	CCLabelTTF *_currentOwner;
	CCSprite *_star;
}

@property (retain) CCLabelTTF *letter;
@property (retain) CCSprite *letterBackground;
@property (retain) CCSprite *letterSelected;
@property (retain) CCSprite *letterSelected2;
@property (retain) NSString *value;
@property (assign) CGPoint center;
@property (assign) int owner;
@property (retain) CCLabelTTF *currentOwner;
@property (retain) CCSprite *redBackground;
@property (retain) CCSprite *star;

@end
