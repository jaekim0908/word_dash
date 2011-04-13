//
//  ResultsLayer.m
//  HundredSeconds
//
//  Created by Michael Ho on 3/23/11.
//  Copyright 2011 self. All rights reserved.
//

#import "ResultsLayer.h"

@implementation ResultsLayer

@synthesize player1Score;
@synthesize player2Score;

-(id) initWithPlayerOneScore:(NSString *) p1Score WithPlayerTwoScore:(NSString *) p2Score WithPlayerOneWords:(NSMutableArray *) p1Words WithPlayerTwoWords:(NSMutableArray *) p2Words 
{
	if( (self=[super initWithColor:ccc4(0, 0, 0, 225)] )) {
		NSLog(@"Inside results layer.");
		self.isTouchEnabled = YES;
		
		//PLAYER 1
		CCLabelTTF *player1Header = [[CCLabelTTF labelWithString:@"Player 1 Score"
										   fontName:@"Verdana" 
										   fontSize:18] retain];
		player1Header.color = ccc3(255,255,255);
		player1Header.position = ccp(360, 260);
		[self addChild:player1Header];
		
		player1Score = [[CCLabelTTF labelWithString:p1Score
										   fontName:@"Verdana" 
										   fontSize:37] 
						retain];
		player1Score.color = ccc3(255,255,255);
		player1Score.position = ccp(360, 220);
		[self addChild:player1Score];
		
		int y = 180;
		for (NSString *s in p1Words) {
			
			NSLog(@"Player 1 WORDS: %@",s );
			CCLabelTTF *wordLabel = [[CCLabelTTF labelWithString:s
														fontName:@"Verdana" 
														fontSize:12] retain];
			wordLabel.color = ccc3(255,255,255);
			wordLabel.position = ccp(345, y);
			wordLabel.anchorPoint = ccp(0,0);
			[self addChild:wordLabel];
			y = y - 14;
		}

		//PLAYER 2
		CCLabelTTF *player2Header = [[CCLabelTTF labelWithString:@"Player 2 Score"
														fontName:@"Verdana" 
														fontSize:18] retain];
		player2Header.color = ccc3(255,255,255);
		player2Header.position = ccp(100, 260);
		[self addChild:player2Header];
		
		player2Score = [[CCLabelTTF labelWithString:p2Score 
										   fontName:@"Verdana" 
										   fontSize:37] 
						retain];
		player2Score.color = ccc3(255,255,255);
		player2Score.position = ccp(100, 220);
		[self addChild:player2Score];
		
		y = 180;
		for (NSString *s in p2Words) {
			
			NSLog(@"Player 1 WORDS: %@",s );
			CCLabelTTF *wordLabel = [[CCLabelTTF labelWithString:s
														fontName:@"Verdana" 
														fontSize:12] retain];
			wordLabel.color = ccc3(255,255,255);
			wordLabel.position = ccp(85, y);
			wordLabel.anchorPoint = ccp(0,0);
			[self addChild:wordLabel];
			y = y - 14;
		}
		
		NSMutableString *winText = [NSMutableString string];
		if ([p1Score intValue] == [p2Score intValue]){
			[winText setString:@"Tie Game!"];
		}
		else if([p1Score intValue] > [p2Score intValue]){
			[winText setString:@"Player 1 Wins"];
		}
		else {
			[winText setString:@"Player 2 Wins"];
		}

		CCLabelTTF *midDisplay = [[CCLabelTTF labelWithString:winText 
													 fontName:@"MarkerFelt-Thin" 
													 fontSize:48] 
								  retain];
		midDisplay.position = ccp(240, 30);
		midDisplay.color = ccc3(255, 255, 255);
		[self addChild:midDisplay z:40];
				
		//NEXT: copy over mid display and list words for each player
		
	}
	return self;
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL) ccTouchBegan:(UITouch *) touch withEvent:(UIEvent *) event {
	
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
	
	
	return YES;
}

-(void) dealloc {
	CCLOG(@"ResultLayer dealloc called");
	[player1Score release];
	[player2Score release];
	[super dealloc];
}

@end
