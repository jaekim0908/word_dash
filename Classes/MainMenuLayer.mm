//
//  MainMenuLayer.m
//  HundredSeconds
//
//  Created by Jae Kim on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "OpenFeint+UserOptions.h"
#import "OFUserService.h"
#import "OpenFeint.h"
#import "OFHighScoreService.h"
#import "OpenFeint+Dashboard.h"
#import "Constants.h"
#import "GameManager.h"
#import "HelloWorld.h"
#import "Dictionary.h"
#import "OFMultiplayerService.h"
#import "OFMultiplayerGame.h"
#import "Multiplayer.h"
#import "DialogLayer.h"
#import "ChallengeRequestDialog.h"

@interface MainMenuLayer()
-(void) displayMainMenu;
-(void) displaySceneSelection;
-(void) displayPlayAndPass;
-(void) displayMultiPlayer;
-(void) displayRanking;
@end

@implementation MainMenuLayer

-(id) init {
	NSLog(@"MainMenuLayer init called");
	if ((self = [super init])) {
		self.isTouchEnabled = YES;
		[self displayMainMenu];
		[OFMultiplayerService startViewingGames];
		challengeCancelledLabel = [CCLabelTTF labelWithString:@"Challenger has cancelled the game" fontName:@"Verdana" fontSize:14];
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		challengeCancelledLabel.position = ccp(screenSize.width/2, screenSize.height/2);
		challengeCancelledLabel.color = ccc3(255, 255, 255);
		challengeCancelledLabel.visible = NO;
		[self addChild:challengeCancelledLabel z:10];
		
		challengeRejectedLabel = [CCLabelTTF labelWithString:@"Opponent has rejected the game" fontName:@"Verdana" fontSize:14];
		challengeRejectedLabel.position = ccp(screenSize.width/2, screenSize.height/2);
		challengeRejectedLabel.color = ccc3(255, 255, 255);
		challengeRejectedLabel.visible = NO;
		[self addChild:challengeRejectedLabel z:10];
	}
	
	return self;
}

-(void) displayMainMenu {
	NSLog(@"display main menu");
	
	CCMenuItemImage *playAndPassGameButton = [CCMenuItemImage
											  itemFromNormalImage:@"blue_button.png" 
											  selectedImage:@"blue_button.png"
											  disabledImage:nil
											  target:self
											  selector:@selector(displayPlayAndPass)];
	
	CCMenuItemImage *multiPlayerGameButton = [CCMenuItemImage
											  itemFromNormalImage:@"blue_button.png" 
											  selectedImage:@"blue_button.png"
											  disabledImage:nil
											  target:self
											  selector:@selector(displayMultiPlayer)];
	
	CCMenuItemImage *howToPlayButton =		 [CCMenuItemImage
											  itemFromNormalImage:@"blue_button.png" 
											  selectedImage:@"blue_button.png"
											  disabledImage:nil
											  target:self
											  selector:@selector(displaySceneSelection)];
	
	CCMenuItemImage *rankingButton =		[CCMenuItemImage 
												itemFromNormalImage:@"blue_button.png"
												selectedImage:@"blue_button.png"
												disabledImage:nil
												target:self
												selector:@selector(displayRanking)];
	
	mainMenu = [CCMenu menuWithItems:playAndPassGameButton, multiPlayerGameButton, howToPlayButton, rankingButton, nil];
	[mainMenu alignItemsVerticallyWithPadding:5.0f];
	[mainMenu setPosition:ccp(480, 160)];
	id moveAction = [CCMoveTo actionWithDuration:1.2f 
										position:ccp(480 * 0.85f, 160)];
	
	id moveEffect = [CCEaseIn actionWithAction:moveAction 
										  rate:1.0f];
	[mainMenu runAction:moveEffect];
	[self addChild:mainMenu z:0 tag:1];
	[[Dictionary sharedDictionary] loadDictionary];
}

