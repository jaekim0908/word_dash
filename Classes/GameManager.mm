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
#import "Multiplayer.h"
#import "PlayAndPass.h"
#import "HelloWorld.h"
#import "LoadingScene.h"
#import "HowToPlay.h"
#import "SinglePlayer.h"
#import "SinglePlayGameHistory.h"
#import "SinglePlayLevelMenu.h"
#import "Parse/Parse.h"
#import "ScoreSummary.h"
#import "ResultsLayer.h"


@implementation GameManager

static GameManager* _sharedGameManager = nil;

@synthesize isSoundsOn;
@synthesize _fileContents;
//@synthesize myOFDelegate = _myOFDelegate;
@synthesize challengerId = _challengerId;
@synthesize challengeeId = _challengeeId;
@synthesize isChallenger = _isChallenger;
@synthesize gameFinished = _gameFinished;
@synthesize gameStartedFromPushNotification = _gameStartedFromPushNotification;
@synthesize noTimeLeft = _noTimeLeft;
@synthesize gameStatus = _gameStatus;
@synthesize hasFriendsWithThisApp = _hasFriendsWithThisApp;
@synthesize gameUUID = _gameUUID;
@synthesize singlePlayerLevel = _singlePlayerLevel;
@synthesize singlePlayerBatchSize = _singlePlayerBatchSize;
@synthesize gameLevelPListPath = _gameLevelPListPath;
@synthesize gameLevelDictionary = _gameLevelDictionary;
@synthesize player1Score = _player1Score;
@synthesize player2Score = _player2Score;
@synthesize player1Words = _player1Words;
@synthesize player2Words = _player2Words;
@synthesize gameMode = _gameMode;
@synthesize aiMaxWaitTime = _aiMaxWaitTime;
@synthesize runningSceneID = _runningSceneID;



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
	if ((self = [super init])) {
		// Game Manager Initialized
		NSLog(@"Game Manager Singleton,, init");
		isSoundsOn = YES;

		_sharedGameManager.isChallenger = NO;
		_sharedGameManager.gameFinished = YES;
		_sharedGameManager.gameStartedFromPushNotification = NO;
        _sharedGameManager.hasFriendsWithThisApp = NO;
        
        // Application ID: VNnw2o5S2qF4YpZa7nLMcXl9uINh5kuMRnZfvHP6
        // Client Key: aXBUJWuPRRrK8d2pvyDqhfFp1dgArAAlLzZcovkE
        [Parse setApplicationId:@"VNnw2o5S2qF4YpZa7nLMcXl9uINh5kuMRnZfvHP6" clientKey:@"aXBUJWuPRRrK8d2pvyDqhfFp1dgArAAlLzZcovkE"];
        _sharedGameManager.gameUUID = [self retrieveFromUserDefaultsForKey:@"gameUUID"];
        if (!_sharedGameManager.gameUUID) {
            CFUUIDRef theUUID = CFUUIDCreate(NULL);
            CFStringRef stringRef = CFUUIDCreateString(NULL, theUUID);
            CFRelease(theUUID);
            _sharedGameManager.gameUUID = [NSString stringWithString:(NSString *)stringRef];
            CFRelease(stringRef);
            [self saveToUserDefaultsForKey:@"gameUUID" Value: _sharedGameManager.gameUUID];
        }
        
        
        //READ gameLevel.plist THAT CONTAINS THE SINGLE PLAYER AWARDS
        //COPY THE PLIST TO THE DOCUMENTS DIRECTORY IN ORDER TO READ/WRITE TO THE FILE
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        //STORE PATH IN GAME MANAGER
        _sharedGameManager.gameLevelPListPath = [documentsDirectory stringByAppendingPathComponent:@"gameLevel.plist"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:_gameLevelPListPath]) {
            NSString *bundle =[[NSBundle mainBundle] pathForResource:@"gameLevel" ofType:@"plist"];
            [fileManager copyItemAtPath:bundle toPath:_gameLevelPListPath error:&error];
        }
        //READ DATA FROM THE PLIST
        //DISCUSS WITH JAE -- WHEN DO WE CREATE PROPERTIES AND WHEN DO WE CREATE OR OWN GETTERS
        //WHAT ABOUT USING RETAIN????????????
        _sharedGameManager.gameLevelDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:_sharedGameManager.gameLevelPListPath];
        
        // Authenticate Local User
        [[GCHelper sharedInstance] authenticateLocalUser];
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
			sceneToRun = [PlayAndPass node];
			break;
		case kHelloWorldScene:
			CCLOG(@"Play and Pass Scene");
			sceneToRun = [HelloWorld scene];
			break;
        case kHowToPlayScene:
			NSLog(@"How To Play Scene");
			sceneToRun = [HowToPlay scene];
			break;
        case kSinglePlayerScene:
			CCLOG(@"SinglePlayer Scene");
			sceneToRun = [SinglePlayer scene];
			break;
            
        case kSinglePlayHistoryScene:
            CCLOG(@"SinglePlayGameHistory Scene");
            sceneToRun = [SinglePlayGameHistory scene];
            break;
            
        case kSinglePlayLevelMenu:
            CCLOG(@"SinglePlayLevelMenu Scene");
            sceneToRun = [SinglePlayLevelMenu scene];
            break;

        case kScoreSummaryScene:
            CCLOG(@"ScoreSummary Scene");
            sceneToRun = [ScoreSummary scene];
            break;    

        case kWordSummaryScene:
            CCLOG(@"WordSummary Scene");
            sceneToRun = [ResultsLayer scene];
            break;    

		default:
			CCLOG(@"Unknown Id, cannot switch scene");
			break;
	}
    
    self.runningSceneID = sceneId;
	
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
    self.runningSceneID = sceneId;
	
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

-(NSMutableDictionary *) getGameLevelDictionary
{
    return _sharedGameManager.gameLevelDictionary;
    
}

-(NSString *) getGameLevelPListPath
{
    return _sharedGameManager.gameLevelPListPath;
    
}

@end
