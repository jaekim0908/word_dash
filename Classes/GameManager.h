//
//  GameManager.h
//  HundredSeconds
//
//  Created by Jae Kim on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "MyOFDelegate.h"

@interface GameManager : NSObject {
	BOOL isSoundsOn;
	NSString *_fileContents;
	MyOFDelegate *_myOFDelegate;
	NSString *_challengerId;
	NSString *_challengeeId;
	BOOL _isChallenger;
}

@property (readwrite) BOOL isSoundsOn;
@property (nonatomic, retain) NSString *_fileContents;
@property (nonatomic, retain) MyOFDelegate *myOFDelegate;
@property (nonatomic, retain) NSString *challengerId;
@property (nonatomic, retain) NSString *challengeeId;
@property (readwrite) BOOL isChallenger;

+(GameManager*) sharedGameManager;
-(void) runSceneWithId:(SceneTypes) sceneId;
-(void) runLoadingSceneWithTargetId:(SceneTypes) screenId;
-(NSString *) getFileContents;

@end
