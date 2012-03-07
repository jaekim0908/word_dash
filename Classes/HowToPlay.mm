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
            batchNode = [[CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"howToPlay_retina.png"]] retain];           
        }
        else{
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"howToPlay_3g.plist"];
            batchNode = [[CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"howToPlay_3g.png"]] retain];    
        }

        [self addChild:batchNode];
        
        howToPlayLiteral = [[CCLabelTTF labelWithString:@"" fontName:@"MarkerFelt-Thin" fontSize:24] retain];
		howToPlayLiteral.color = ccc3(240, 240, 240);
		howToPlayLiteral.position = ccp(10, 270);
        howToPlayLiteral.anchorPoint = ccp(0,0);
		[self addChild:howToPlayLiteral];
        
        
        sandBackground = [[CCSprite spriteWithFile:@"black-background.png"] retain];
        sandBackground.position = ccp(240, 160);
        [self addChild:sandBackground z:-20];

        iPhoneScreenShot = [[CCSprite spriteWithSpriteFrameName:@"iphone4.png"] retain];
        iPhoneScreenShot.position = ccp(240, 157);
        [batchNode addChild:iPhoneScreenShot];
        
        
        //GAME SCREENS
        gameScreenShotFlip = [[CCSprite spriteWithSpriteFrameName:@"game_screen_flip.png"] retain];
        gameScreenShotFlip.position = ccp(240, 160);
        [batchNode addChild:gameScreenShotFlip];
 
        gameScreenShotSelect = [[CCSprite spriteWithSpriteFrameName:@"game_screen_select_letters.png"] retain];
        gameScreenShotSelect.position = ccp(240, 160);
        [batchNode addChild:gameScreenShotSelect];
        
        gameScreenShotSubmit = [[CCSprite spriteWithSpriteFrameName:@"game_screen_submit_words.png"] retain];
        gameScreenShotSubmit.position = ccp(240, 175);
        [batchNode addChild:gameScreenShotSubmit];
        
        gameScreenShotTripleTap = [[CCSprite spriteWithSpriteFrameName:@"game_screen_tripletap_letters.png"] retain];
        gameScreenShotTripleTap.position = ccp(240, 185);
        [batchNode addChild:gameScreenShotTripleTap];

           
        
        finger = [[CCSprite spriteWithSpriteFrameName:@"hand.png"] retain];
        finger.position = ccp(230, 125);
        finger.visible=YES;
        [batchNode addChild:finger];
        
        finger2 = [[CCSprite spriteWithSpriteFrameName:@"hand2.png"] retain];
        finger2.position = ccp(230, 125);
        [batchNode addChild:finger2];

  
        howToPlay3Label = [[CCLabelTTF labelWithString:@"*If no word or invalid word is submitted, " fontName:@"MarkerFelt-Thin" fontSize:20] retain];
		howToPlay3Label.color = ccc3(255, 255, 255);
		howToPlay3Label.position = ccp(40, 35);
        howToPlay3Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay3Label];
        
        howToPlay3bLabel = [[CCLabelTTF labelWithString:@"a letter will be revealed for the opponent." fontName:@"MarkerFelt-Thin" fontSize:20] retain];
		howToPlay3bLabel.color = ccc3(255, 255, 255);
		howToPlay3bLabel.position = ccp(40+8, 35-22);
        howToPlay3bLabel.anchorPoint = ccp(0,0);
		[self addChild:howToPlay3bLabel];

        
        nextPageButton = [[CCSprite spriteWithSpriteFrameName:@"checkmark_btn.png"] retain];
        nextPageButton.position = ccp(425, 32);
        [batchNode addChild:nextPageButton];
        
        
               
        /******* Scoring *************/
        howToPlay7Label = [[CCLabelTTF labelWithString:@"3 letter words:   8 pts" fontName:@"MarkerFelt-Thin" fontSize:20] retain];
		howToPlay7Label.color = ccc3(255, 255, 255);
		howToPlay7Label.position = ccp(205, 65);
        howToPlay7Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay7Label];
        
        howToPlay8Label = [[CCLabelTTF labelWithString:@"4 letter words: 16 pts" fontName:@"MarkerFelt-Thin" fontSize:20] retain];
		howToPlay8Label.color = ccc3(255, 255, 255);
		howToPlay8Label.position = ccp(205, 45);
        howToPlay8Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay8Label];
        
        howToPlay9Label = [[CCLabelTTF labelWithString:@"5 letter words: 32 pts" fontName:@"MarkerFelt-Thin" fontSize:20] retain];
		howToPlay9Label.color = ccc3(255, 255, 255);
		howToPlay9Label.position = ccp(205, 25);
        howToPlay9Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay9Label];
        
        howToPlay10Label = [[CCLabelTTF labelWithString:@"and so on ..." fontName:@"MarkerFelt-Thin" fontSize:20] retain];
		howToPlay10Label.color = ccc3(255, 255, 255);
		howToPlay10Label.position = ccp(292, 5);
        howToPlay10Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay10Label];
        
        
        howToPlay11Label = [[CCLabelTTF labelWithString:@"*Use starred letters to earn 10 seconds" fontName:@"MarkerFelt-Thin" fontSize:20] retain];
		howToPlay11Label.color = ccc3(255, 255, 255);
		howToPlay11Label.position = ccp(15, 85);
        howToPlay11Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay11Label];
        
        howToPlay12Label = [[CCLabelTTF labelWithString:@"*Triple tap for a new letter when the board is full" fontName:@"MarkerFelt-Thin" fontSize:20] retain];
		howToPlay12Label.color = ccc3(255, 255, 255);
		howToPlay12Label.position = ccp(15, 60);
        howToPlay12Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay12Label];
        
        howToPlay13Label = [[CCLabelTTF labelWithString:@"*Flip over a vowel for 8 points" fontName:@"MarkerFelt-Thin" fontSize:20] retain];
		howToPlay13Label.color = ccc3(255, 255, 255);
		howToPlay13Label.position = ccp(90, 5);
        howToPlay13Label.anchorPoint = ccp(0,0);
		[self addChild:howToPlay13Label];

         
        [self hideMenu2Items];
        [self hideMenu3Items];
        [self hideMenu4Items];
        [self showMenu1Items];
         
  
    }
    return self;
}

