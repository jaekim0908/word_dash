//
//  HowToPlay.h
//  HundredSeconds
//
//  Created by Michael Ho on 6/9/11.
//  Copyright 2011 experiencesquad. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface HowToPlay : CCLayer {
    CCSpriteBatchNode *batchNode;
    CCLabelTTF *howToPlay3Label;
    CCLabelTTF *howToPlay7Label;
    CCLabelTTF *howToPlay8Label;
    CCLabelTTF *howToPlay9Label;
    CCLabelTTF *howToPlay10Label;
    CCLabelTTF *howToPlay11Label;
    CCLabelTTF *howToPlay12Label;
    CCLabelTTF *howToPlay13Label;
    CCLabelTTF *howToPlayLiteral;
    CCLabelTTF *nav1Label;
    CCLabelTTF *nav2Label;
    CCLabelTTF *nav3Label;
    CCSprite *nextPageButton;
    CCSprite *numTwoButton;
    CCSprite *numThreeButton;
    CCSprite *mainMenuButton;
    CCSprite *screenNavigatorButtons;
    CCSprite *mainMenuScreenShot;
    CCSprite *iPhoneScreenShot;
    CCSprite *gameScreenShotFlip;
    CCSprite *gameScreenShotSelect;
    CCSprite *gameScreenShotSubmit;
    CCSprite *gameScreenShotStars;
    CCSprite *gameScreenShotTripleTap;
    CCSprite *sandBackground;
    CCSprite *verticalLine;
    CCSprite *finger;
    CCSprite *finger2;
    int      nextPagePressedCount;
    
    
}

@property (nonatomic, retain) CCSpriteBatchNode *batchNode;
@property (nonatomic, retain) CCLabelTTF *howToPlay3Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay7Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay8Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay9Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay10Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay11Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay12Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay13Label;
@property (nonatomic, retain) CCLabelTTF *howToPlayLiteral;
@property (nonatomic, retain) CCLabelTTF *nav1Label;
@property (nonatomic, retain) CCLabelTTF *nav2Label;
@property (nonatomic, retain) CCLabelTTF *nav3Label;
@property (nonatomic, retain) CCSprite *nextPageButton;
@property (nonatomic, retain) CCSprite *numTwoButton;
@property (nonatomic, retain) CCSprite *numThreeButton;
@property (nonatomic, retain) CCSprite *mainMenuButton;
@property (nonatomic, retain) CCSprite *screenNavigatorButtons;
@property (nonatomic, retain) CCSprite *mainMenuScreenShot;
@property (nonatomic, retain) CCSprite *iPhoneScreenShot;
@property (nonatomic, retain) CCSprite *gameScreenShotFlip;
@property (nonatomic, retain) CCSprite *gameScreenShotSelect;
@property (nonatomic, retain) CCSprite *gameScreenShotSubmit;
@property (nonatomic, retain) CCSprite *gameScreenShotStar;
@property (nonatomic, retain) CCSprite *gameScreenShotTripleTap;
@property (nonatomic, retain) CCSprite *sandBackground;
@property (nonatomic, retain) CCSprite *verticalLine;
@property (nonatomic, retain) CCSprite *finger;
@property (nonatomic, retain) CCSprite *finger2;
@property (nonatomic, assign) int       nextPagePressedCount;

+(id) scene;
- (void) hideMenu1Items;
- (void) showMenu1Items;
- (void) hideMenu2Items;
- (void) showMenu2Items;
- (void) hideMenu3Items;
- (void) showMenu3Items;
- (void) hideMenu4Items;
- (void) showMenu4Items;
@end
