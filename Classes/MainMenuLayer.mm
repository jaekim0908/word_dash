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
#import "OFSocialNotificationApi.h"
#import "CCAlertView.h"
#import "AIDictionary.h"

@interface UIAlertView (extended)
-(void) setNumberOfRows:(int) num;
@end

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
        [GameManager sharedGameManager].isChallenger = NO;
        [GameManager sharedGameManager].hasFriendsWithThisApp = NO;
        [[GameManager sharedGameManager] closeGame];
		[self displayMainMenu];// Load Dictionary
		[GameManager sharedGameManager].gameStatus = kGameNone;
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
        [self getFriendsWithThisApp];
        
        // Retina Display Support
        if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mainMenuImageAssets-hd.plist"];
            batchNode = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"mainMenuImageAssets-hd.png"]];
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mainMenuImageAssets.plist"];
            batchNode = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"mainMenuImageAssets.png"]];
        }
		[self addChild:batchNode z:10];
        
        CCSprite *titleImg = [CCSprite spriteWithSpriteFrameName:@"gameTitle.png"];
        titleImg.position = ccp(screenSize.width/2, screenSize.height/1.1);
        [batchNode addChild:titleImg z:5];
        
        //CCSprite *backgroundImg = [CCSprite spriteWithFile:@"redpaper.png"];
        //CCSprite *backgroundImg = [CCSprite spriteWithFile:@"whiteBg.png"];
        //CCSprite *backgroundImg = [CCSprite spriteWithFile:@"blueDenimBg.png"];
        CCSprite *backgroundImg = [CCSprite spriteWithFile:@"whiteSandBg.png"];
        backgroundImg.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:backgroundImg];
        
        playAndPassLabel = [CCSprite spriteWithSpriteFrameName:@"playAndPassLable5.png"];
        playAndPassLabel.position = ccp(screenSize.width/4, screenSize.height/1.4);
        [batchNode addChild:playAndPassLabel z:7];
        
        playAndPassSelected = [CCSprite spriteWithSpriteFrameName:@"playAndPassSelected.png"];
        playAndPassSelected.position = ccp(screenSize.width/4, screenSize.height/1.4);
        playAndPassSelected.visible = NO;
        [batchNode addChild:playAndPassSelected];
        
        /*
        CCSprite *playButton = [CCSprite spriteWithFile:@"playImg.png"];
        playButton.position = ccp(screenSize.width/4, screenSize.height/1.7);
        [self addChild:playButton z:7];
        playButton.visible = NO;
        */
        
        /*
        playAndPassImg = [CCSprite spriteWithFile:@"purpleSunSet.png"];
        playAndPassImg.position = ccp(screenSize.width/4, screenSize.height/1.7);
        [self addChild:playAndPassImg];
        playAndPassImg.visible = NO;
        */
        
        playWithFriendsLabel = [CCSprite spriteWithSpriteFrameName:@"playWithFriendsLabel5.png"];
        //position with img
        //playWithFriendsLabel.position = ccp(screenSize.width/1.5, screenSize.height/1.6);
        playWithFriendsLabel.position = ccp(screenSize.width/2.5, screenSize.height/2);
        [batchNode addChild:playWithFriendsLabel z:7];
        
        playWithFriendsSelected = [CCSprite spriteWithSpriteFrameName:@"playWithFriendsSelected.png"];
        playWithFriendsSelected.position = ccp(screenSize.width/2.5, screenSize.height/2);
        playWithFriendsSelected.visible = NO;
        [batchNode addChild:playWithFriendsSelected];
        
        /*
        CCSprite *playButton2 = [CCSprite spriteWithFile:@"playImg.png"];
        playButton2.position = ccp(screenSize.width/1.5, screenSize.height/2);
        [self addChild:playButton2 z:7];
        playButton2.visible = NO;
        */
        
        /*
        playWithFriendsImg = [CCSprite spriteWithFile:@"redSunSet.png"];
        playWithFriendsImg.position = ccp(screenSize.width/1.5, screenSize.height/2);
        [self addChild:playWithFriendsImg];
        playWithFriendsImg.visible = NO;
        */
        
        howToPlayImg = [CCSprite spriteWithSpriteFrameName:@"howToPlay5.png"];
        //howToPlayImg.position = ccp(screenSize.width/1.5, screenSize.height/5);
        howToPlayImg.position = ccp(screenSize.width/1.5, screenSize.height/3.2);
        [batchNode addChild:howToPlayImg z:7];
        
        howToPlaySelected = [CCSprite spriteWithSpriteFrameName:@"howToPlaySelected.png"];
        howToPlaySelected.position = ccp(screenSize.width/1.5, screenSize.height/3.2);
        howToPlaySelected.visible = NO;
        [batchNode addChild:howToPlaySelected];
        
        rankingsImg = [CCSprite spriteWithSpriteFrameName:@"rankings5.png"];
        //rankingsImg.position = ccp(screenSize.width/1.2, screenSize.height/10);
        rankingsImg.position = ccp(screenSize.width/1.2, screenSize.height/8);
        [batchNode addChild:rankingsImg z:7];
        
        rankingsSelected = [CCSprite spriteWithSpriteFrameName:@"rankSelected.png"];
        rankingsSelected.position = ccp(screenSize.width/1.2, screenSize.height/8);
        rankingsSelected.visible = NO;
        [batchNode addChild:rankingsSelected];
        
        CCSprite *redStarFish = [CCSprite spriteWithSpriteFrameName:@"RedStarfish.png"];
        redStarFish.position = ccp(screenSize.width/4, screenSize.height/5);
        [batchNode addChild:redStarFish z:3];
        
        CCSprite *brownShellFish = [CCSprite spriteWithSpriteFrameName:@"BrownShell.png"];
        brownShellFish.position = ccp(screenSize.width/1.7, screenSize.height/1.6);
        [batchNode addChild:brownShellFish z:3];
        
        CCSprite *blueSandDollarImg = [CCSprite spriteWithSpriteFrameName:@"blueSandDollar.png"];
        blueSandDollarImg.position =  ccp(screenSize.width/1.1, screenSize.height/1.4);
        [batchNode addChild:blueSandDollarImg z:3];
	}
	
	return self;
}

- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {
    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    if (CGRectContainsPoint(playWithFriendsLabel.boundingBox, touchLocation)) {
        playWithFriendsSelected.visible = YES;
        playAndPassSelected.visible = NO;
        howToPlaySelected.visible = NO;
        rankingsSelected.visible = NO;
        
    } else if (CGRectContainsPoint(playAndPassLabel.boundingBox, touchLocation)) {
        playWithFriendsSelected.visible = NO;
        playAndPassSelected.visible = YES;
        howToPlaySelected.visible = NO;
        rankingsSelected.visible = NO;
        
    } else if (CGRectContainsPoint(howToPlayImg.boundingBox, touchLocation)) {
        playWithFriendsSelected.visible = NO;
        playAndPassSelected.visible = NO;
        howToPlaySelected.visible = YES;
        rankingsSelected.visible = NO;
        
    } else if (CGRectContainsPoint(rankingsImg.boundingBox, touchLocation)) {
        playWithFriendsSelected.visible = NO;
        playAndPassSelected.visible = NO;
        howToPlaySelected.visible = NO;
        rankingsSelected.visible = YES;
    }
    
    return TRUE;
}

- (void) ccTouchEnded:(UITouch *) touch withEvent:(UIEvent *) event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    if (CGRectContainsPoint(playWithFriendsLabel.boundingBox, touchLocation)) {
        playWithFriendsSelected.visible = NO;
        [self showActionSheet];
    } else if (CGRectContainsPoint(playAndPassLabel.boundingBox, touchLocation)) {
        playAndPassSelected.visible = NO;
        [self displayPlayAndPass];
    } else if (CGRectContainsPoint(howToPlayImg.boundingBox, touchLocation)) {
        howToPlaySelected.visible = NO;
        //[self displaySceneSelection];
        [self displayHowToPlay];
    } else if (CGRectContainsPoint(rankingsImg.boundingBox, touchLocation)) {
        rankingsSelected.visible = NO;
        [self displayRanking];
    }
}

