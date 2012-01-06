//
//  SinglePlayLevelMenu.m
//  HundredSeconds
//
//  Created by Michael Ho on 12/8/11.
//  Copyright (c) 2011 experiencesquad. All rights reserved.
//

#import "SinglePlayLevelMenu.h"
#import "GameManager.h"

@implementation SinglePlayLevelMenu

@synthesize sandBackground;
@synthesize plateBackground;

@synthesize level1Button;
@synthesize level2Button;
@synthesize level3Button;
@synthesize level4Button;
@synthesize level5Button;

@synthesize level1Literal;
@synthesize level2Literal;
@synthesize level3Literal;
@synthesize level4Literal;
@synthesize level5Literal;

@synthesize level1BeatAIAward;
@synthesize level1TotalPointsAward;
@synthesize level1LongWordAward;

@synthesize level2BeatAIAward;
@synthesize level2TotalPointsAward;
@synthesize level2LongWordAward;

@synthesize level3BeatAIAward;
@synthesize level3TotalPointsAward;
@synthesize level3LongWordAward;

@synthesize level4BeatAIAward;
@synthesize level4TotalPointsAward;
@synthesize level4LongWordAward;

@synthesize level5BeatAIAward;
@synthesize level5TotalPointsAward;
@synthesize level5LongWordAward;



