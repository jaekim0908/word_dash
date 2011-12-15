//
//  SinglePlayLevelMenu.h
//  HundredSeconds
//
//  Created by Michael Ho on 12/8/11.
//  Copyright (c) 2011 experiencesquad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@interface SinglePlayLevelMenu : CCLayer{
    CCSprite *level1Button;
    CCSprite *level2Button;
    CCSprite *level3Button;
    CCSprite *level4Button;
    CCSprite *level5Button;
    
    CCSprite *level1BeatAIAward;
    CCSprite *level1TotalPointsAward;
    CCSprite *level1LongWordAward;
    
}

@property (nonatomic, retain) CCSprite *level1Button;
@property (nonatomic, retain) CCSprite *level2Button;
@property (nonatomic, retain) CCSprite *level3Button;
@property (nonatomic, retain) CCSprite *level4Button;
@property (nonatomic, retain) CCSprite *level5Button;
@property (nonatomic, retain) CCSprite *level1BeatAIAward;
@property (nonatomic, retain) CCSprite *level1TotalPointsAward;
@property (nonatomic, retain) CCSprite *level1LongWordAward;


- (void) displayStars:(NSString *) levelName 
    BeatAIAwardSprite:(CCSprite *) beatAIAwardSprite
TotalPointAwardSprite:(CCSprite *) totalPointAwardSprite
  LongWordAwardSprite:(CCSprite *) longWordAwardSprite;


@end