-(void) displayMainMenu {
	NSLog(@"display main menu");
    [[Dictionary sharedDictionary] loadDictionary];
   // [[AIDictionary sharedDictionary] loadDictionary];
}

-(void) displayHowToPlay {
	NSLog(@"display how to play");
    [[GameManager sharedGameManager] runSceneWithId:kHowToPlayScene];
}

-(void) displaySceneSelection {
	NSLog(@"display scene selection");
    [OFSocialNotificationApi setDelegate:self];
    [OFSocialNotificationApi sendWithPrepopulatedText:@"Let's play this cool game" originalMessage:@"Here is a link to download: http://itunes.apple.com/us/app/evernote/id406056744?mt=12" imageNamed:@"FB_Notification"];
}

-(void) displayRanking {
	NSLog(@"display ranking");
	//[OpenFeint launchDashboardWithHighscorePage:@"650204"];
	//[OpenFeint launchDashboard];
    [self displaySinglePlayer];
}

-(void) displayPlayAndPass {
	NSLog(@"display play and pass");
	[[GameManager sharedGameManager] runLoadingSceneWithTargetId:kHelloWorldScene];
}

-(void) displaySinglePlayer {
    CCLOG(@"display single player");
    [[GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];
}


-(void) displayMultiPlayer {
	CCLOG(@"display multi-player");
	[[GameManager sharedGameManager] closeGame];
	if ([OpenFeint isOnline]) {
        /*
		[OFFriendPickerController launchPickerWithDelegate:[[GameManager sharedGameManager] myOFDelegate] 
												promptText:@"Choose your victim" 
									 mustHaveApplicationId:@"243493"]; //243493
        */
        [OFFriendPickerController launchPickerWithDelegate:[[GameManager sharedGameManager] myOFDelegate] 
                                                promptText:@"Choose your victim"];
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

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
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

-(void) showAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Multiplayer Menu" 
                                                        message:@"Choose one of following options" 
                                                       delegate:self 
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Tell a friend about it", @"Play with a friend", nil];
    [alertView setNumberOfRows:3];
    [alertView show];
    [alertView release];
}

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0) {
        [self displaySceneSelection];
    } else if (buttonIndex == 1) {
        [self displayMultiPlayer];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([GameManager sharedGameManager].hasFriendsWithThisApp) {
        if (buttonIndex == 0) {
            CCLOG(@"Starting multiplayer");
            [self displayMultiPlayer];
        } else if (buttonIndex == 1) {
            [self displaySceneSelection];
        }
    } else {
        if (buttonIndex == 0) {
            CCLOG(@"No Friends has this application");
            [self displaySceneSelection];
        }
    }
}

- (void) showActionSheet {
	NSString *titleText = [NSString stringWithFormat:@"Choose one of following options"];
	UIActionSheet *popupQuery;
    
    CCLOG(@"In ShowAlertSheet");
    CCLOG(@"hasFriendsWithThisApp = %i", [GameManager sharedGameManager].hasFriendsWithThisApp);
    if ([GameManager sharedGameManager].hasFriendsWithThisApp) {
        popupQuery = [[UIActionSheet alloc] initWithTitle:titleText 
                                                 delegate:self 
                                        cancelButtonTitle:@"Cancel" 
                                   destructiveButtonTitle:nil 
                                        otherButtonTitles:@"Play with a friend", @"Tell a friend about it", nil];
    } else {
        popupQuery = [[UIActionSheet alloc] initWithTitle:titleText 
                                                 delegate:self 
                                        cancelButtonTitle:@"Cancel" 
                                   destructiveButtonTitle:nil 
                                        otherButtonTitles:@"Tell a friend about it", nil];
    }
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[popupQuery showInView:[CCDirector sharedDirector].openGLView];
	[popupQuery release];
}

-(void) getFriendsWithThisApp {
    OFUser *thisUser = [OpenFeint localUser];
    [thisUser getFriendsWithThisApplication];
}


-(void) dealloc {
	// doing some clean-up for multiplayer game.
	//CLOSE MP GAME
	//[self closeMultiPlayerGame];
	CCLOG(@"MainManuLayer dealloc called");
	[super dealloc];
}

@end
