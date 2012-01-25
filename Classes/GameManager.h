//
//  GameManager.h
//  HundredSeconds
//
//  Created by Jae Kim on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface GameManager : NSObject {
	BOOL isSoundsOn;
	NSString *_fileContents;
	//MyOFDelegate *_myOFDelegate;
	NSString *_challengerId;
	NSString *_challengeeId;
	BOOL _isChallenger;
	BOOL _gameFinished;
	BOOL _gameStartedFromPushNotification;
    BOOL _noTimeLeft;
    BOOL _hasFriendsWithThisApp;
	GameStatus _gameStatus;
    NSString *_gameUUID;
    int _singlePlayerLevel;
    int _singlePlayerBatchSize;
    
    NSMutableDictionary *_gameLevelDictionary;
    NSString *_gameLevelPListPath;
    
    NSString *_player1Score;
    NSString *_player2Score;
    NSMutableArray *_player1Words;
    NSMutableArray *_player2Words;
    
    GameMode _gameMode;
    int      _aiMaxWaitTime;
    
    SceneTypes _runningSceneID;
}

@property (readwrite) BOOL isSoundsOn;
@property (nonatomic, retain) NSString *_fileContents;
//@property (nonatomic, retain) MyOFDelegate *myOFDelegate;
@property (nonatomic, retain) NSString *challengerId;
@property (nonatomic, retain) NSString *challengeeId;
@property (readwrite) BOOL isChallenger;
@property (readwrite) BOOL gameFinished;
@property (readwrite) BOOL gameStartedFromPushNotification;
@property (readwrite) BOOL noTimeLeft;
@property (readwrite) BOOL hasFriendsWithThisApp;
@property (readwrite) GameStatus gameStatus;
@property (nonatomic, retain) NSString *gameUUID;
@property (readwrite) int singlePlayerLevel;
@property (readwrite) int singlePlayerBatchSize;
@property (nonatomic, retain) NSString *gameLevelPListPath;
@property (nonatomic, retain) NSMutableDictionary *gameLevelDictionary;
@property (nonatomic, retain) NSString *player1Score;
@property (nonatomic, retain) NSString *player2Score;
@property (nonatomic, retain) NSMutableArray *player1Words;
@property (nonatomic, retain) NSMutableArray *player2Words;
@property (readwrite) GameMode gameMode;
@property (readwrite) int aiMaxWaitTime;
@property (readwrite) SceneTypes runningSceneID;

+(GameManager*) sharedGameManager;
-(void) runSceneWithId:(SceneTypes) sceneId;
-(void) runLoadingSceneWithTargetId:(SceneTypes) screenId;
-(NSString *) getFileContents;
//-(void) closeGame;
//-(void) sendChallengeToUserId:(NSString *) userId;
-(void) saveToUserDefaultsForKey:(NSString*) key Value:(NSString *) val;
-(NSString*)retrieveFromUserDefaultsForKey:(NSString *) key;
-(NSMutableDictionary *) getGameLevelDictionary;
-(NSString *) getGameLevelPListPath;


@end
