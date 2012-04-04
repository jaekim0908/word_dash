//
//  MainMenuLayer.m
//  HundredSeconds
//
//  Created by Jae Kim on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "Constants.h"
#import "GameManager.h"
#import "Dictionary.h"
#import "DialogLayer.h"
#import "ChallengeRequestDialog.h"
#import "CCAlertView.h"
#import "AIDictionary.h"
#import "HowToPlay.h"

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

@synthesize soundOnButton;
@synthesize soundOffButton;

-(id) init {
	NSLog(@"MainMenuLayer init called");
	if ((self = [super init])) {
		self.isTouchEnabled = YES;
        [GameManager sharedGameManager].isChallenger = NO;
        [GameManager sharedGameManager].hasFriendsWithThisApp = NO;
		[self displayMainMenu];// Load Dictionary
		[GameManager sharedGameManager].gameStatus = kGameNone;
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
        
        // Retina Display Support
        if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mainMenuImageAssets-hd.plist"];
            batchNode = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"mainMenuImageAssets-hd.png"]];
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mainMenuImageAssets.plist"];
            batchNode = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"mainMenuImageAssets.png"]];
        }
		[self addChild:batchNode z:10];
        
        CCSprite *titleImg = [CCSprite spriteWithSpriteFrameName:@"wordanista.png"];
        titleImg.position = ccp(screenSize.width/2, screenSize.height/1.1);
        [batchNode addChild:titleImg z:5];
        
        CCSprite *backgroundImg = [CCSprite spriteWithFile:@"whiteSandBg.png"];
        backgroundImg.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:backgroundImg];
        
        CCMenuItem *singlePlayerMenuItem = [CCMenuItemImage 
                                            itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"singlePlayerLabel.png"] 
                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"singlePlayerLabelSelected.png"] 
                                            target:self
                                            selector:@selector(displaySinglePlayer)];
        singlePlayerMenuItem.position = ccp(135, 240);
        
        CCMenuItem *playAndPassMenuItem = [CCMenuItemImage 
                                            itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"playAndPassLable5.png"] 
                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"playAndPassSelected.png"] 
                                            target:self
                                            selector:@selector(displayPlayAndPass)];
        playAndPassMenuItem.position = ccp(150, 190);
        
        CCMenuItem *playWithFriendsMenuItem = [CCMenuItemImage 
                                               itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"playWithFriendsLabel5.png"] 
                                               selectedSprite:[CCSprite spriteWithSpriteFrameName:@"playWithFriendsSelected.png"] 
                                               target:self
                                               selector:@selector(displayMultiPlayer)];
        playWithFriendsMenuItem.position = ccp(190, 140);
        
        CCMenuItem *howToPlayMenuItem = [CCMenuItemImage 
                                               itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"howToPlay5.png"] 
                                               selectedSprite:[CCSprite spriteWithSpriteFrameName:@"howToPlaySelected.png"] 
                                               target:self
                                               selector:@selector(displayHowToPlay)];
        howToPlayMenuItem.position = ccp(330, 90);
        
        CCMenuItem *statsMenuItem = [CCMenuItemImage 
                                         itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"GameHistory.png"] 
                                         selectedSprite:[CCSprite spriteWithSpriteFrameName:@"GameHistorySelected.png"] 
                                         target:self
                                         selector:@selector(displayRanking)];
        statsMenuItem.position = ccp(315, 40);
        
        CCMenu *starMenu = [CCMenu menuWithItems:singlePlayerMenuItem, playAndPassMenuItem, playWithFriendsMenuItem, howToPlayMenuItem, statsMenuItem, nil];
        starMenu.position = CGPointZero;
        [self addChild:starMenu];
        
        CCSprite *redStarFish = [CCSprite spriteWithSpriteFrameName:@"RedStarfish.png"];
        redStarFish.position = ccp(screenSize.width/4, screenSize.height/5);
        //MCH
        //redStarFish.visible=NO;
        [batchNode addChild:redStarFish z:3];
        
        CCSprite *brownShellFish = [CCSprite spriteWithSpriteFrameName:@"BrownShell.png"];
        brownShellFish.position = ccp(screenSize.width/1.4, screenSize.height/1.6);
        [batchNode addChild:brownShellFish z:3];
        
        CCSprite *blueSandDollarImg = [CCSprite spriteWithSpriteFrameName:@"blueSandDollar.png"];
        blueSandDollarImg.position =  ccp(400, 140);
        [batchNode addChild:blueSandDollarImg z:3];
        

        self.soundOnButton = [CCSprite spriteWithFile:@"Music-On_Button-small.png"];
        self.soundOnButton.position = ccp(30,30);
        self.soundOnButton.visible=NO;
        [self addChild:self.soundOnButton z:12];
        
        self.soundOffButton = [CCSprite spriteWithFile:@"Music-Off_Button002-small.png"];
        self.soundOffButton.position = ccp(30,30);
        self.soundOffButton.visible=NO;
        [self addChild:self.soundOffButton z:12];
        
        NSString *currentMuteSetting = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"currentMuteSetting"];
        
        if (currentMuteSetting == nil){
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"currentMuteSetting" Value:@"FALSE"];
            self.soundOnButton.visible=YES;
            [[[GameManager sharedGameManager] soundEngine] setMute:FALSE];
        }
        else if ([currentMuteSetting isEqualToString:@"FALSE"]){
            self.soundOnButton.visible=YES;
            [[[GameManager sharedGameManager] soundEngine] setMute:FALSE];
        }
        else{
            self.soundOffButton.visible=YES;
            [[[GameManager sharedGameManager] soundEngine] setMute:TRUE];
        }

        
        
	}
	
	return self;
}

- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(self.soundOnButton.boundingBox, touchLocation)) {
        
        NSString *currentMuteSetting = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"currentMuteSetting"];
        
        if ([currentMuteSetting isEqualToString:@"FALSE"]) {
            [[[GameManager sharedGameManager] soundEngine] setMute:TRUE];
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"currentMuteSetting" Value:@"TRUE"];
            self.soundOffButton.visible=YES;
            self.soundOnButton.visible=NO;
        }
        else{
            [[[GameManager sharedGameManager] soundEngine] setMute:FALSE];
            [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"currentMuteSetting" Value:@"FALSE"];
            self.soundOnButton.visible=YES;
            self.soundOffButton.visible=NO;
        }

    } 
    
    return TRUE;
}

- (void) ccTouchEnded:(UITouch *) touch withEvent:(UIEvent *) event {
}

-(void) displayMainMenu {
	NSLog(@"display main menu");
    [[Dictionary sharedDictionary] loadDictionary];

}

-(void) displayHowToPlay {
	NSLog(@"display how to play");
    [[CCDirector sharedDirector] pushScene:[HowToPlay scene]];
}

-(void) displaySceneSelection {
	NSLog(@"display scene selection");
}

-(void) displayRanking {
    //MCH[[GameManager sharedGameManager] runSceneWithId:kScoreSummaryScene];
    NSURL *url = [NSURL URLWithString:@"http://www.facebook.com/MangosteenStudios"];
    [[UIApplication sharedApplication] openURL:url];
    
    /*
    NSString *twitterURL = @"http://twitter.com/mangosteenSD";
    NSURL *url = [[[NSURL alloc] initWithString:twitterURL] autorelease];
    [[UIApplication sharedApplication] openURL:url];
    */
}

-(void) displayPlayAndPass {
	NSLog(@"display play and pass");
    
    [ [GameManager sharedGameManager] setGameMode:kPlayAndPass];
	//[[GameManager sharedGameManager] runLoadingSceneWithTargetId:kHelloWorldScene];
    //DETERMINE IF FIRST TIME PLAYING
    NSString *firstTimePlayFlag = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"firstTimePlaying"];
    
    if(!firstTimePlayFlag)
    {
        CCLOG(@"firstTimePlayFlag is null, this is the first time the game has been played on this device!");
        [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"firstTimePlaying" Value:@"FALSE"];
        
        //[[GameManager sharedGameManager] runSceneWithId:kHelloWorldScene];
        [[GameManager sharedGameManager] runLoadingSceneWithTargetId:kPlayAndPassScene];
        [[CCDirector sharedDirector] pushScene:[HowToPlay scene]];
        
        
    }
    else{
        //[self displayPlayAndPass];
        [[GameManager sharedGameManager] runLoadingSceneWithTargetId:kPlayAndPassScene];
    }       

    //[[GameManager sharedGameManager] runLoadingSceneWithTargetId:kPlayAndPassScene];
}

-(void) displaySinglePlayer {
    CCLOG(@"display single player");
    [ [GameManager sharedGameManager] setGameMode:kSinglePlayer];
    //[[GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];
    //DETERMINE IF FIRST TIME PLAYING
    NSString *firstTimePlayFlag = [[GameManager sharedGameManager] retrieveFromUserDefaultsForKey:@"firstTimePlaying"];
    
    if(!firstTimePlayFlag)
    {
        CCLOG(@"firstTimePlayFlag is null, this is the first time the game has been played on this device!");
        [[GameManager sharedGameManager] saveToUserDefaultsForKey:@"firstTimePlaying" Value:@"FALSE"];
        
        //[[GameManager sharedGameManager] runSceneWithId:kHelloWorldScene];
        [[GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayLevelMenu];
        [[CCDirector sharedDirector] pushScene:[HowToPlay scene]];
        
    }
    else{
        //[self displayPlayAndPass];
        [[GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayLevelMenu];
    }       

    //[[GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayLevelMenu];
}

-(void) displayMultiPlayer {
    CCLOG(@"display multi player with GC");
    [ [GameManager sharedGameManager] setGameMode:kMultiplayer];
    [[GameManager sharedGameManager] runLoadingSceneWithTargetId:kMutiPlayerScene];
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
        //[self displayMultiPlayer];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([GameManager sharedGameManager].hasFriendsWithThisApp) {
        if (buttonIndex == 0) {
            CCLOG(@"Starting multiplayer");
            //[self displayMultiPlayer];
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
    /*
    OFUser *thisUser = [OpenFeint localUser];
    [thisUser getFriendsWithThisApplication];
    */
}


-(void) dealloc {
	// doing some clean-up for multiplayer game.
	//CLOSE MP GAME
	//[self closeMultiPlayerGame];
	CCLOG(@"MainManuLayer dealloc called");
	[super dealloc];
}

@end
