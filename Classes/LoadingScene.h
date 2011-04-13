//
//  LoadingScene.h
//  HundredSeconds
//
//  Created by Jae Kim on 3/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@interface LoadingScene : CCScene {

	SceneTypes _targetScene;
}

+(id) sceneWithTargetScene:(SceneTypes) targetScene;
-(id) initWithTargetScene:(SceneTypes) targetScene;

@end
