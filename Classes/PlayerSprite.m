//
//  PlayerSprite.m
//  CatSmash
//
//  Created by Ray Wenderlich on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayerSprite.h"

@implementation PlayerSprite
@synthesize moveTarget;

- (id)initWithType:(PlayerSpriteType)type {
    
    // Create an animation based on the type
    // Also keep track of the initial sprite frame name
    CCAnimation *animation = [CCAnimation animation];
    animation.delay = 0.2;
    NSString *spriteFrameName;
    if (type == kPlayerSpriteDog) {
        spriteFrameName = @"dog_1.png";
        for(int i = 1; i <= 4; ++i) {
            [animation addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"dog_%d.png", i]]];
        }
    } else {
        spriteFrameName = @"kidontrike_1.png";
        for(int i = 1; i <= 4; ++i) {
            [animation addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"kidontrike_%d.png", i]]];
        }
    }
    
    // Initialize the base class (CCSprite) with the initial sprite frame name
    if ((self = [super initWithSpriteFrameName:spriteFrameName])) {
        
        // Create a animation action for use later and retain it so it doesn't go away
        animateAction = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]] retain];
        
    }
    return self;
}

-(void)moveDone {
    
    // When the move is done, stop the animation action
    isMoving = FALSE;
    moveAction = nil;
    [self stopAction:animateAction];
    
}

- (void)moveForward {
    
    // Animate player if he isn't already
    if (!isMoving) {
        isMoving = YES;
        [self runAction:animateAction];
    }
    
    // Stop old move sequence
    [self stopAction:moveAction];
    
    // Figure new position to move to and create new move sequence
    moveTarget = ccpAdd(moveTarget, ccp(10, 0));
    CCMoveTo *moveToAction = [CCMoveTo actionWithDuration:0.5 position:moveTarget];
    CCCallFunc *callFuncAction = [CCCallFunc actionWithTarget:self selector:@selector(moveDone)];
    moveAction = [CCSequence actions:moveToAction, callFuncAction, nil];
    
    // Run new move sequence
    [self runAction:moveAction];
    
}

- (void)dealloc {
    
    // Cleanup
    [animateAction release];
    animateAction = nil;
    [super dealloc];
    
}

@end
