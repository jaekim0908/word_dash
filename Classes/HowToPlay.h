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
    CCLabelTTF *howToPlay3bLabel;
    CCLabelTTF *howToPlay7Label;
    CCLabelTTF *howToPlay8Label;
    CCLabelTTF *howToPlay9Label;
    CCLabelTTF *howToPlay10Label;
    CCLabelTTF *howToPlay11Label;
    CCLabelTTF *howToPlay12Label;
    CCLabelTTF *howToPlay13Label;
    CCLabelTTF *howToPlayLiteral;
    CCSprite *nextPageButton;
    CCSprite *iPhoneScreenShot;
    CCSprite *gameScreenShotFlip;
    CCSprite *gameScreenShotSelect;
    CCSprite *gameScreenShotSubmit;
    CCSprite *gameScreenShotStars;
    CCSprite *gameScreenShotTripleTap;
    CCSprite *sandBackground;
    CCSprite *finger;
    CCSprite *finger2;
    int      nextPagePressedCount;
}





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