- (void) hideMenu1Items
{
    gameScreenShotFlip.visible=NO;
    finger.visible=NO;
    howToPlay13Label.visible = NO;
    
}


- (void) showMenu1Items
{
    gameScreenShotFlip.visible=YES;
    finger.visible=YES;
    finger.position = ccp(195, 80+15);    
    iPhoneScreenShot.position = ccp(240,157);
    howToPlay13Label.visible = YES;
      
    [howToPlayLiteral setString:@"Flip 1 Letter Per Turn (Optional)"];
    
}

- (void) hideMenu2Items
{
    gameScreenShotSelect.visible=NO;
    finger2.visible=NO;
    howToPlay3Label.visible=NO;
    howToPlay3bLabel.visible=NO;
    
}

- (void) showMenu2Items
{
    gameScreenShotSelect.visible=YES;
    finger2.visible=YES;
    finger2.position = ccp(317+20, 118+5);
    howToPlay3Label.visible=YES;
    howToPlay3bLabel.visible=YES;
    
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
    finger.position = ccp(140, 88);
    
    iPhoneScreenShot.position = ccp(240,175-3);
    
    
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
     gameScreenShotTripleTap.visible=YES;
    howToPlay11Label.visible=YES;
    howToPlay12Label.visible = YES;
        
    iPhoneScreenShot.position = ccp(240,182);
    
    [howToPlayLiteral setString:@"Power Plays: "];
    
}



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

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [howToPlay3Label release];
    [howToPlay3bLabel release];
    [howToPlay7Label release];
    [howToPlay8Label release];
    [howToPlay9Label release];
    [howToPlay10Label release];
    [howToPlay11Label release];
    [howToPlay12Label release];
    [howToPlay13Label release];
    [howToPlayLiteral release];
    [nextPageButton release];
    [iPhoneScreenShot release];
    [gameScreenShotFlip release];
    [gameScreenShotSelect release];
    [gameScreenShotSubmit release];
    [gameScreenShotStars release];
    [gameScreenShotTripleTap release];
    [sandBackground release];
    [finger release];
    [finger2 release];
    [batchNode release];
     
     
    
	[super dealloc];
}

@end
