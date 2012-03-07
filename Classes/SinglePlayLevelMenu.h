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
    CCSprite *beachBackground;

    
    CCMenuItem *level1Button;
    CCMenuItem *level2Button;
    CCMenuItem *level3Button;
    CCMenuItem *level4Button;
    CCMenuItem *level5Button;
    
    CCMenu *levelsMenu;
    
    CCSprite *backButton;
    
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
    
    CCSpriteBatchNode *levelsBatchNode;
    CCSpriteBatchNode *levels1BatchNode;

}

//@property (nonatomic, retain) CCSprite *beachBackground;

//@property (nonatomic, retain) CCMenuItem *level1Button;
//@property (nonatomic, retain) CCMenuItem *level2Button;
//@property (nonatomic, retain) CCMenuItem *level3Button;
//@property (nonatomic, retain) CCMenuItem *level4Button;
//@property (nonatomic, retain) CCMenuItem *level5Button;

//@property (nonatomic, retain) CCMenu *levelsMenu;

//@property (nonatomic, retain) CCSprite *backButton;

//@property (nonatomic, retain) CCSprite *level1BeatAIAward;
//@property (nonatomic, retain) CCSprite *level1TotalPointsAward;
//@property (nonatomic, retain) CCSprite *level1LongWordAward;

//@property (nonatomic, retain) CCSprite *level2BeatAIAward;
//@property (nonatomic, retain) CCSprite *level2TotalPointsAward;
//@property (nonatomic, retain) CCSprite *level2LongWordAward;

//@property (nonatomic, retain) CCSprite *level3BeatAIAward;
//@property (nonatomic, retain) CCSprite *level3TotalPointsAward;
//@property (nonatomic, retain) CCSprite *level3LongWordAward;

//@property (nonatomic, retain) CCSprite *level4BeatAIAward;
//@property (nonatomic, retain) CCSprite *level4TotalPointsAward;
//@property (nonatomic, retain) CCSprite *level4LongWordAward;

//@property (nonatomic, retain) CCSprite *level5BeatAIAward;
//@property (nonatomic, retain) CCSprite *level5TotalPointsAward;
//@property (nonatomic, retain) CCSprite *level5LongWordAward;


- (void) displayStars:(NSString *) levelName
           lockSprite:(CCMenuItem *) lockSprite
    BeatAIAwardSprite:(CCSprite *) beatAIAwardSprite
TotalPointAwardSprite:(CCSprite *) totalPointAwardSprite
  LongWordAwardSprite:(CCSprite *) longWordAwardSprite;
-(BOOL) level1ButtonPressed;
-(BOOL) level2ButtonPressed;
-(BOOL) level3ButtonPressed;
-(BOOL) level4ButtonPressed;
-(BOOL) level5ButtonPressed;


@end
