//
//  DialogLayer.m
//  HundredSeconds
//
//  Created by Jae Kim on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DialogLayer.h"


@implementation DialogLayer
-(id) initWithHeader:(NSString *)header andLine1:(NSString *)line1 andLine2:(NSString *)line2 andLine3:(NSString *)line3 target:(id)callbackObj selector:(SEL)selector
{
	if((self=[super initWithColor:ccc4(100, 100, 100, 255)])) {
		
		self.isTouchEnabled = YES;
		NSLog(@"callback object = %@", callbackObj);
		
		NSMethodSignature *sig = [[callbackObj class] instanceMethodSignatureForSelector:selector];
		callback = [NSInvocation invocationWithMethodSignature:sig];
		NSLog(@"callback = %@", callback);
		[callback setTarget:callbackObj];
		[callback setSelector:selector];
		[callback retain];
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		/*
		CCSprite *background = [CCSprite node];
		[background initWithFile:@"Dialog.png"];
		[background setPosition:ccp(screenSize.width / 2, screenSize.height / 2)];
		[self addChild:background z:-1];
		
		CCLabelBMFont *headerShadow = [CCLabelBMFont labelWithString:header fntFile:DIALOG_FONT];
		headerShadow.color = ccGRAY;
		headerShadow.opacity = 127;
		[headerShadow setPosition:ccp(243, 262)];
		[self addChild:headerShadow];
		
		CCLabelBMFont *headerLabel = [CCLabelBMFont labelWithString:header fntFile:DIALOG_FONT];
		headerLabel.color = ccBLACK;
		[headerLabel setPosition:ccp(240, 265)];
		[self addChild:headerLabel];
		
		CCLabelBMFont *line1Label = [CCLabelBMFont labelWithString:line1 fntFile:DIALOG_FONT];
		line1Label.color = ccBLACK;
		line1Label.scale = 0.84f;
		[line1Label setPosition:ccp(240, 200)];
		[self addChild:line1Label];
		
		CCLabelBMFont *line2Label = [CCLabelBMFont labelWithString:line2 fntFile:DIALOG_FONT];
		line2Label.color = ccBLACK;
		line2Label.scale = 0.84f;
		[line2Label setPosition:ccp(240, 160)];
		[self addChild:line2Label];
		
		CCLabelBMFont *line3Label = [CCLabelBMFont labelWithString:line3 fntFile:DIALOG_FONT];
		line3Label.color = ccBLACK;
		line3Label.scale = 0.84f;
		[line3Label setPosition:ccp(240, 120)];
		[self addChild:line3Label];
		*/
		
		CCLabelTTF *line1Label = [CCLabelTTF labelWithString:@"This game mode is only available when you are logged in OpenFeint" fontName:@"Verdana" fontSize:12];
		line1Label.color = ccc3(255, 255, 255);
		line1Label.position = ccp(screenSize.width/2, screenSize.height/2 + 50);
		[self addChild:line1Label];
		
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
	NSLog(@"ok button pressed");
	NSLog(@"callback in okButtonPressed = %@", callback);
	[callback invoke];
	[self removeFromParentAndCleanup:YES];
}

-(void) dealloc
{
	NSLog(@"dialog layer dealloc called");
	[callback release];
	[super dealloc];
}
@end