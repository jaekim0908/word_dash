//
//  HowToPlay.m
//  HundredSeconds
//
//  Created by Michael Ho on 6/9/11.
//  Copyright 2011 experiencesquad. All rights reserved.
//

#import "HowToPlay.h"
#import "GameManager.h"


@implementation HowToPlay

@synthesize howToPlay1Label;
@synthesize howToPlay2Label;
@synthesize howToPlay3Label;
@synthesize howToPlay4Label;
@synthesize howToPlay5Label;
@synthesize howToPlay6Label;
@synthesize howToPlay7Label;
@synthesize howToPlay8Label;
@synthesize howToPlay9Label;
@synthesize howToPlay10Label;
@synthesize howToPlay11Label;
@synthesize howToPlay12Label;
@synthesize nav1Label;
@synthesize nav2Label;
@synthesize nav3Label;
@synthesize numOneButton;
@synthesize numTwoButton;
@synthesize numThreeButton;
@synthesize mainMenuButton;
@synthesize mainMenuScreenShot;
@synthesize gameScreenShot;
@synthesize sandBackground;
@synthesize howToPlayLiteral;
@synthesize iPhoneScreenShot;
@synthesize topRightElbow;
@synthesize topRightElbow2;
@synthesize topRightElbow3;
@synthesize bottomLeftElbow;
@synthesize bottomRightElbow;
@synthesize topLeftElbow;
@synthesize verticalLine;
@synthesize screenNavigatorButtons;
@synthesize batchNode;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HowToPlay *layer = [HowToPlay node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
    
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        
        self.isTouchEnabled = YES;
        CCLOG(@"Inside How To Play init.");
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"howToPlay_layer_3g.plist"];
        batchNode = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"howToPlay_layer_3g.png"]];    
        
        //howToPlayLiteral = [CCLabelTTF labelWithString:@"How To Play" fontName:@"Verdana-Bold" fontSize:18];
        howToPlayLiteral = [CCLabelTTF labelWithString:@"How To Play" fontName:@"MarkerFelt-Thin" fontSize:36];
		howToPlayLiteral.color = ccc3(240, 240, 240);
		howToPlayLiteral.position = ccp(10, 270);
        howToPlayLiteral.anchorPoint = ccp(0,0);
		[self addChild:howToPlayLiteral];
        
        howToPlay1Label = [CCLabelTTF labelWithString:@"Reveal 1 letter" fontName:@"Verdana" fontSize:12];
		howToPlay1Label.color = ccc3(255, 255, 255);
		howToPlay1Label.position = ccp(16, 250);
        howToPlay1Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay1Label];
        
        howToPlay2Label = [CCLabelTTF labelWithString:@"per turn" fontName:@"Verdana" fontSize:12];
		howToPlay2Label.color = ccc3(255, 255, 255);
		howToPlay2Label.position = ccp(23, 238);
        howToPlay2Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay2Label];

        
        //sandBackground = [CCSprite spriteWithFile:@"Sand-480-320.png"];
        //sandBackground = [CCSprite spriteWithFile:@"blacksand_hawaii_480-360.jpg"];
        sandBackground = [CCSprite spriteWithFile:@"black-background-2_502-323.png"];
        sandBackground.position = ccp(240, 160);
        [self addChild:sandBackground z:-20];

        iPhoneScreenShot = [CCSprite spriteWithFile:@"iphone-320-201.png"];
        iPhoneScreenShot.position = ccp(240, 160);
        [self addChild:iPhoneScreenShot];
        
        gameScreenShot = [CCSprite spriteWithFile:@"game_screen-white-190-127.png"];
        gameScreenShot.position = ccp(240, 160);
        [self addChild:gameScreenShot];
        
        topRightElbow = [CCSprite spriteWithFile:@"top-right-elbow-white.png"];
        topRightElbow.position = ccp(163, 223);
        [self addChild:topRightElbow];
