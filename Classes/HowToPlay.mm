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
@synthesize nextPageButton;
@synthesize blueLine;
@synthesize numTwoButton;
@synthesize numThreeButton;
@synthesize mainMenuButton;
@synthesize mainMenuScreenShot;
@synthesize gameScreenShotFlip;
@synthesize gameScreenShotSelect;
@synthesize gameScreenShotSubmit;
@synthesize gameScreenShotStar;
@synthesize gameScreenShotTripleTap;
@synthesize sandBackground;
@synthesize howToPlayLiteral;
@synthesize iPhoneScreenShot;
@synthesize verticalLine;
@synthesize screenNavigatorButtons;
@synthesize finger;
@synthesize finger2;
@synthesize batchNode;
@synthesize nextPagePressedCount;




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
        
        nextPagePressedCount = 0;
        
        //SETUP SPRITE SHEET
        if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"howToPlay_retina.plist"];
            batchNode = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"howToPlay_retina.png"]];           
        }
        else{
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"howToPlay_3g.plist"];
            batchNode = [CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"howToPlay_3g.png"]];    
        }

        
        howToPlayLiteral = [CCLabelTTF labelWithString:@"" fontName:@"MarkerFelt-Thin" fontSize:24];
		howToPlayLiteral.color = ccc3(240, 240, 240);
		howToPlayLiteral.position = ccp(10, 270);
        howToPlayLiteral.anchorPoint = ccp(0,0);
		[self addChild:howToPlayLiteral];
        
        
        //LABEL 1 and LABEL 2 NOT USED FOR NOW
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


        sandBackground = [CCSprite spriteWithFile:@"black-background.png"];
        sandBackground.position = ccp(240, 160);
        [self addChild:sandBackground z:-20];

        iPhoneScreenShot = [CCSprite spriteWithFile:@"iphone4.png"];
        iPhoneScreenShot.position = ccp(240, 157);
        [self addChild:iPhoneScreenShot];
        
        
        //GAME SCREENS
        gameScreenShotFlip = [CCSprite spriteWithSpriteFrameName:@"game_screen_flip.png"];
        gameScreenShotFlip.position = ccp(240, 160);
        [self addChild:gameScreenShotFlip];

        gameScreenShotSelect = [CCSprite spriteWithSpriteFrameName:@"game_screen_select_letters.png"];
        gameScreenShotSelect.position = ccp(240, 160);
        [self addChild:gameScreenShotSelect];
        
        gameScreenShotSubmit = [CCSprite spriteWithSpriteFrameName:@"game_screen_submit_words.png"];
        gameScreenShotSubmit.position = ccp(240, 175);
        [self addChild:gameScreenShotSubmit];

        //gameScreenShotStar = [CCSprite spriteWithFile:@"game_screen_star_letters.png"];
        //gameScreenShotStar.position = ccp(240, 160);
        //[self addChild:gameScreenShotStar];
        
        gameScreenShotTripleTap = [CCSprite spriteWithFile:@"game_screen_tripletap_letters.png"];
        gameScreenShotTripleTap.position = ccp(240, 185);
        [self addChild:gameScreenShotTripleTap];

           
        
        finger = [CCSprite spriteWithFile:@"hand.png"];
        finger.position = ccp(230, 125);
        finger.visible=YES;
        [self addChild:finger];
        
        finger2 = [CCSprite spriteWithFile:@"hand2.png"];
        finger2.position = ccp(230, 125);
        [self addChild:finger2];

        
        howToPlay3Label = [CCLabelTTF labelWithString:@"*Plural words ending in 's' are not valid" fontName:@"MarkerFelt-Thin" fontSize:20];
		howToPlay3Label.color = ccc3(255, 255, 255);
		howToPlay3Label.position = ccp(40, 35);
        howToPlay3Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay3Label];

        howToPlay4Label = [CCLabelTTF labelWithString:@"with 3 or more letters" fontName:@"Verdana" fontSize:12];
		howToPlay4Label.color = ccc3(255, 255, 255);
		howToPlay4Label.position = ccp(248, 52);
        howToPlay4Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay4Label];
        
        
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

        
        nextPageButton = [CCSprite spriteWithFile:@"checkmark_btn.png"];
        nextPageButton.position = ccp(425, 32);
        //nextPageButton.anchorPoint = ccp(0,0);
        [self addChild:nextPageButton];
        
        
               
        /******* Scoring *************/
        howToPlay7Label = [CCLabelTTF labelWithString:@"3 letter words:   8 pts" fontName:@"MarkerFelt-Thin" fontSize:20];
		howToPlay7Label.color = ccc3(255, 255, 255);
		howToPlay7Label.position = ccp(15, 65);
        howToPlay7Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay7Label];
        
        howToPlay8Label = [CCLabelTTF labelWithString:@"4 letter words: 16 pts" fontName:@"MarkerFelt-Thin" fontSize:20];
		howToPlay8Label.color = ccc3(255, 255, 255);
		howToPlay8Label.position = ccp(15, 45);
        howToPlay8Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay8Label];
        
        howToPlay9Label = [CCLabelTTF labelWithString:@"5 letter words: 32 pts" fontName:@"MarkerFelt-Thin" fontSize:20];
		howToPlay9Label.color = ccc3(255, 255, 255);
		howToPlay9Label.position = ccp(15, 25);
        howToPlay9Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay9Label];
        
        howToPlay10Label = [CCLabelTTF labelWithString:@"and so on ..." fontName:@"MarkerFelt-Thin" fontSize:20];
		howToPlay10Label.color = ccc3(255, 255, 255);
		howToPlay10Label.position = ccp(102, 5);
        howToPlay10Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay10Label];
        
        
        howToPlay11Label = [CCLabelTTF labelWithString:@"*Use starred letters to earn 10 seconds" fontName:@"MarkerFelt-Thin" fontSize:20];
		howToPlay11Label.color = ccc3(255, 255, 255);
		howToPlay11Label.position = ccp(15, 85);
        howToPlay11Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay11Label];
        
        //blueLine = [CCSprite spriteWithFile:@"blue_line.png"];
        //blueLine.position = ccp(280, 100);
        //[self addChild:blueLine];
        
        howToPlay12Label = [CCLabelTTF labelWithString:@"*Triple tap for a new letter when the board is full" fontName:@"MarkerFelt-Thin" fontSize:20];
		howToPlay12Label.color = ccc3(255, 255, 255);
		howToPlay12Label.position = ccp(15, 60);
        howToPlay12Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay12Label];
         
        [self hideMenu2Items];
        [self hideMenu3Items];
        [self hideMenu4Items];
        [self showMenu1Items];
        
        /* TEMP MCH */
        howToPlay1Label.visible = NO;
        howToPlay2Label.visible = NO;
             
          
        howToPlay11Label.visible = NO;
        howToPlay12Label.visible = NO;

        
        howToPlay5Label.visible = NO;
        howToPlay6Label.visible = NO;
   
        
        howToPlay3Label.visible = NO;
        howToPlay4Label.visible = NO;
 
  
    }
    return self;
}