+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SinglePlayLevelMenu *layer = [SinglePlayLevelMenu node];
	
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
        
        CCLOG(@"Inside Single Play Level Menu.");
        
        self.isTouchEnabled = YES;
        
        //sandBackground = [CCSprite spriteWithFile:@"black-background.png"];
        //sandBackground = [CCSprite spriteWithFile:@"footPrintWhiteSand.png"];
        sandBackground = [CCSprite spriteWithFile:@"whiteSandBg.png"];
        sandBackground.position = ccp(240, 160);
        [self addChild:sandBackground z:0];

        //plateBackground = [CCSprite spriteWithFile:@"hawaiian_platter-80-50.png"];
        //plateBackground.position = ccp(40, 190);
        //[self addChild:plateBackground z:1];

        
        //LEVEL ONE
        level1Button = [CCSprite spriteWithFile:@"blueSandDollar.png"];
        level1Button.position = ccp(40, 240);
        [self addChild:level1Button z:1];
        
        level1Literal = [CCLabelTTF labelWithString:@"1"
                                               fontName:@"Marker Felt" 
                                               fontSize:32]; 
		level1Literal.color = ccc3(255,255,255);;
		level1Literal.position = ccp(40,240);
        [self addChild:level1Literal z:10];
        
        level1BeatAIAward = [CCSprite spriteWithFile:@"trophy.png"];
        level1BeatAIAward.position = ccp(10, 200);
        level1BeatAIAward.visible=NO;
        [self addChild:level1BeatAIAward z:2];
        
        level1TotalPointsAward = [CCSprite spriteWithFile:@"coins.png"];
        level1TotalPointsAward.position = ccp(35, 200);
        level1TotalPointsAward.visible=NO;
        [self addChild:level1TotalPointsAward z:2];
        
        level1LongWordAward = [CCSprite spriteWithFile:@"dictionary.png"];
        level1LongWordAward.position = ccp(62, 200);
        level1LongWordAward.visible=NO;
        [self addChild:level1LongWordAward z:2];

        //LEVEL TWO
        level2Button = [CCSprite spriteWithFile:@"blueSandDollar.png"];
        level2Button.position = ccp(140, 240);
        [self addChild:level2Button z:1];
        
        level2Literal = [CCLabelTTF labelWithString:@"2"
                                           fontName:@"Marker Felt" 
                                           fontSize:32]; 
		level2Literal.color = ccc3(255,255,255);;
		level2Literal.position = ccp(140,240);
        [self addChild:level2Literal z:10];

        level2BeatAIAward = [CCSprite spriteWithFile:@"trophy.png"];
        level2BeatAIAward.position = ccp(110, 200);
        level2BeatAIAward.visible=NO;
        [self addChild:level2BeatAIAward z:1];
        
        level2TotalPointsAward = [CCSprite spriteWithFile:@"coins.png"];
        level2TotalPointsAward.position = ccp(135, 200);
        level2TotalPointsAward.visible=NO;
        [self addChild:level2TotalPointsAward z:1];
        
        level2LongWordAward = [CCSprite spriteWithFile:@"dictionary.png"];
        level2LongWordAward.position = ccp(162, 200);
        level2LongWordAward.visible=NO;
        [self addChild:level2LongWordAward z:1];

        
        //LEVEL THREE
        level3Button = [CCSprite spriteWithFile:@"blueSandDollar.png"];
        level3Button.position = ccp(240, 240);
        [self addChild:level3Button z:1];

        level3Literal = [CCLabelTTF labelWithString:@"3"
                                           fontName:@"Marker Felt" 
                                           fontSize:32]; 
		level3Literal.color = ccc3(255,255,255);;
		level3Literal.position = ccp(240,240);
        [self addChild:level3Literal z:10];
        
        level3BeatAIAward = [CCSprite spriteWithFile:@"trophy.png"];
        level3BeatAIAward.position = ccp(210, 200);
        level3BeatAIAward.visible=NO;
        [self addChild:level3BeatAIAward z:1];
        
        level3TotalPointsAward = [CCSprite spriteWithFile:@"coins.png"];
        level3TotalPointsAward.position = ccp(235, 200);
        level3TotalPointsAward.visible=NO;
        [self addChild:level3TotalPointsAward z:1];
        
        level3LongWordAward = [CCSprite spriteWithFile:@"dictionary.png"];
        level3LongWordAward.position = ccp(262, 200);
        level3LongWordAward.visible=NO;
        [self addChild:level3LongWordAward z:1];
        
        //LEVEL FOUR
        level4Button = [CCSprite spriteWithFile:@"blueSandDollar.png"];
        level4Button.position = ccp(340, 240);
        [self addChild:level4Button z:1];

        level4Literal = [CCLabelTTF labelWithString:@"4"
                                           fontName:@"Marker Felt" 
                                           fontSize:32]; 
		level4Literal.color = ccc3(255,255,255);;
		level4Literal.position = ccp(340,240);
        [self addChild:level4Literal z:10];

        level4BeatAIAward = [CCSprite spriteWithFile:@"trophy.png"];
        level4BeatAIAward.position = ccp(310, 200);
        level4BeatAIAward.visible=NO;
        [self addChild:level4BeatAIAward z:1];
        
        level4TotalPointsAward = [CCSprite spriteWithFile:@"coins.png"];
        level4TotalPointsAward.position = ccp(335, 200);
        level4TotalPointsAward.visible=NO;
        [self addChild:level4TotalPointsAward z:1];
        
        level4LongWordAward = [CCSprite spriteWithFile:@"dictionary.png"];
        level4LongWordAward.position = ccp(362, 200);
        level4LongWordAward.visible=NO;
        [self addChild:level4LongWordAward z:1];
        
        //LEVEL FIVE
        level5Button = [CCSprite spriteWithFile:@"blueSandDollar.png"];
        level5Button.position = ccp(440, 240);
        [self addChild:level5Button z:1];
        
        level5Literal = [CCLabelTTF labelWithString:@"5"
                                           fontName:@"Marker Felt" 
                                           fontSize:32]; 
		level5Literal.color = ccc3(255,255,255);;
		level5Literal.position = ccp(440,240);
        [self addChild:level5Literal z:10];

        level5BeatAIAward = [CCSprite spriteWithFile:@"trophy.png"];
        level5BeatAIAward.position = ccp(410, 200);
        level5BeatAIAward.visible=NO;
        [self addChild:level5BeatAIAward z:1];
        
        level5TotalPointsAward = [CCSprite spriteWithFile:@"coins.png"];
        level5TotalPointsAward.position = ccp(435, 200);
        level5TotalPointsAward.visible=NO;
        [self addChild:level5TotalPointsAward z:1];
        
        level5LongWordAward = [CCSprite spriteWithFile:@"dictionary.png"];
        level5LongWordAward.position = ccp(462, 200);
        level5LongWordAward.visible=NO;
        [self addChild:level5LongWordAward z:1];
        
        //DISPLAY THE STAR LEVELS BASED ON THE VALUES IN THE PLIST
        [self displayStars:@"Level1" 
                BeatAIAwardSprite:level1BeatAIAward 
                TotalPointAwardSprite:level1TotalPointsAward 
                LongWordAwardSprite:level1LongWordAward];
        
        [self displayStars:@"Level2" 
                BeatAIAwardSprite:level2BeatAIAward 
                TotalPointAwardSprite:level2TotalPointsAward 
                LongWordAwardSprite:level2LongWordAward];

        [self displayStars:@"Level3" 
                BeatAIAwardSprite:level3BeatAIAward 
                TotalPointAwardSprite:level3TotalPointsAward 
                LongWordAwardSprite:level3LongWordAward];

        [self displayStars:@"Level4" 
                BeatAIAwardSprite:level4BeatAIAward 
                TotalPointAwardSprite:level4TotalPointsAward 
                LongWordAwardSprite:level4LongWordAward];

        [self displayStars:@"Level5" 
                BeatAIAwardSprite:level5BeatAIAward 
                TotalPointAwardSprite:level5TotalPointsAward 
                LongWordAwardSprite:level5LongWordAward];

    }
    return self;
}

