//
//  PlayerSprite.h
//  CatRace
//
//  Created by Ray Wenderlich on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

typedef enum {
    kPlayerSpriteDog,
    kPlayerSpriteKid
} PlayerSpriteType;

@interface PlayerSprite : CCSprite {
    
    BOOL isMoving;
    CGPoint moveTarget;
    CCAction *moveAction;
    CCAction *animateAction;
    
}

@property (assign) CGPoint moveTarget;

- (id)initWithType:(PlayerSpriteType)type;
- (void)moveForward;

@end
