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
    CCLabelTTF *howToPlay1Label;
    CCLabelTTF *howToPlay2Label;
    CCLabelTTF *howToPlay3Label;
    CCLabelTTF *howToPlay4Label;
    CCLabelTTF *howToPlay5Label;
    CCLabelTTF *howToPlay6Label;
    CCLabelTTF *howToPlay7Label;
    CCLabelTTF *howToPlay8Label;
    CCLabelTTF *howToPlay9Label;
    CCLabelTTF *howToPlay10Label;
    CCLabelTTF *howToPlay11Label;
    CCLabelTTF *howToPlay12Label;
    CCLabelTTF *howToPlayLiteral;
    CCLabelTTF *nav1Label;
    CCLabelTTF *nav2Label;
    CCLabelTTF *nav3Label;
    CCSprite *numOneButton;
    CCSprite *numTwoButton;
    CCSprite *numThreeButton;
    CCSprite *mainMenuButton;
    CCSprite *screenNavigatorButtons;
    CCSprite *mainMenuScreenShot;
    CCSprite *iPhoneScreenShot;
    CCSprite *gameScreenShot;
    CCSprite *sandBackground;
    CCSprite *topRightElbow;
    CCSprite *topRightElbow2;
    CCSprite *topRightElbow3;
    CCSprite *bottomLeftElbow;
    CCSprite *bottomRightElbow;
    CCSprite *topLeftElbow;
    CCSprite *verticalLine;
    
    
}

@property (nonatomic, retain) CCSpriteBatchNode *batchNode;
@property (nonatomic, retain) CCLabelTTF *howToPlay1Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay2Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay3Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay4Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay5Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay6Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay7Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay8Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay9Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay10Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay11Label;
@property (nonatomic, retain) CCLabelTTF *howToPlay12Label;
@property (nonatomic, retain) CCLabelTTF *howToPlayLiteral;
@property (nonatomic, retain) CCLabelTTF *nav1Label;
@property (nonatomic, retain) CCLabelTTF *nav2Label;
@property (nonatomic, retain) CCLabelTTF *nav3Label;
@property (nonatomic, retain) CCSprite *numOneButton;
@property (nonatomic, retain) CCSprite *numTwoButton;
@property (nonatomic, retain) CCSprite *numThreeButton;
@property (nonatomic, retain) CCSprite *mainMenuButton;
@property (nonatomic, retain) CCSprite *screenNavigatorButtons;
@property (nonatomic, retain) CCSprite *mainMenuScreenShot;
@property (nonatomic, retain) CCSprite *iPhoneScreenShot;
@property (nonatomic, retain) CCSprite *gameScreenShot;
@property (nonatomic, retain) CCSprite *sandBackground;
@property (nonatomic, retain) CCSprite *topRightElbow;
@property (nonatomic, retain) CCSprite *topRightElbow2;
@property (nonatomic, retain) CCSprite *topRightElbow3;
@property (nonatomic, retain) CCSprite *bottomLeftElbow;
@property (nonatomic, retain) CCSprite *bottomRightElbow;
@property (nonatomic, retain) CCSprite *topLeftElbow;
@property (nonatomic, retain) CCSprite *verticalLine;

+(id) scene;
- (void) hideMenu1Items;
- (void) showMenu1Items;
- (void) hideMenu2Items;
- (void) showMenu2Items;
@end