/*******
        verticalLine = [CCSprite spriteWithFile:@"vertical-line.png"];
        verticalLine.position = ccp(227, 75);
        [self addChild:verticalLine];
 *******/
        
        bottomLeftElbow = [CCSprite spriteWithFile:@"bottom-left-elbow-white.png"];
        bottomLeftElbow.position = ccp(227, 72);
        [self addChild:bottomLeftElbow];
        
        howToPlay3Label = [CCLabelTTF labelWithString:@"Score by creating words " fontName:@"Verdana" fontSize:12];
		howToPlay3Label.color = ccc3(255, 255, 255);
		howToPlay3Label.position = ccp(243, 64);
        howToPlay3Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay3Label];
        
        howToPlay4Label = [CCLabelTTF labelWithString:@"with 3 or more letters" fontName:@"Verdana" fontSize:12];
		howToPlay4Label.color = ccc3(255, 255, 255);
		howToPlay4Label.position = ccp(248, 52);
        howToPlay4Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay4Label];
        
        
        
        bottomRightElbow = [CCSprite spriteWithFile:@"bottom-right-elbow-white.png"];
        bottomRightElbow.position = ccp(172, 78);
        [self addChild:bottomRightElbow];

        
        howToPlay5Label = [CCLabelTTF labelWithString:@"End turn and" fontName:@"Verdana" fontSize:12];
		howToPlay5Label.color = ccc3(255, 255, 255);
		howToPlay5Label.position = ccp(52, 49);
        howToPlay5Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay5Label];
        
        howToPlay6Label = [CCLabelTTF labelWithString:@"stop timer" fontName:@"Verdana" fontSize:12];
		howToPlay6Label.color = ccc3(255, 255, 255);
		howToPlay6Label.position = ccp(59, 37);
        howToPlay6Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay6Label];

        
        //MCH - DELETE SOON!!!!!!!!
        screenNavigatorButtons = [CCSprite spriteWithFile:@"HowToPlayMenu-450-338.png"];
        screenNavigatorButtons.position = ccp(280, 280);
        screenNavigatorButtons.anchorPoint = ccp(0,0);
        screenNavigatorButtons.visible = NO;
        [self addChild:screenNavigatorButtons];
        
        mainMenuButton = [CCSprite spriteWithFile:@"main_menu_btn-150-125.png"];
        mainMenuButton.position = ccp(412, 255);
        mainMenuButton.anchorPoint = ccp(0,0);
        [self addChild:mainMenuButton];

        
        numThreeButton = [CCSprite spriteWithFile:@"blueSandDollar.png"];
        numThreeButton.position = ccp(310, 220);
        numThreeButton.anchorPoint = ccp(0,0);
        [self addChild:numThreeButton];
        
        
        numTwoButton = [CCSprite spriteWithFile:@"blueSandDollar.png"];
        numTwoButton.position = ccp(250, 220);
        numTwoButton.anchorPoint = ccp(0,0);
        [self addChild:numTwoButton];

                
        numOneButton = [CCSprite spriteWithFile:@"blueSandDollar.png"];
        numOneButton.position = ccp(190, 220);
        numOneButton.anchorPoint = ccp(0,0);
        [self addChild:numOneButton];
        
        nav1Label = [CCLabelTTF labelWithString:@"1" fontName:@"MarkerFelt-Thin" fontSize:36];
		nav1Label.color = ccc3(255, 255, 255);
		nav1Label.position = ccp(255, 265);
        nav1Label.anchorPoint = ccp(0,0);
		[self addChild:nav1Label z:20];
        
        nav2Label = [CCLabelTTF labelWithString:@"2" fontName:@"MarkerFelt-Thin" fontSize:36];
		nav2Label.color = ccc3(255, 255, 255);
		nav2Label.position = ccp(315, 265);
        nav2Label.anchorPoint = ccp(0,0);
		[self addChild:nav2Label z:20];
        
        nav3Label = [CCLabelTTF labelWithString:@"3" fontName:@"MarkerFelt-Thin" fontSize:36];
		nav3Label.color = ccc3(255, 255, 255);
		nav3Label.position = ccp(375, 265);
        nav3Label.anchorPoint = ccp(0,0);
		[self addChild:nav3Label z:20];

                
        
               
        /*******Menu Item 2*************/
        howToPlay7Label = [CCLabelTTF labelWithString:@"3 letter words:  8 pts" fontName:@"Verdana" fontSize:11];
		howToPlay7Label.color = ccc3(255, 255, 255);
		howToPlay7Label.position = ccp(5, 249);
        howToPlay7Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay7Label];
        
        howToPlay8Label = [CCLabelTTF labelWithString:@"4 letter words: 16 pts" fontName:@"Verdana" fontSize:11];
		howToPlay8Label.color = ccc3(255, 255, 255);
		howToPlay8Label.position = ccp(5, 236);
        howToPlay8Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay8Label];
        
        howToPlay9Label = [CCLabelTTF labelWithString:@"5 letter words: 32 pts" fontName:@"Verdana" fontSize:11];
		howToPlay9Label.color = ccc3(255, 255, 255);
		howToPlay9Label.position = ccp(5, 223);
        howToPlay9Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay9Label];
        
        howToPlay10Label = [CCLabelTTF labelWithString:@"and so on ..." fontName:@"Verdana" fontSize:11];
		howToPlay10Label.color = ccc3(255, 255, 255);
		howToPlay10Label.position = ccp(5, 210);
        howToPlay10Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay10Label];
        
        topRightElbow2 = [CCSprite spriteWithFile:@"top-right-elbow-white-2.png"];
        topRightElbow2.position = ccp(163, 228);
        [self addChild:topRightElbow2];

               
        topLeftElbow = [CCSprite spriteWithFile:@"top-left-elbow-white.png"];
        topLeftElbow.position = ccp(355, 105);
        [self addChild:topLeftElbow];
        
        howToPlay11Label = [CCLabelTTF labelWithString:@"Each player has 100 seconds" fontName:@"Verdana" fontSize:11];
		howToPlay11Label.color = ccc3(255, 255, 255);
		howToPlay11Label.position = ccp(270, 42);
        howToPlay11Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay11Label];
        
        howToPlay12Label = [CCLabelTTF labelWithString:@"to create words" fontName:@"Verdana" fontSize:11];
		howToPlay12Label.color = ccc3(255, 255, 255);
		howToPlay12Label.position = ccp(273, 30);
        howToPlay12Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay12Label];
         
        [self hideMenu2Items];
  
    }
    return self;
}

