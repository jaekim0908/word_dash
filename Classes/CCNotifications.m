//
//  CCNotifications.m
//  FullVersion
//
//  Created by Manuel Martinez-Almeida Castañeda on 21/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CCNotifications.h"

/*
@implementation CCNotificationDefaultDesign

- (id) init
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	self = [self initWithColor:ccc4(0, 0, 0, 180) width:size.width height:38];
	if (self != nil) {
		[self setIsRelativeAnchorPoint:YES];
		[self setVisible:NO];

		[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_A8];
		CCSprite* bottom = [CCSprite spriteWithFile:@"barraMenu.png"];
		[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA4444];
		[bottom setRotation:180];
		[bottom setPosition:ccp(contentSize_.width/2.0f, -10)];
		[bottom setOpacityModifyRGB:NO];
		
		ccColor3B newColor = color_;
		newColor = ccc3((float)newColor.r*0.5f+255.0f*0.5f, (float)newColor.g*0.5f+255.0f*0.5f, (float)newColor.b*0.5f+255.0f*0.5f);
		[bottom setColor:newColor];
		
		title_ = [CCLabel labelWithString:nil fontName:@"Arial" fontSize:12];
		[title_ setIsRelativeAnchorPoint:NO];
		[title_ setAnchorPoint:CGPointZero];
		[title_ setPosition:ccp(52, 20)];

		message_ = [CCLabel labelWithString:nil fontName:@"Arial" fontSize:15];
		[message_ setIsRelativeAnchorPoint:NO];
		[message_ setAnchorPoint:CGPointZero];
		[message_ setPosition:ccp(52, 3)];
		
		image_ = [CCSprite node];
		[image_ setPosition:ccp(26, 19)];

		[self addChild:title_];
		[self addChild:message_];
		[self addChild:image_];
		[self addChild:bottom];
	}
	return self;
}

- (void) setTitle:(NSString*)title message:(NSString*)message texture:(CCTexture2D*)texture{
	[title_ setString:title];
	[message_ setString:message];
	if(texture){
		CGRect rect = CGRectZero;
		rect.size = texture.contentSize;
		[image_ setTexture:texture];
		[image_ setTextureRect:rect];
	}
}

- (void) updateColor
{
	ccColor3B colorFinal = ccc3(0, 50, 100);
	
	squareColors[0] = color_.r;
	squareColors[1] = color_.g;
	squareColors[2] = color_.b;
	squareColors[3] = opacity_;
	
	squareColors[4] = color_.r;
	squareColors[5] = color_.g;
	squareColors[6] = color_.b;
	squareColors[7] = opacity_;
	
	squareColors[8] = colorFinal.r;
	squareColors[9] = colorFinal.g;
	squareColors[10] = colorFinal.b;
	squareColors[11] = opacity_;
	
	squareColors[12] = colorFinal.r;
	squareColors[13] = colorFinal.g;
	squareColors[14] = colorFinal.b;
	squareColors[15] = opacity_;
}

@end
*/
@implementation CCNotificationDefaultDesign

- (id) init
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	self = [self initWithColor:ccc4(42, 68, 148, 180) width:size.width height:38];
	if (self != nil) {
		title_ = [CCLabelTTF labelWithString:nil fontName:@"Arial" fontSize:12];
		[title_ setIsRelativeAnchorPoint:NO];
		[title_ setAnchorPoint:CGPointZero];
		[title_ setPosition:ccp(52, 20)];
		
		message_ = [CCLabelTTF labelWithString:nil fontName:@"Arial" fontSize:15];
		[message_ setIsRelativeAnchorPoint:NO];
		[message_ setAnchorPoint:CGPointZero];
		[message_ setPosition:ccp(52, 3)];
		
		image_ = [CCSprite node];
		[image_ setPosition:ccp(26, 19)];
		
		[self addChild:title_];
		[self addChild:message_];
		[self addChild:image_];
	}
	return self;
}

- (void) setTitle:(NSString*)title message:(NSString*)message texture:(CCTexture2D*)texture{
	[title_ setString:title];
	[message_ setString:message];
	if(texture){
		CGRect rect = CGRectZero;
		rect.size = texture.contentSize;
		[image_ setTexture:texture];
		[image_ setTextureRect:rect];
		//Same size 32x32
		[image_ setScaleX:32.0f/rect.size.width];
		[image_ setScaleY:32.0f/rect.size.height];
	}
}

