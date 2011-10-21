//
//  GameManager.m
//  HundredSeconds
//
//  Created by Jae Kim on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameManager.h"
#import "Constants.h"
#import "MainMenuScene.h"
#import "MultiPlayerScene.h"
#import "PlayAndPassScene.h"
#import "HelloWorld.h"
#import "LoadingScene.h"
#import "Multiplayer.h"
#import "SinglePlayer.h"
#import "OFMultiplayerService.h"
#import "OFUser.h"

@implementation GameManager

static GameManager* _sharedGameManager = nil;

@synthesize isSoundsOn;
@synthesize _fileContents;
@synthesize myOFDelegate = _myOFDelegate;
@synthesize challengerId = _challengerId;
@synthesize challengeeId = _challengeeId;
@synthesize isChallenger = _isChallenger;
@synthesize gameFinished = _gameFinished;
@synthesize gameStartedFromPushNotification = _gameStartedFromPushNotification;
@synthesize noTimeLeft = _noTimeLeft;
@synthesize gameStatus = _gameStatus;
@synthesize hasFriendsWithThisApp = _hasFriendsWithThisApp;

+(GameManager*) sharedGameManager {
	@synchronized([GameManager class]) {
		if (!_sharedGameManager) {
			[[self alloc] init];
			return _sharedGameManager;
		}
		return _sharedGameManager;
	}
}

+(id) alloc {
	@synchronized ([GameManager class]) {
		NSAssert(_sharedGameManager == nil,
				 @"Attempted to allocated a second instance of the Game Manager singleton");
		_sharedGameManager = [super alloc];
		return _sharedGameManager;
	}
	return nil;
}

-(id) init {
	self = [super init];
	if ((self = [super init])) {
		// Game Manager Initialized
		NSLog(@"Game Manager Singleton,, init");
		isSoundsOn = YES;
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"crab" ofType:@"txt"];
		NSError *error;
		// read everything from text
        // MCH -- no need to open the crab file since it is being opened by the Dictionary singleton
		//_sharedGameManager._fileContents = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error] retain];
		_sharedGameManager.myOFDelegate = [MyOFDelegate new];
		_sharedGameManager.isChallenger = NO;
		_sharedGameManager.gameFinished = YES;
		_sharedGameManager.gameStartedFromPushNotification = NO;
        _sharedGameManager.hasFriendsWithThisApp = NO;
		NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
								  [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight], OpenFeintSettingDashboardOrientation, 
								  [NSNumber numberWithBool:YES], OpenFeintSettingDisableUserGeneratedContent,
								  [NSNumber numberWithBool:YES], OpenFeintSettingEnablePushNotifications,
								  nil];
		//OFDelegatesContainer* delegates = [OFDelegatesContainer containerWithOpenFeintDelegate:_sharedGameManager.myOFDelegate];
        OFDelegatesContainer* delegates = [OFDelegatesContainer containerWithOpenFeintDelegate:_sharedGameManager.myOFDelegate 
                                                                          andChallengeDelegate:nil 
                                                                       andNotificationDelegate:_sharedGameManager.myOFDelegate];
        /***************** JAE's GAME ID *************
		[OpenFeint initializeWithProductKey:@"7hiF4dldDFHvfROrEgGDA"
								  andSecret:@"u3f6UaneEezk59d44hyH67wawNxnVVph0u16ASpm0s4"
							 andDisplayName:@"Battleship"
								andSettings:settings    // see OpenFeintSettings.h
							   andDelegates:delegates]; // see OFDelegatesContainer.h 
        ****************************/
        [OpenFeint initializeWithProductKey:@"KDSjH8AaN4DtiE9zklUw"
								  andSecret:@"KxhwylmFzbSs1ocrBHtuDSsOXDnTIahsMdiw19lv8"
							 andDisplayName:@"100 Seconds"
								andSettings:settings    // see OpenFeintSettings.h
							   andDelegates:delegates]; // see OFDelegatesContainer.h
		[OFUser setDelegate:_sharedGameManager.myOFDelegate];
		
		// Multi-Game Initialization
		[OFMultiplayerService setDelegate:_sharedGameManager.myOFDelegate];
		[OFMultiplayerService setSlotArraySize:10];
	}
	return self;
}

-(void) runSceneWithId:(SceneTypes)sceneId {
	id sceneToRun = nil;
	switch (sceneId) {
		case kMainMenuScene:
			CCLOG(@"Main Menu Scene");
			sceneToRun = [MainMenuScene node];
			break;
		case kLoadingScene:
			CCLOG(@"Loading Scene");
			break;
		case kIntroScene:
			CCLOG(@"Intro Scene");
			break;
		case kMutiPlayerScene:
			CCLOG(@"Multi Player Scene");
			sceneToRun = [Multiplayer scene];
			break;
		case kPlayAndPassScene:
			CCLOG(@"Play and Pass Scene");
			sceneToRun = [PlayAndPassScene node];
			break;
		case kHelloWorldScene:
			CCLOG(@"Play and Pass Scene");
			sceneToRun = [HelloWorld scene];
			break;
        case kSinglePlayerScene:
			CCLOG(@"SinglePlayer Scene");
			sceneToRun = [SinglePlayer scene];
			break;
            
		default:
			CCLOG(@"Unknown Id, cannot switch scene");
			break;
	}
	
	if ([[CCDirector sharedDirector] runningScene] == nil) {
		CCLOG(@"No running scene");
		CCLOG(@"sceneToRun = %@", sceneToRun);
		[[CCDirector sharedDirector] runWithScene:sceneToRun];
	} else {
		[[CCDirector sharedDirector] replaceScene:sceneToRun];
	}
}

-(void) runLoadingSceneWithTargetId:(SceneTypes) sceneId {
	id sceneToRun = [LoadingScene sceneWithTargetScene:sceneId];
	
	if ([[CCDirector sharedDirector] runningScene] == nil) {
		CCLOG(@"No running scene");
		CCLOG(@"sceneToRun = %@", sceneToRun);
		[[CCDirector sharedDirector] runWithScene:sceneToRun];
	} else {
		[[CCDirector sharedDirector] replaceScene:sceneToRun];
	}
}

-(NSString *) getFileContents {
	if (_sharedGameManager) {
		return _sharedGameManager._fileContents;
	}
	
	return nil;
}

-(void) closeGame {
	OFMultiplayerGame *game = [OFMultiplayerService getSlot:0];
	[game closeGame];
	_sharedGameManager.gameFinished = YES;
}

-(void) sendChallengeToUserId:(NSString *) userId {
	OFMultiplayerGame* game = [OFMultiplayerService getSlot:0];
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@"CONFIG STUFF", OFMultiplayer::LOBBY_OPTION_CONFIG,
							 [NSNumber numberWithUnsignedInt:5*60], OFMultiplayer::LOBBY_OPTION_TURN_TIME,
							 [NSArray arrayWithObject:userId], OFMultiplayer::LOBBY_OPTION_CHALLENGE_OF_IDS,
							 nil];
	[game createGame:@"HundredSeconds" withOptions:options];
	_sharedGameManager.isChallenger = YES;
	[OFUser getUser:userId];	
}

-(void) saveToUserDefaultsForKey:(NSString*) key Value:(NSString *) val {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	if (standardUserDefaults) {
		[standardUserDefaults setObject:val forKey:key];
		[standardUserDefaults synchronize];
	}
}

-(NSString*)retrieveFromUserDefaultsForKey:(NSString *) key {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
	
	if (standardUserDefaults) 
		val = [standardUserDefaults objectForKey:key];
	
	return val;
}

@end
