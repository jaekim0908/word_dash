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

@synthesize beachBackground;

@synthesize level1Button;
@synthesize level2Button;
@synthesize level3Button;
@synthesize level4Button;
@synthesize level5Button;

@synthesize backButton;

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
        
        beachBackground = [CCSprite spriteWithFile:@"Level-Background_004.png"];
        beachBackground.position = ccp(240, 160);
        [self addChild:beachBackground z:0];


        //LEVEL ONE
        level1Button = [CCSprite spriteWithFile:@"Level_001.png"];
        level1Button.position = ccp(39+25, 160);
        [self addChild:level1Button z:2];
        
        level1BeatAIAward = [CCSprite spriteWithFile:@"Trophy001.png"];
        //level1BeatAIAward.position = ccp(10, 200);
        level1BeatAIAward.position = ccp(64, 160);
        level1BeatAIAward.visible=NO;
        [self addChild:level1BeatAIAward z:2];
        
        level1TotalPointsAward = [CCSprite spriteWithFile:@"Coins001.png"];
        level1TotalPointsAward.position = ccp(64, 100);
        level1TotalPointsAward.visible=NO;
        [self addChild:level1TotalPointsAward z:2];
        
        level1LongWordAward = [CCSprite spriteWithFile:@"Book002.png"];
        level1LongWordAward.position = ccp(64, 50);
        level1LongWordAward.visible=NO;
        [self addChild:level1LongWordAward z:2];

        //LEVEL TWO
        level2Button = [CCSprite spriteWithFile:@"Level_002.png"];
        //level2Button.position = ccp(140, 240);
        level2Button.position = ccp(151, 160);
        [self addChild:level2Button z:2];
        
        level2BeatAIAward = [CCSprite spriteWithFile:@"Trophy001.png"];
        level2BeatAIAward.position = ccp(151, 160);
        level2BeatAIAward.visible=NO;
        [self addChild:level2BeatAIAward z:2];
        
        level2TotalPointsAward = [CCSprite spriteWithFile:@"Coins001.png"];
        level2TotalPointsAward.position = ccp(151, 100);
        level2TotalPointsAward.visible=NO;
        [self addChild:level2TotalPointsAward z:2];
        
        level2LongWordAward = [CCSprite spriteWithFile:@"Book002.png"];
        level2LongWordAward.position = ccp(151, 50);
        level2LongWordAward.visible=NO;
        [self addChild:level2LongWordAward z:2];

        
        //LEVEL THREE

        level3Button = [CCSprite spriteWithFile:@"Level_003.png"];
        //level3Button.position = ccp(240, 240);
        level3Button.position = ccp(239, 160);
        [self addChild:level3Button z:2];
        
        level3BeatAIAward = [CCSprite spriteWithFile:@"Trophy001.png"];
        level3BeatAIAward.position = ccp(239, 160);
        level3BeatAIAward.visible=NO;
        [self addChild:level3BeatAIAward z:2];
        
        level3TotalPointsAward = [CCSprite spriteWithFile:@"Coins001.png"];
        level3TotalPointsAward.position = ccp(239, 100);
        level3TotalPointsAward.visible=NO;
        [self addChild:level3TotalPointsAward z:2];
        
        level3LongWordAward = [CCSprite spriteWithFile:@"Book002.png"];
        level3LongWordAward.position = ccp(239, 50);
        level3LongWordAward.visible=NO;
        [self addChild:level3LongWordAward z:2];
        
        //LEVEL FOUR

        level4Button = [CCSprite spriteWithFile:@"Level_004.png"];
        //level4Button.position = ccp(340, 240);
        level4Button.position = ccp(339-14, 160);
        [self addChild:level4Button z:2];

        level4BeatAIAward = [CCSprite spriteWithFile:@"Trophy001.png"];
        level4BeatAIAward.position = ccp(325, 160);
        level4BeatAIAward.visible=NO;
        [self addChild:level4BeatAIAward z:2];
        
        level4TotalPointsAward = [CCSprite spriteWithFile:@"Coins001.png"];
        level4TotalPointsAward.position = ccp(325, 100);
        level4TotalPointsAward.visible=NO;
        [self addChild:level4TotalPointsAward z:2];
        
        level4LongWordAward = [CCSprite spriteWithFile:@"Book002.png"];
        level4LongWordAward.position = ccp(325, 50);
        level4LongWordAward.visible=NO;
        [self addChild:level4LongWordAward z:2];
        
        //LEVEL FIVE
        level5Button = [CCSprite spriteWithFile:@"Level_005.png"];
        //level5Button.position = ccp(440, 240);
        level5Button.position = ccp(439-27, 160);
        [self addChild:level5Button z:2];
        
        level5BeatAIAward = [CCSprite spriteWithFile:@"Trophy001.png"];
        level5BeatAIAward.position = ccp(412, 160);
        level5BeatAIAward.visible=NO;
        [self addChild:level5BeatAIAward z:2];
        
        level5TotalPointsAward = [CCSprite spriteWithFile:@"Coins001.png"];
        level5TotalPointsAward.position = ccp(412, 100);
        level5TotalPointsAward.visible=NO;
        [self addChild:level5TotalPointsAward z:2];
        
        level5LongWordAward = [CCSprite spriteWithFile:@"Book002.png"];
        level5LongWordAward.position = ccp(412, 50);
        level5LongWordAward.visible=NO;
        [self addChild:level5LongWordAward z:2];
        
        //Back Button
        backButton = [CCSprite spriteWithFile:@"Button_Back001.png"];
        backButton.position = ccp(450, 30);
        backButton.visible = NO;
        [self addChild:backButton z:2];
        
        //DISPLAY THE STAR LEVELS BASED ON THE VALUES IN THE PLIST
        [self displayStars:@"Level1" 
                lockSprite:nil
                BeatAIAwardSprite:level1BeatAIAward 
                TotalPointAwardSprite:level1TotalPointsAward 
                LongWordAwardSprite:level1LongWordAward];
        
        [self displayStars:@"Level2" 
                lockSprite:level2Button
                BeatAIAwardSprite:level2BeatAIAward 
                TotalPointAwardSprite:level2TotalPointsAward 
                LongWordAwardSprite:level2LongWordAward];

        [self displayStars:@"Level3"
                lockSprite:level3Button
                BeatAIAwardSprite:level3BeatAIAward 
                TotalPointAwardSprite:level3TotalPointsAward 
                LongWordAwardSprite:level3LongWordAward];

        [self displayStars:@"Level4"
                lockSprite:level4Button
                BeatAIAwardSprite:level4BeatAIAward 
                TotalPointAwardSprite:level4TotalPointsAward 
                LongWordAwardSprite:level4LongWordAward];

        [self displayStars:@"Level5"
                lockSprite:level5Button
                BeatAIAwardSprite:level5BeatAIAward 
                TotalPointAwardSprite:level5TotalPointsAward 
                LongWordAwardSprite:level5LongWordAward];

    }
    return self;
}

