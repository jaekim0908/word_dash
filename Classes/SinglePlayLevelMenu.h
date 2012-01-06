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
    CCSprite *sandBackground;
    CCSprite *plateBackground;
    
    CCSprite *level1Button;
    CCSprite *level2Button;
    CCSprite *level3Button;
    CCSprite *level4Button;
    CCSprite *level5Button;
    
    CCLabelTTF *level1Literal;
    CCLabelTTF *level2Literal;
    CCLabelTTF *level3Literal;
    CCLabelTTF *level4Literal;
    CCLabelTTF *level5Literal;
    
    CCSprite *level1BeatAIAward;
    CCSprite *level1TotalPointsAward;
    CCSprite *level1LongWordAward;

    CCSprite *level2BeatAIAward;
    CCSprite *level2TotalPointsAward;
    CCSprite *level2LongWordAward;

    CCSprite *level3BeatAIAward;
    CCSprite *level3TotalPointsAward;
    CCSprite *level3LongWordAward;

    CCSprite *level4BeatAIAward;
    CCSprite *level4TotalPointsAward;
    CCSprite *level4LongWordAward;

    CCSprite *level5BeatAIAward;
    CCSprite *level5TotalPointsAward;
    CCSprite *level5LongWordAward;

}

@property (nonatomic, retain) CCSprite *sandBackground;
@property (nonatomic, retain) CCSprite *plateBackground;

@property (nonatomic, retain) CCSprite *level1Button;
@property (nonatomic, retain) CCSprite *level2Button;
@property (nonatomic, retain) CCSprite *level3Button;
@property (nonatomic, retain) CCSprite *level4Button;
@property (nonatomic, retain) CCSprite *level5Button;

@property (nonatomic, retain) CCLabelTTF *level1Literal;
@property (nonatomic, retain) CCLabelTTF *level2Literal;
@property (nonatomic, retain) CCLabelTTF *level3Literal;
@property (nonatomic, retain) CCLabelTTF *level4Literal;
@property (nonatomic, retain) CCLabelTTF *level5Literal;

@property (nonatomic, retain) CCSprite *level1BeatAIAward;
@property (nonatomic, retain) CCSprite *level1TotalPointsAward;
@property (nonatomic, retain) CCSprite *level1LongWordAward;

@property (nonatomic, retain) CCSprite *level2BeatAIAward;
@property (nonatomic, retain) CCSprite *level2TotalPointsAward;
@property (nonatomic, retain) CCSprite *level2LongWordAward;

@property (nonatomic, retain) CCSprite *level3BeatAIAward;
@property (nonatomic, retain) CCSprite *level3TotalPointsAward;
@property (nonatomic, retain) CCSprite *level3LongWordAward;

@property (nonatomic, retain) CCSprite *level4BeatAIAward;
@property (nonatomic, retain) CCSprite *level4TotalPointsAward;
@property (nonatomic, retain) CCSprite *level4LongWordAward;

@property (nonatomic, retain) CCSprite *level5BeatAIAward;
@property (nonatomic, retain) CCSprite *level5TotalPointsAward;
@property (nonatomic, retain) CCSprite *level5LongWordAward;



- (void) displayStars:(NSString *) levelName 
    BeatAIAwardSprite:(CCSprite *) beatAIAwardSprite
TotalPointAwardSprite:(CCSprite *) totalPointAwardSprite
  LongWordAwardSprite:(CCSprite *) longWordAwardSprite;


@end