- (void) displayStars:(NSString *) levelName 
            BeatAIAwardSprite:(CCSprite *) beatAIAwardSprite
            TotalPointAwardSprite:(CCSprite *) totalPointAwardSprite
            LongWordAwardSprite:(CCSprite *) longWordAwardSprite
{
    NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] objectForKey:levelName];    
    
    beatAIAwardSprite.visible = [[levelInfo objectForKey:@"beatAIAward"] boolValue];
    totalPointAwardSprite.visible = [[levelInfo objectForKey:@"totalPointsAward"] boolValue];
    longWordAwardSprite.visible = [[levelInfo objectForKey:@"totalPointsAward"] boolValue];
    
    //temporary alignment
    //beatAIAwardSprite.position = ccp(beatAIAwardSprite.position.x + 30.0f,beatAIAwardSprite.position.y - 3.0f);
    
    //NEXT: CENTER THE AWARDS DEPENDING ON THE NUMBER OF AWARDS

}
- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {
    
    CCLOG(@"Inside ccTouchBegan ...");
    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CCLOG(@"touchLocation x:%f",touchLocation.x);
    
    int batchSize, aiMaxWaitTime;
    
    if(CGRectContainsPoint(level1Button.boundingBox,
                           touchLocation)){
        CCLOG(@"Level 1 Button PRESSED.");
        
        NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] objectForKey:@"Level1"];
        batchSize = [[levelInfo objectForKey:@"batchSize"] intValue];
        aiMaxWaitTime = [[levelInfo objectForKey:@"AIMaxWaitTime"] intValue];
        
        [[GameManager sharedGameManager] setAiMaxWaitTime:aiMaxWaitTime];
        [[GameManager sharedGameManager] setSinglePlayerBatchSize:batchSize];
        [[GameManager sharedGameManager] setSinglePlayerLevel:1];
        [ [GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];
    }
    else if(CGRectContainsPoint(level2Button.boundingBox,
                                touchLocation)){
        CCLOG(@"Level 2 Button PRESSED.");
        
        NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] objectForKey:@"Level2"];
        batchSize = [[levelInfo objectForKey:@"batchSize"] intValue];
        aiMaxWaitTime = [[levelInfo objectForKey:@"AIMaxWaitTime"] intValue];
        
        [[GameManager sharedGameManager] setAiMaxWaitTime:aiMaxWaitTime];
        [[GameManager sharedGameManager] setSinglePlayerBatchSize:batchSize];
        [[GameManager sharedGameManager] setSinglePlayerLevel:2];
        [ [GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];
    }
    else if(CGRectContainsPoint(level3Button.boundingBox,
                                touchLocation)){
        CCLOG(@"Level 3 Button PRESSED.");
        
        NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] objectForKey:@"Level3"];
        batchSize = [[levelInfo objectForKey:@"batchSize"] intValue];
        aiMaxWaitTime = [[levelInfo objectForKey:@"AIMaxWaitTime"] intValue];
        
        [[GameManager sharedGameManager] setAiMaxWaitTime:aiMaxWaitTime];
        [[GameManager sharedGameManager] setSinglePlayerBatchSize:batchSize];
        [[GameManager sharedGameManager] setSinglePlayerLevel:3];
        [ [GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];
    }
    else if(CGRectContainsPoint(level4Button.boundingBox,
                                touchLocation)){
        CCLOG(@"Level 4 Button PRESSED.");
        
        NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] objectForKey:@"Level4"];
        batchSize = [[levelInfo objectForKey:@"batchSize"] intValue];
        aiMaxWaitTime = [[levelInfo objectForKey:@"AIMaxWaitTime"] intValue];
        
        [[GameManager sharedGameManager] setAiMaxWaitTime:aiMaxWaitTime];
        [[GameManager sharedGameManager] setSinglePlayerBatchSize:batchSize];
        [[GameManager sharedGameManager] setSinglePlayerLevel:4];
        [ [GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];
    }
    else if(CGRectContainsPoint(level5Button.boundingBox,
                                touchLocation)){
        CCLOG(@"Level 5 Button PRESSED.");
        
        NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] objectForKey:@"Level5"];
        batchSize = [[levelInfo objectForKey:@"batchSize"] intValue];
        aiMaxWaitTime = [[levelInfo objectForKey:@"AIMaxWaitTime"] intValue];
        
        [[GameManager sharedGameManager] setAiMaxWaitTime:aiMaxWaitTime];
        [[GameManager sharedGameManager] setSinglePlayerBatchSize:batchSize];
        [[GameManager sharedGameManager] setSinglePlayerLevel:5];
        [ [GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];
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
	[super dealloc];
}


@end