- (void) displayStars:(NSString *) levelName
            lockSprite:(CCSprite *) lockSprite
            BeatAIAwardSprite:(CCSprite *) beatAIAwardSprite
            TotalPointAwardSprite:(CCSprite *) totalPointAwardSprite
            LongWordAwardSprite:(CCSprite *) longWordAwardSprite
{
    //NSMutableDictionary *prevLevelInfo;
    
    NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] objectForKey:levelName];

    
    if (lockSprite) {
        if ([[levelInfo objectForKey:@"levelLocked"] boolValue]) {
            
            [lockSprite setOpacity:128];
            
            if([levelName isEqualToString:@"Level2"]) {
                level2Locked = TRUE;
            }
            else if([levelName isEqualToString:@"Level3"]) {
                level3Locked = TRUE;
            }
            else if([levelName isEqualToString:@"Level4"]) {
                level4Locked = TRUE;
            }
            else if([levelName isEqualToString:@"Level5"]) {
                level5Locked = TRUE;
            }
            
        }
        else{
            [lockSprite setOpacity:255];
        }
    }
    
    beatAIAwardSprite.visible = [[levelInfo objectForKey:@"beatAIAward"] boolValue];
    CCLOG(@"beatAIAwardSprite visible: %i", beatAIAwardSprite.visible);
    totalPointAwardSprite.visible = [[levelInfo objectForKey:@"totalPointsAward"] boolValue];
    longWordAwardSprite.visible = [[levelInfo objectForKey:@"longWordAward"] boolValue];


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
                                touchLocation) && !level2Locked){
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
                                touchLocation) && !level3Locked){
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
                                touchLocation) && !level4Locked){
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
                                touchLocation) && !level5Locked){
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
