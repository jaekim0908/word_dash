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

@synthesize level1Button;
@synthesize level2Button;
@synthesize level3Button;
@synthesize level4Button;
@synthesize level5Button;
@synthesize level1BeatAIAward;
@synthesize level1TotalPointsAward;
@synthesize level1LongWordAward;



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
        

        
        //LEVEL ONE
        level1Button = [CCSprite spriteWithFile:@"blueSandDollar.png"];
        level1Button.position = ccp(40, 240);
        [self addChild:level1Button z:1];
        
        level1BeatAIAward = [CCSprite spriteWithFile:@"trophy15-23.png"];
        level1BeatAIAward.position = ccp(10, 200);
        level1BeatAIAward.visible=NO;
        [self addChild:level1BeatAIAward z:1];
        
        level1TotalPointsAward = [CCSprite spriteWithFile:@"coins-25-22.png"];
        level1TotalPointsAward.position = ccp(35, 200);
        level1TotalPointsAward.visible=NO;
        [self addChild:level1TotalPointsAward z:1];
        
        level1LongWordAward = [CCSprite spriteWithFile:@"dictionary-20-25.png"];
        level1LongWordAward.position = ccp(62, 200);
        level1LongWordAward.visible=NO;
        [self addChild:level1LongWordAward z:1];

        
        level2Button = [CCSprite spriteWithFile:@"blueSandDollar.png"];
        level2Button.position = ccp(140, 240);
        [self addChild:level2Button z:1];
        
        level3Button = [CCSprite spriteWithFile:@"blueSandDollar.png"];
        level3Button.position = ccp(240, 240);
        [self addChild:level3Button z:1];
        
        level4Button = [CCSprite spriteWithFile:@"blueSandDollar.png"];
        level4Button.position = ccp(340, 240);
        [self addChild:level4Button z:1];
        
        level5Button = [CCSprite spriteWithFile:@"blueSandDollar.png"];
        level5Button.position = ccp(440, 240);
        [self addChild:level5Button z:1];
        
        //DISPLAY THE STAR LEVELS BASED ON THE VALUES IN THE PLIST
        [self displayStars:@"Level1" 
                BeatAIAwardSprite:level1BeatAIAward 
                TotalPointAwardSprite:level1TotalPointsAward 
                LongWordAwardSprite:level1LongWordAward];

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

}
- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {
    
    CCLOG(@"Inside ccTouchBegan ...");
    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CCLOG(@"touchLocation x:%f",touchLocation.x);
    
    int batchSize;
    
    if(CGRectContainsPoint(level1Button.boundingBox,
                           touchLocation)){
        CCLOG(@"Level 1 Button PRESSED.");
        
        NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] objectForKey:@"Level1"];
        batchSize = [[levelInfo objectForKey:@"batchSize"] intValue];
        
        [[GameManager sharedGameManager] setSinglePlayerBatchSize:batchSize];
        [[GameManager sharedGameManager] setSinglePlayerLevel:kLevel1];
        [ [GameManager sharedGameManager] runSceneWithId:kSinglePlayerScene];
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