- (void) hideMenu1Items
{
    gameScreenShotFlip.visible=NO;
    finger.visible=NO;
    
}


- (void) showMenu1Items
{
    gameScreenShotFlip.visible=YES;
    finger.visible=YES;
    finger.position = ccp(195, 80);    
    iPhoneScreenShot.position = ccp(240,157);
      
    [howToPlayLiteral setString:@"Flip 1 Letter Per Turn (Optional)"];
    
}

- (void) hideMenu2Items
{
    gameScreenShotSelect.visible=NO;
    finger2.visible=NO;
    howToPlay3Label.visible=NO;
    
}

- (void) showMenu2Items
{
    gameScreenShotSelect.visible=YES;
    finger2.visible=YES;
    finger2.position = ccp(317, 118);
    howToPlay3Label.visible=YES;
    
    iPhoneScreenShot.position = ccp(240,157);
    
    
    [howToPlayLiteral setString:@"Select At Least 3 Letters To Create Words"];
        
}

- (void) hideMenu3Items
{
    gameScreenShotSubmit.visible=NO;
    finger.visible=NO;
    
    howToPlay7Label.visible = NO;
    howToPlay8Label.visible = NO;
    howToPlay9Label.visible = NO;
    howToPlay10Label.visible = NO;

}

- (void) showMenu3Items
{
    finger.visible=YES;
    gameScreenShotSubmit.visible=YES;
    finger.position = ccp(290, 80);
    
    iPhoneScreenShot.position = ccp(240,175);
    
    
    [howToPlayLiteral setString:@"Submit Words To Score and End Turn"];

    howToPlay7Label.visible = YES;
    howToPlay8Label.visible = YES;
    howToPlay9Label.visible = YES;
    howToPlay10Label.visible = YES;
    
}

- (void) hideMenu4Items
{
    gameScreenShotTripleTap.visible=NO;
    howToPlay11Label.visible = NO;
    howToPlay12Label.visible = NO;
   
    
    //finger2.visible=NO;
}

- (void) showMenu4Items
{
    //finger2.visible=YES;
    gameScreenShotTripleTap.visible=YES;
    howToPlay11Label.visible=YES;
    howToPlay12Label.visible = YES;
    
    //finger2.position = ccp(158, 90);
    
    iPhoneScreenShot.position = ccp(240,182);
    
    [howToPlayLiteral setString:@"Power Plays: "];
    
}

/*********
- (void) hideMenu5Items
{
    gameScreenShotTripleTap.visible=NO;
    finger.visible=NO;
}

- (void) showMenu5Items
{
    finger.visible=YES;
    gameScreenShotTripleTap.visible=YES;
    finger.position = ccp(230, 125);
    
    iPhoneScreenShot.position = ccp(240,160);
    
    [howToPlayLiteral setString:@"Triple tap for a new letter when the board is full."];
    
}
*********/


- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}


- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {

    CCLOG(@"Inside ccTouchBegan ...");
    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CCLOG(@"touchLocation x:%f",touchLocation.x);
    
    
    if(CGRectContainsPoint(CGRectMake(nextPageButton.position.x - (nextPageButton.contentSize.width/2), 
                                      nextPageButton.position.y - (nextPageButton.contentSize.height/2), 
                                      nextPageButton.contentSize.width, 
                                      nextPageButton.contentSize.height),
                           touchLocation)){
        CCLOG(@"Next Page button was pressed.");
        switch (nextPagePressedCount) {
            case 0:
                [self hideMenu1Items];
                [self hideMenu3Items];
                [self hideMenu4Items];
                [self showMenu2Items];
                nextPagePressedCount++;
                break;
            case 1:
                [self hideMenu1Items];
                [self hideMenu2Items];
                [self hideMenu4Items];
                [self showMenu3Items];
                nextPagePressedCount++;
                break;
            case 2:
                [self hideMenu1Items];
                [self hideMenu2Items];
                [self hideMenu3Items];
                [self showMenu4Items];
                nextPagePressedCount++;
                break;
              default:
                 [[CCDirector sharedDirector] popScene];
                break;
        }
        
        
        
    }

    
    
    return TRUE;

}
@end