- (void) updateColor
{
	ccColor3B colorFinal = ccc3(0, 50, 100);
	
	squareColors[0] = color_.r;
	squareColors[1] = color_.g;
	squareColors[2] = color_.b;
	squareColors[3] = opacity_;
	
	squareColors[4] = color_.r;
	squareColors[5] = color_.g;
	squareColors[6] = color_.b;
	squareColors[7] = opacity_;
	
	squareColors[8] = colorFinal.r;
	squareColors[9] = colorFinal.g;
	squareColors[10] = colorFinal.b;
	squareColors[11] = opacity_;
	
	squareColors[12] = colorFinal.r;
	squareColors[13] = colorFinal.g;
	squareColors[14] = colorFinal.b;
	squareColors[15] = opacity_;
}

@end


@interface CCNotifications (Private)

- (CCActionInterval*) animation:(char)type time:(ccTime)time;
- (void) hideNotificationScheduler;

@end


@implementation CCNotifications
@synthesize animationIn = animationIn_;
@synthesize animationOut = animationOut_;
@synthesize state = state_;
@synthesize delegate = delegate_;

static CCNotifications *sharedManager;

+ (CCNotifications *)sharedManager
{
	if (!sharedManager)
		sharedManager = [[CCNotifications alloc] init];
	
	return sharedManager;
}

