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

@synthesize levelsMenu;

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

        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LevelsImageAssets.plist"];
        levelsBatchNode = [[CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"LevelsImageAssets.png"]] retain];
        [self addChild:levelsBatchNode z:3];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LevelsImageAssets1.plist"];
        levels1BatchNode = [[CCSpriteBatchNode batchNodeWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"LevelsImageAssets1.png"]] retain];
        [self addChild:levels1BatchNode z:2];
        
        level1Button = [CCMenuItemImage 
                         itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Level_001.png"] 
                         selectedSprite:[CCSprite spriteWithSpriteFrameName:@"Level_001.png"]
                         disabledSprite:[CCSprite spriteWithSpriteFrameName:@"Level_001_disabled.png"]
                         target:self
                         selector:@selector(level1ButtonPressed)];
        
        level1Button.position = ccp(39+25, 160); 
        
        //level1Button = [CCSprite spriteWithSpriteFrameName:@"Level_001.png"];
        //level1Button.position = ccp(39+25, 160);
        //[levelsBatchNode addChild:level1Button z:2];
        
        level2Button = [CCMenuItemImage 
                        itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Level_002.png"] 
                        selectedSprite:[CCSprite spriteWithSpriteFrameName:@"Level_002.png"]
                        disabledSprite:[CCSprite spriteWithSpriteFrameName:@"Level_002_disabled.png"] 
                        target:self
                        selector:@selector(level2ButtonPressed)];
        level2Button.position = ccp(151, 160); 
        
        //level2Button = [CCSprite spriteWithSpriteFrameName:@"Level_002.png"];
        //level2Button.position = ccp(151, 160);
        //[levelsBatchNode addChild:level2Button z:2];
        
        level3Button = [CCMenuItemImage
                        itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Level_003.png"] 
                        selectedSprite:[CCSprite spriteWithSpriteFrameName:@"Level_003.png"]
                        disabledSprite:[CCSprite spriteWithSpriteFrameName:@"Level_003_disabled.png"]
                        target:self
                        selector:@selector(level3ButtonPressed)];
        level3Button.position = ccp(239, 160); 

        //level3Button = [CCSprite spriteWithSpriteFrameName:@"Level_003.png"];
        //level3Button.position = ccp(239, 160);
        //[levelsBatchNode addChild:level3Button z:2];
        
        level4Button = [CCMenuItemImage
                        itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Level_004.png"] 
                        selectedSprite:[CCSprite spriteWithSpriteFrameName:@"Level_004.png"]
                        disabledSprite:[CCSprite spriteWithSpriteFrameName:@"Level_004_disabled.png"]
                        target:self
                        selector:@selector(level4ButtonPressed)];
        level4Button.position = ccp(339-14, 160); 
        
        //level4Button = [CCSprite spriteWithSpriteFrameName:@"Level_004.png"];
        //level4Button.position = ccp(339-14, 160);
        //[levelsBatchNode addChild:level4Button z:2];
        
        level5Button = [CCMenuItemImage
                        itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Level_005.png"] 
                        selectedSprite:[CCSprite spriteWithSpriteFrameName:@"Level_005.png"]
                        disabledSprite:[CCSprite spriteWithSpriteFrameName:@"Level_005_disabled.png"]
                        target:self
                        selector:@selector(level5ButtonPressed)];
        level5Button.position = ccp(439-27, 160); 

        //level5Button = [CCSprite spriteWithSpriteFrameName:@"Level_005.png"];
        //level5Button.position = ccp(439-27, 160);
        //[levelsBatchNode addChild:level5Button z:2];

        levelsMenu = [CCMenu menuWithItems:level1Button, level2Button, level3Button, level4Button, level5Button, nil];
        levelsMenu.position = CGPointZero;
        [self addChild:levelsMenu z:2];
        
        //LEVEL ONE
        level1BeatAIAward = [CCSprite spriteWithSpriteFrameName:@"Trophy001.png"];
        //level1BeatAIAward.position = ccp(10, 200);
        level1BeatAIAward.position = ccp(64, 160);
        level1BeatAIAward.visible=NO;
        [levelsBatchNode addChild:level1BeatAIAward z:3];
        
        level1TotalPointsAward = [CCSprite spriteWithSpriteFrameName:@"Coins001.png"];
        level1TotalPointsAward.position = ccp(64, 100);
        level1TotalPointsAward.visible=NO;
        [levelsBatchNode addChild:level1TotalPointsAward z:3];
        
        level1LongWordAward = [CCSprite spriteWithSpriteFrameName:@"Book002.png"];
        level1LongWordAward.position = ccp(64, 50);
        level1LongWordAward.visible=NO;
        [levelsBatchNode addChild:level1LongWordAward z:3];

        //LEVEL TWO
 
        
        level2BeatAIAward = [CCSprite spriteWithSpriteFrameName:@"Trophy001.png"];
        level2BeatAIAward.position = ccp(151, 160);
        level2BeatAIAward.visible=NO;
        [levelsBatchNode addChild:level2BeatAIAward z:3];
        
        level2TotalPointsAward = [CCSprite spriteWithSpriteFrameName:@"Coins001.png"];
        level2TotalPointsAward.position = ccp(151, 100);
        level2TotalPointsAward.visible=NO;
        [levelsBatchNode addChild:level2TotalPointsAward z:3];
        
        level2LongWordAward = [CCSprite spriteWithSpriteFrameName:@"Book002.png"];
        level2LongWordAward.position = ccp(151, 50);
        level2LongWordAward.visible=NO;
        [levelsBatchNode addChild:level2LongWordAward z:3];

        
        //LEVEL THREE


        
        level3BeatAIAward = [CCSprite spriteWithSpriteFrameName:@"Trophy001.png"];
        level3BeatAIAward.position = ccp(239, 160);
        level3BeatAIAward.visible=NO;
        [levelsBatchNode addChild:level3BeatAIAward z:3];
        
        level3TotalPointsAward = [CCSprite spriteWithSpriteFrameName:@"Coins001.png"];
        level3TotalPointsAward.position = ccp(239, 100);
        level3TotalPointsAward.visible=NO;
        [levelsBatchNode addChild:level3TotalPointsAward z:3];
        
        level3LongWordAward = [CCSprite spriteWithSpriteFrameName:@"Book002.png"];
        level3LongWordAward.position = ccp(239, 50);
        level3LongWordAward.visible=NO;
        [levelsBatchNode addChild:level3LongWordAward z:3];
        
        //LEVEL FOUR

 
        level4BeatAIAward = [CCSprite spriteWithSpriteFrameName:@"Trophy001.png"];
        level4BeatAIAward.position = ccp(325, 160);
        level4BeatAIAward.visible=NO;
        [levelsBatchNode addChild:level4BeatAIAward z:3];
        
        level4TotalPointsAward = [CCSprite spriteWithSpriteFrameName:@"Coins001.png"];
        level4TotalPointsAward.position = ccp(325, 100);
        level4TotalPointsAward.visible=NO;
        [levelsBatchNode addChild:level4TotalPointsAward z:3];
        
        level4LongWordAward = [CCSprite spriteWithSpriteFrameName:@"Book002.png"];
        level4LongWordAward.position = ccp(325, 50);
        level4LongWordAward.visible=NO;
        [levelsBatchNode addChild:level4LongWordAward z:3];
        
        //LEVEL FIVE

        
        level5BeatAIAward = [CCSprite spriteWithSpriteFrameName:@"Trophy001.png"];
        level5BeatAIAward.position = ccp(412, 160);
        level5BeatAIAward.visible=NO;
        [levelsBatchNode addChild:level5BeatAIAward z:3];
        
        level5TotalPointsAward = [CCSprite spriteWithSpriteFrameName:@"Coins001.png"];
        level5TotalPointsAward.position = ccp(412, 100);
        level5TotalPointsAward.visible=NO;
        [levelsBatchNode addChild:level5TotalPointsAward z:3];
        
        level5LongWordAward = [CCSprite spriteWithSpriteFrameName:@"Book002.png"];
        level5LongWordAward.position = ccp(412, 50);
        level5LongWordAward.visible=NO;
        [levelsBatchNode addChild:level5LongWordAward z:3];
        
        //Back Button
        backButton = [CCSprite spriteWithSpriteFrameName:@"Button_Back001.png"];
        backButton.position = ccp(450, 30);
        backButton.visible = NO;
        [levelsBatchNode addChild:backButton z:3];
        
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
            lockSprite:(CCMenuItem *) lockSprite
            BeatAIAwardSprite:(CCSprite *) beatAIAwardSprite
            TotalPointAwardSprite:(CCSprite *) totalPointAwardSprite
            LongWordAwardSprite:(CCSprite *) longWordAwardSprite
{
    //NSMutableDictionary *prevLevelInfo;
    
    NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] objectForKey:levelName];

    
    if (lockSprite) {
        if ([[levelInfo objectForKey:@"levelLocked"] boolValue]) {
            
            //[lockSprite setOpacity:255];
            [lockSprite setIsEnabled:FALSE];
            
            /*******
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
             ********/
            
        }
        else{
            //[lockSprite setOpacity:255];
            [lockSprite setIsEnabled:TRUE];
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

-(BOOL) level1ButtonPressed
{
    int batchSize, aiMaxWaitTime;
    
    CCLOG(@"Level 1 Button PRESSED.");
    
    NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] objectForKey:@"Level1"];
    batchSize = [[levelInfo objectForKey:@"batchSize"] intValue];
    aiMaxWaitTime = [[levelInfo objectForKey:@"AIMaxWaitTime"] intValue];
    
    [[GameManager sharedGameManager] setAiMaxWaitTime:aiMaxWaitTime];
    [[GameManager sharedGameManager] setSinglePlayerBatchSize:batchSize];
    [[GameManager sharedGameManager] setSinglePlayerLevel:1];
    [ [GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];

    return TRUE;
}

-(BOOL) level2ButtonPressed
{
    int batchSize, aiMaxWaitTime;
    //if (!level2Locked) {
        CCLOG(@"Level 2 Button PRESSED.");
        
        NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] objectForKey:@"Level2"];
        batchSize = [[levelInfo objectForKey:@"batchSize"] intValue];
        aiMaxWaitTime = [[levelInfo objectForKey:@"AIMaxWaitTime"] intValue];
        
        [[GameManager sharedGameManager] setAiMaxWaitTime:aiMaxWaitTime];
        [[GameManager sharedGameManager] setSinglePlayerBatchSize:batchSize];
        [[GameManager sharedGameManager] setSinglePlayerLevel:2];
        [ [GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];

    //}
    return TRUE;
}
-(BOOL) level3ButtonPressed
{
    int batchSize, aiMaxWaitTime;
    //if (!level3Locked) {
        CCLOG(@"Level 3 Button PRESSED.");
        
        NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] objectForKey:@"Level3"];
        batchSize = [[levelInfo objectForKey:@"batchSize"] intValue];
        aiMaxWaitTime = [[levelInfo objectForKey:@"AIMaxWaitTime"] intValue];
        
        [[GameManager sharedGameManager] setAiMaxWaitTime:aiMaxWaitTime];
        [[GameManager sharedGameManager] setSinglePlayerBatchSize:batchSize];
        [[GameManager sharedGameManager] setSinglePlayerLevel:3];
        [ [GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];
    //}
    return TRUE;
}
-(BOOL) level4ButtonPressed
{
    int batchSize, aiMaxWaitTime;
    //if (!level4Locked) {
        CCLOG(@"Level 4 Button PRESSED.");
        
        NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] objectForKey:@"Level4"];
        batchSize = [[levelInfo objectForKey:@"batchSize"] intValue];
        aiMaxWaitTime = [[levelInfo objectForKey:@"AIMaxWaitTime"] intValue];
        
        [[GameManager sharedGameManager] setAiMaxWaitTime:aiMaxWaitTime];
        [[GameManager sharedGameManager] setSinglePlayerBatchSize:batchSize];
        [[GameManager sharedGameManager] setSinglePlayerLevel:4];
        [ [GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];  
    //}
    return TRUE;
}
-(BOOL) level5ButtonPressed
{
    int batchSize, aiMaxWaitTime;
    //if (!level5Locked) {
        CCLOG(@"Level 5 Button PRESSED.");
        
        NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] objectForKey:@"Level5"];
        batchSize = [[levelInfo objectForKey:@"batchSize"] intValue];
        aiMaxWaitTime = [[levelInfo objectForKey:@"AIMaxWaitTime"] intValue];
        
        [[GameManager sharedGameManager] setAiMaxWaitTime:aiMaxWaitTime];
        [[GameManager sharedGameManager] setSinglePlayerBatchSize:batchSize];
        [[GameManager sharedGameManager] setSinglePlayerLevel:5];
        [ [GameManager sharedGameManager] runLoadingSceneWithTargetId:kSinglePlayerScene];
    //}
    return TRUE;
}

- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {
    
    /*************
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
    ************/
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
