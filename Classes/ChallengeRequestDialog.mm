//
//  DialogLayer.m
//  HundredSeconds
//
//  Created by Jae Kim on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameManager.h"
#import "ChallengeRequestDialog.h"
#import "cocos2d.h"
#import "MainMenuLayer.h"


@implementation ChallengeRequestDialog
-(id) initWithActivityInd:(BOOL)actInd target:(id)callbackObj selector:(SEL)selector
{
	if((self=[super initWithColor:ccc4(0, 0, 0, 255)])) {
		
		NSMethodSignature *sig = [[callbackObj class] instanceMethodSignatureForSelector:selector];
		callback = [NSInvocation invocationWithMethodSignature:sig];
		NSLog(@"callback = %@", callback);
		[callback setTarget:callbackObj];
		[callback setSelector:selector];
		[callback retain];
		
		self.isTouchEnabled = YES;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		NSString *opptName = [[[GameManager sharedGameManager] myOFDelegate] challengeeName];
		NSString *waitingMsg;
		
		CCLOG(@"oppt name = %@", opptName);
		
		
		if (opptName) {
			waitingMsg = [NSString stringWithFormat:@"Waiting for %@'s response",opptName]; 
		} else {
			waitingMsg = [NSString stringWithFormat:@"Waiting for opponent's response"];
		}
		CCLabelTTF *line1Label = [CCLabelTTF labelWithString:waitingMsg fontName:@"Verdana" fontSize:12];
		line1Label.color = ccc3(255, 255, 255);
		line1Label.position = ccp(screenSize.width/2, screenSize.height/2 + 100);
		[self addChild:line1Label];
		
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[spinner setCenter:CGPointMake(screenSize.width/2, screenSize.height/2 + 75)]; // I do this because I'm in landscape mode
		[[[CCDirector sharedDirector] openGLView] addSubview:spinner];
		[spinner startAnimating];
		
		CCMenuItemImage *okButton = [CCMenuItemImage itemFromNormalImage:@"blue_button.png" selectedImage:@"blue_button.png" target:self selector:@selector(okButtonPressed:)];
		
		CCMenu *menu = [CCMenu menuWithItems: okButton, nil];
		menu.position = ccp(screenSize.width/2, screenSize.height/2);
		[self addChild:menu];
	}
	return self;
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CCLOG(@"ccTouchBegan in DialogLayer");
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
	return YES;
}

-(void) okButtonPressed:(id) sender
{	
	CCLOG(@"ok button pressed");
	[spinner stopAnimating];
	[callback invoke];
	[self removeFromParentAndCleanup:YES];
}

-(void) noCancelButtonPressed:(id) sender {
	CCLOG(@"No cancel button pressed");
	[spinner stopAnimating];
	[callback invoke];
	[self removeFromParentAndCleanup:YES];
	MainMenuLayer *mml = (MainMenuLayer *) [[[CCDirector sharedDirector] runningScene] getChildByTag:1];
	[mml showRejectChallengeMsg];
}

-(void) dealloc
{
	NSLog(@"challenge request dealloc called");
	[spinner stopAnimating];
	[spinner release];
	[callback release];
	[super dealloc];
}
@end