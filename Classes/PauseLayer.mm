//
//  PauseLayer.m
//  HundredSeconds
//
//  Created by Michael Ho on 3/21/11.
//  Copyright 2011 self. All rights reserved.
//

#import "PauseLayer.h"
#import "GameManager.h"

@implementation PauseLayer

@synthesize resumeButton;
@synthesize restartButton;
@synthesize midDisplay;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PauseLayer *layer = [PauseLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super initWithColor:ccc4(120, 120, 120, 210)] )) {
		NSLog(@"Inside pause layer.");
		self.isTouchEnabled = YES;
		
		//MCH
		midDisplay = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", 21] fontName:@"MarkerFelt-Thin" fontSize:36] retain];
		midDisplay.position = ccp(240, 160);
		midDisplay.color = ccc3(0, 0, 0);
        midDisplay.visible = NO;
        [self addChild:midDisplay];
        
        
        midDisplayNote = [[CCLabelTTF labelWithString:@"Seconds before autoresuming:" fontName:@"Verdana" fontSize:24] retain];
        midDisplayNote.position = ccp(240, 190);
        midDisplayNote.color = ccc3(0, 0, 0);
        midDisplayNote.visible = NO;
        [self addChild:midDisplayNote];
    }
	return self;
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void) processTimeoutCountdownRequest:(NSString *)timeRemaining
{
    [midDisplay setString:timeRemaining];
    midDisplayNote0.visible = YES;
    midDisplayNote.visible = YES;
    midDisplay.visible = YES;
    
    if([timeRemaining intValue] == 0){
        [self endTimeout];
    }
}

-(void) timeoutCountdown:(ccTime) dt
{
    int c = [[midDisplay string] intValue];
    
    [midDisplay setString:[NSString stringWithFormat:@"%i",--c]];
    midDisplayNote.visible = YES;
    midDisplay.visible = YES;
    
    [self sendTimeoutCountdownValue];
    
    if(c == 0){
        //[self endTimeout];
        //[self unschedule:@selector(timeoutCountdown:)];
        //[self sendResumeRequestAndResume];
    }
    
    
}

- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {
	return YES;
}
@end
