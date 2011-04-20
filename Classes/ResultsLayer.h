//
//  ResultsLayer.h
//  HundredSeconds
//
//  Created by Michael Ho on 3/23/11.
//  Copyright 2011 self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ResultsLayer : CCLayerColor {
	CCLabelTTF *player1Score;
	CCLabelTTF *player2Score;
	CCSprite *rematchButton;
}

@property (nonatomic, retain) CCLabelTTF *player1Score;
@property (nonatomic, retain) CCLabelTTF *player2Score;
@property (nonatomic, retain) CCSprite *rematchButton;

-(id) initWithPlayerOneScore:(NSString *) p1Score WithPlayerTwoScore:(NSString *) p2Score WithPlayerOneWords:(NSMutableArray *) p1Words WithPlayerTwoWords:(NSMutableArray *) p2Words;

@end