- (void) hideMenu1Items
{
    howToPlay1Label.visible = NO;
    howToPlay2Label.visible = NO;
    topRightElbow.visible = NO;
    
    howToPlay3Label.visible = NO;
    howToPlay4Label.visible = NO;
    bottomLeftElbow.visible = NO;
    
    howToPlay5Label.visible = NO;
    howToPlay6Label.visible = NO;
    bottomRightElbow.visible = NO;
    

    
}

- (void) showMenu1Items
{
    howToPlay1Label.visible = YES;
    howToPlay2Label.visible = YES;
    topRightElbow.visible = YES;
    
    howToPlay3Label.visible = YES;
    howToPlay4Label.visible = YES;
    bottomLeftElbow.visible = YES;
    
    howToPlay5Label.visible = YES;
    howToPlay6Label.visible = YES;
    bottomRightElbow.visible = YES;
    
    iPhoneScreenShot.position = ccp(240,160);
    gameScreenShot.position = ccp(240,160);
    
}

- (void) hideMenu2Items
{
    howToPlay7Label.visible = NO;
    howToPlay8Label.visible = NO;
    howToPlay9Label.visible = NO;
    howToPlay10Label.visible = NO;
    topRightElbow2.visible = NO;
    
    howToPlay11Label.visible = NO;
    howToPlay12Label.visible = NO;
    topLeftElbow.visible = NO;
    
}

- (void) showMenu2Items
{
    howToPlay7Label.visible = YES;
    howToPlay8Label.visible = YES;
    howToPlay9Label.visible = YES;
    howToPlay10Label.visible = YES;
    topRightElbow2.visible = YES;
    
    howToPlay11Label.visible = YES;
    howToPlay12Label.visible = YES;
    topLeftElbow.visible = YES;
    
    gameScreenShot.position = ccp(275,150);
    iPhoneScreenShot.position = ccp(275,150);
        
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}


- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {

    CCLOG(@"Inside ccTouchBegan ...");
    
    CCLOG(@"screenNavigator width:%f",screenNavigatorButtons.contentSize.width);
    CCLOG(@"screenNavigator height:%f",screenNavigatorButtons.contentSize.height);
    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CCLOG(@"touchLocation x:%f",touchLocation.x);
    
    
    if(CGRectContainsPoint(CGRectMake(screenNavigatorButtons.position.x + 23, 
                                      screenNavigatorButtons.position.y, 
                                      (screenNavigatorButtons.contentSize.width - 23) / 4, 
                                      screenNavigatorButtons.contentSize.height),
                           touchLocation)){
        CCLOG(@"1 was pressed.");
        [self hideMenu2Items];
        [self showMenu1Items];
        
    }
    else if(CGRectContainsPoint(CGRectMake(screenNavigatorButtons.position.x + 23 + 
                                                ((screenNavigatorButtons.contentSize.width - 23) / 4), 
                                           screenNavigatorButtons.position.y, 
                                           (screenNavigatorButtons.contentSize.width - 23) / 4, 
                                           screenNavigatorButtons.contentSize.height),
                                touchLocation)){
        CCLOG(@"2 was pressed.");
        
        [self hideMenu1Items];
        [self showMenu2Items];
        
        
    }
    else if(CGRectContainsPoint(CGRectMake(screenNavigatorButtons.position.x + 23 + 
                                                (2 * ((screenNavigatorButtons.contentSize.width - 23) / 4)), 
                                           screenNavigatorButtons.position.y, 
                                           (screenNavigatorButtons.contentSize.width - 23) / 4, 
                                           screenNavigatorButtons.contentSize.height),
                                touchLocation)){
        CCLOG(@"3 was pressed.");
        mainMenuScreenShot.visible = NO;
        gameScreenShot.visible = YES;
        [howToPlay1Label setString:@"Let's play! Select at least 3 letters to make words."];
        howToPlay1Label.position = ccp(80, 230);
        
        
    }
    else if(CGRectContainsPoint(CGRectMake(screenNavigatorButtons.position.x + 23 + 
                                           (3 * ((screenNavigatorButtons.contentSize.width - 23) / 4)), 
                                           screenNavigatorButtons.position.y, 
                                           (screenNavigatorButtons.contentSize.width - 23) / 4, 
                                           screenNavigatorButtons.contentSize.height),
                                touchLocation)){
        CCLOG(@"Main menu was pressed.");
        mainMenuScreenShot.visible = NO;
        gameScreenShot.visible = YES;
        [howToPlay1Label setString:@"Let's play! Select at least 3 letters to make words."];
        howToPlay1Label.position = ccp(80, 230);
        
        /* for now, have 3 go back to the main menu screen */
        [[GameManager sharedGameManager] runSceneWithId:kMainMenuScene];
    }


    
    
    return TRUE;

}
@end