+(id)alloc
{
	NSAssert(sharedManager == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

+(void)purgeSharedManager
{
	[sharedManager release];
}

-(id) init
{
	if( (self=[super init]) ) {
		delegate_ = nil;
		notification = [[CCNotificationDefaultDesign alloc] init];
		[notification setIsRelativeAnchorPoint:YES];
		[notification setVisible:NO];
		tag_ = -1;
		state_ = kCCNotificationStateHide;
		timeShowing_ = 3.2f;
		typeAnimationIn_ = 0;
		typeAnimationOut_ = 0;
		position_ = kCCNotificationPositionTop;

		[self setAnimation:kCCNotificationAnimationMovement time:0.2f];
		timer_ = [[CCTimer alloc] initWithTarget:self selector:@selector(hideNotificationScheduler)];
	}	
	return self;
}

- (void) setState:(char)states{
	if(state_==states) return;
	[delegate_ notificationChangeState:states tag:tag_];
}

- (void) setPosition:(char)position{
	position_ = position;
	[self updateAnimations];
}

#pragma mark Notification Actions

- (CCActionInterval*) animation:(char)type time:(ccTime)time{
	CCActionInterval *action = nil;
	switch (type) {
		case kCCNotificationAnimationMovement:
			if(position_==kCCNotificationPositionBottom)
				action = [CCMoveBy actionWithDuration:time position:ccp(0, [notification contentSize].height)];
			else if(position_ == kCCNotificationPositionTop)
				action = [CCMoveBy actionWithDuration:time position:ccp(0, -[notification contentSize].height)];
			break;
		case kCCNotificationAnimationScale:
				action = [CCScaleBy actionWithDuration:time scale:1.0f-0.0001f];
			break;
		default: return nil;
	}
	return action;
}

- (void) updateAnimationIn{
	self.animationIn = [CCSequence actionOne:[self animation:typeAnimationIn_ time:timeAnimationIn_] two:[CCCallFunc actionWithTarget:self selector:@selector(startScheduler)]];
}

- (void) updateAnimationOut{
	CCActionInterval *tempAction = [self animation:typeAnimationOut_ time:timeAnimationOut_];
	self.animationOut = [CCSequence actionOne:[tempAction reverse] two:[CCCallFunc actionWithTarget:self selector:@selector(hideNotification)]];
}

- (void) updateAnimations{
	[self updateAnimationIn];
	[self updateAnimationOut];
}

- (void) setAnimationIn:(char)type time:(ccTime)time{
	typeAnimationIn_ = type;
	timeAnimationIn_ = time;
	[self updateAnimationIn];
}

- (void) setAnimationOut:(char)type time:(ccTime)time{
	typeAnimationOut_ = type;
	timeAnimationOut_ = time;
	[self updateAnimationOut];
}

- (void) setAnimation:(char)type time:(ccTime)time{
	typeAnimationIn_ = typeAnimationOut_ = type;
	timeAnimationIn_ = timeAnimationOut_ = time;
	[self updateAnimations];
}

#pragma mark Notification steps

- (void) startScheduler{
	[[CCTouchDispatcher sharedDispatcher] addStandardDelegate:self priority:10000];
	[self setState:kCCNotificationStateShowing];
	[timer_ setInterval:timeShowing_];
	//[[CCScheduler sharedScheduler] scheduleTimer:timer_];
    [[CCScheduler sharedScheduler] scheduleSelector:@selector(hideNotificationScheduler) forTarget:self interval:timeShowing_ paused:NO];
}

- (void) hideNotification{
	[self setState:kCCNotificationStateHide];
	[notification setVisible:NO];
	[notification onExit];
}

- (void) hideNotificationScheduler{

	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	//[[CCScheduler sharedScheduler] unscheduleTimer:timer_];
    [[CCScheduler sharedScheduler] unscheduleSelector:@selector(hideNotificationScheduler) forTarget:self];
	if(animated_){
		[self setState:kCCNotificationStateAnimationOut];
		[notification runAction:animationOut_];
	}else
		[self hideNotification];
}

#pragma mark Manager Notifications

- (void) addNotificationTitle:(NSString*)title message:(NSString*)message texture:(CCTexture2D*)texture tag:(int)tag animate:(BOOL)animate{
	if(state_!=kCCNotificationStateHide){
		if(delegate_)
			[delegate_ notificationChangeState:kCCNotificationStateHide tag:tag_];
	}
	tag_ = tag;
	animated_ = animate;
	//[[CCScheduler sharedScheduler] unscheduleTimer:timer_];
    [[CCScheduler sharedScheduler] unscheduleSelector:@selector(hideNotificationScheduler) forTarget:self];
	[notification stopAllActions];
	[notification onEnter];
	[notification setVisible:YES];
	[notification setTitle:title message:message texture:texture];
	
	if(animate){
		CGSize size = [[CCDirector sharedDirector] winSize];
		if(position_==kCCNotificationPositionBottom){
			[notification setAnchorPoint:ccp(0.5f, 0)];
			switch (typeAnimationIn_) {
				case kCCNotificationAnimationMovement:
					[notification setPosition:ccp(size.width/2.0f, -[notification contentSize].height)];
					break;
				case kCCNotificationAnimationScale:
					[notification setScale:0.0001f];
					[notification setPosition:ccp(size.width/2.0f, 0)];
					break;
			}
		}else if(position_==kCCNotificationPositionTop){
			[notification setAnchorPoint:ccp(0.5f, 1)];
			switch (typeAnimationIn_) {
				case kCCNotificationAnimationMovement:
					[notification setPosition:ccp(size.width/2.0f, size.height+[notification contentSize].height)];
					break;
				case kCCNotificationAnimationScale:
					[notification setScale:0.0001f];
					[notification setPosition:ccp(size.width/2.0f, size.height)];
					break;
			}
		}
		[notification runAction:animationIn_];
	}else{
		if(position_==kCCNotificationPositionBottom){
			[notification setAnchorPoint:ccp(0.5f, 0)];
			[notification setPosition:ccp([[CCDirector sharedDirector] winSize].width/2.0f, 0)];
		}else if(position_==kCCNotificationPositionTop){
			[notification setAnchorPoint:ccp(0.5f, 1)];
			[notification setPosition:ccp([[CCDirector sharedDirector] winSize].width/2.0f, [[CCDirector sharedDirector] winSize].height)];
		}
		[self startScheduler];
	}
}

- (void) addNotificationTitle:(NSString*)title message:(NSString*)message image:(NSString*)image tag:(int)tag animate:(BOOL)animate{
	CCTexture2D *texture = (image==nil) ? nil : [[CCTextureCache sharedTextureCache] addImage:image];
	[self addNotificationTitle:title message:message texture:texture tag:tag animate:animate];
}

#pragma mark Touch CallBack

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addStandardDelegate:self priority:0];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint point = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	CGRect rect = [notification boundingBox];
	if(CGRectContainsPoint(rect, point))
		if([delegate_ touched:tag_])
			[self hideNotificationScheduler];
}

#pragma mark Other methods

- (void) visit{
	if(notification.visible)
		[notification visit];
}


- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %08X>", [self class], self];
}

-(void) dealloc
{
	CCLOG(@"cocos2d: deallocing %@", self);
	
	[notification release];
	[timer_ release];
	[self setDelegate:nil];
	[self setAnimationIn:nil];
	[self setAnimationOut:nil];
	sharedManager = nil;
	[super dealloc];
}
@end
