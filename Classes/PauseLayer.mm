//
//  PauseLayer.m
//  HundredSeconds
//
//  Created by Michael Ho on 3/21/11.
//  Copyright 2011 self. All rights reserved.
//

#import "PauseLayer.h"
#import "GameManager.h"
#import "Multiplayer.h"
#import "OFMultiplayerService.h"
#import "OFMultiplayerService+Advanced.h"


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


        if ([OFMultiplayerService isItMyTurn]) {
            //CAN ONLY RESUME IF IT'S YOUR TURN
            resumeButton = [CCSprite spriteWithFile:@"BluePlayButton.png"];
            resumeButton.position = ccp(390, 225);
            [self addChild:resumeButton];
            
            restartButton = [CCSprite spriteWithFile:@"button_blue_repeat.png"];
            restartButton.position = ccp(330, 225);
            restartButton.visible = NO;
            [self addChild:restartButton];
            
            //BEGIN TIMER TO AUTO-RESUME IF PAUSE IS NOT PRESSED WITHIN 20 SECONDS
            [self schedule:@selector(timeoutCountdown:) interval:1.0f];
        }
        else{
            midDisplayNote0 = [[CCLabelTTF labelWithString:@"Seconds before autoresuming:" fontName:@"Verdana" fontSize:24] retain];
            midDisplayNote0.position = ccp(240, 220);
            midDisplayNote0.color = ccc3(0, 0, 0);
            midDisplayNote0.visible = NO;
            [self addChild:midDisplayNote0];
            [midDisplayNote0 setString:@"Game paused by opponent."];
        }
            
        //NEXT: PERFORM COUNTDOWN OF PAUSE
        
        
		
	}
	return self;
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(void) restartGame
{
    Multiplayer *MultiplayerLayer = (Multiplayer *)[[[CCDirector sharedDirector] runningScene] getChildByTag:0];
    
    [[[CCDirector sharedDirector] runningScene] removeChild:MultiplayerLayer cleanup:YES];
    
    
    [[[CCDirector sharedDirector] runningScene] removeChild:self cleanup:YES];
    [[GameManager sharedGameManager] runLoadingSceneWithTargetId:kMainMenuScene];
    
}

-(void) sendResumeRequestAndResume
{
    Multiplayer *MultiplayerLayer = (Multiplayer *)[[[CCDirector sharedDirector] runningScene] getChildByTag:0];
    
    //[[[CCDirector sharedDirector] runningScene] removeChild:MultiplayerLayer cleanup:YES];
    [MultiplayerLayer sendMove:@"RESUME_GAME" 
                        rowNum:0 colNum:0 value:@"" endTurn:NO];
    
    
    [MultiplayerLayer schedule:@selector(updateTimer:) interval:1.0f];
    [[[CCDirector sharedDirector] runningScene] removeChild:self cleanup:YES];
    //[[GameManager sharedGameManager] runLoadingSceneWithTargetId:kMainMenuScene];
    
}

-(void) remoteResumeRequest
{
    Multiplayer *MultiplayerLayer = (Multiplayer *)[[[CCDirector sharedDirector] runningScene] getChildByTag:0];
    [MultiplayerLayer schedule:@selector(updateTimer:) interval:1.0f];
    [[[CCDirector sharedDirector] runningScene] removeChild:self cleanup:YES];
}

-(void) endTimeout
{
    [self unschedule:@selector(timeoutCountdown:)];
    
    Multiplayer *MultiplayerLayer = (Multiplayer *)[[[CCDirector sharedDirector] runningScene] getChildByTag:0];
    [MultiplayerLayer schedule:@selector(updateTimer:) interval:1.0f];
    [[[CCDirector sharedDirector] runningScene] removeChild:self cleanup:YES];
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

- (void) sendTimeoutCountdownValue
{
    Multiplayer *MultiplayerLayer = (Multiplayer *)[[[CCDirector sharedDirector] runningScene] getChildByTag:0];
    [MultiplayerLayer sendMove:@"TIMER_COUNTDOWN_TIMEOUT" 
                        rowNum:0 colNum:0 value:[midDisplay string] endTurn:NO];
    
    //[MultiplayerLayer schedule:@selector(updateTimer:) interval:1.0f];
    //[[[CCDirector sharedDirector] runningScene] removeChild:self cleanup:YES];
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
        [self unschedule:@selector(timeoutCountdown:)];
        [self sendResumeRequestAndResume];
    }
    
    
}

- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {
	
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
	
	if(CGRectContainsPoint(resumeButton.boundingBox, touchLocation)){
				
		NSLog(@"Resume Button pressed.");
        if ([OFMultiplayerService isItMyTurn]) {
            [self sendResumeRequestAndResume];
            
        }
        else{
            //[self schedule:@selector(checkMyTurnThenResume:) interval:1.0f];
        }
		
	}
    else if(CGRectContainsPoint(restartButton.boundingBox, touchLocation)){
        NSLog(@"Resume Button pressed.");
        if ([OFMultiplayerService isItMyTurn]) {
            Multiplayer *MultiplayerLayer = (Multiplayer *)[[[CCDirector sharedDirector] runningScene] getChildByTag:0];
            [MultiplayerLayer sendMove:@"RESTART_GAME" 
                                rowNum:0 colNum:0 value:@"" endTurn:NO];
            [self restartGame];
        }
    }
	
	return YES;
}
@end