-(void) displaySceneSelection {
	NSLog(@"display scene selection");
}

-(void) displayRanking {
	NSLog(@"display ranking");
	//[OpenFeint launchDashboardWithHighscorePage:@"650204"];
	[OpenFeint launchDashboard];
}

-(void) displayPlayAndPass {
	NSLog(@"display play and pass");
	[[GameManager sharedGameManager] runLoadingSceneWithTargetId:kHelloWorldScene];
}

-(void) displayMultiPlayer {
	CCLOG(@"display multi-player");
	[self closeMultiPlayerGame];
	if ([OpenFeint isOnline]) { 
		[OFFriendPickerController launchPickerWithDelegate:[[GameManager sharedGameManager] myOFDelegate] 
												promptText:@"Choose your victim" 
									 mustHaveApplicationId:nil];
	} else {
		CCLayer *dialogLayer = [[[DialogLayer alloc] initWithHeader:@"header" 
														   andLine1:@"line1" 
														   andLine2:@"line2" 
														   andLine3:@"line3" 
															 target:self 
														   selector:@selector(enableMainMenu)] 
								autorelease];
		dialogLayer.tag = 8;
		[[[CCDirector sharedDirector] runningScene] addChild:dialogLayer z:10];
		mainMenu.isTouchEnabled = NO;
	}
}

-(void) disableMainMenu {
	NSLog(@"disableMainMenu is called");
	mainMenu.isTouchEnabled = NO;
}

-(void) enableMainMenu {
	NSLog(@"enableMainMenu is called");
	mainMenu.isTouchEnabled = YES;
}

- (void) closeMultiPlayerGame {
	OFMultiplayerGame *game = [OFMultiplayerService getSlot:0];
	[game closeGame];
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CCLOG(@"ccTouchBegan in MainMenuLayer");
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
	return YES;
}

-(void) showCancelChallengeMsg {
	CCLOG(@"Show CancelChallengeMsg called");
	NSString *chlName = [[[GameManager sharedGameManager] myOFDelegate] challengerName];
	NSString *str = nil;
	if (chlName) {
		CCLOG(@"chlName = %@", chlName);
		str = [NSString stringWithFormat:@"Sorry, %@ has cancelled the challenger", chlName];
	} else {
		CCLOG(@"chlName is nil");
		str = [NSString stringWithFormat:@"Sorry, challenger has cancelled the challenge"];
	}
	[challengeCancelledLabel setString:str];
	challengeCancelledLabel.visible = YES;
	CCSequence *actSeq = [CCSequence actions:[CCFadeIn actionWithDuration:0.1f], [CCFadeOut actionWithDuration:2], nil];
	[challengeCancelledLabel runAction:actSeq];
}

-(void) showRejectChallengeMsg {
	CCLOG(@"Show RejectChallengeMsg called");
	NSString *str = nil;
	if ([[[GameManager sharedGameManager] myOFDelegate] challengeeName]) {
		CCLOG(@"challengeeName in showRejectChallengeMsg = %@", [[[GameManager sharedGameManager] myOFDelegate] challengeeName]);
		str = [NSString stringWithFormat:@"Sorry, %@ has rejected the challenge", [[[GameManager sharedGameManager] myOFDelegate] challengeeName]];
	} else {
		CCLOG(@"challengeeName is nil");
		str = [NSString stringWithFormat:@"Sorry, opponent has cancelled the challenge"];
	}
	[challengeRejectedLabel setString:str];
	challengeRejectedLabel.visible = YES;
	CCSequence *actSeq = [CCSequence actions:[CCFadeIn actionWithDuration:0.1f], [CCFadeOut actionWithDuration:2], nil];
	[challengeRejectedLabel runAction:actSeq];
}

-(void) dealloc {
	// doing some clean-up for multiplayer game.
	//CLOSE MP GAME
	//[self closeMultiPlayerGame];
	CCLOG(@"MainManuLayer dealloc called");
	[super dealloc];
}

@end
