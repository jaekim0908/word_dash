//
//  Constants.h
//  HundredSeconds
//
//  Created by Jae Kim on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	kInvalidScene = 0,
	kMainMenuScene,
	kLoadingScene,
	kIntroScene,
	kMutiPlayerScene,
	kPlayAndPassScene,
	kHelloWorldScene,
    kHowToPlayScene,
    kSinglePlayerScene,
    kSinglePlayHistoryScene,
    kSinglePlayLevelMenu,
    kScoreSummaryScene,
    kWordSummaryScene,
	kMaxScene
} SceneTypes;

typedef enum {
	kInvalidStatus = 0,
	kGameNone,
	kGameStarted,
	kGameFinished
} GameStatus;

/****
typedef enum {
	kLevel1 = 1,
	kLevel2,
	kLevel3,
	kLevel4,
    kLevel6,
	kLevel7,
	kLevel8,
	kLevel9,
    kLevel10
} SinglePlayerGameLevels;
******/

typedef enum {
	kSinglePlayer = 0,
	kPlayAndPass,
	kMultiplayer
} GameMode;