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
    kSinglePlayerScene,
	kMaxScene
} SceneTypes;

typedef enum {
	kInvalidStatus = 0,
	kGameNone,
	kGameStarted,
	kGameFinished
} GameStatus;