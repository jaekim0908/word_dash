//
//  HelloWorldLayer.h
//  WordMatrix
//
//  Created by Jae Kim on 1/25/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import <iAd/iAd.h>
#import "OpenFeint.h"
#import "OFMultiplayerDelegate.h"

@class Cell;

// HelloWorld Layer
@interface HelloWorld : CCLayer <ADBannerViewDelegate,  OpenFeintDelegate, OFMultiplayerDelegate>
{
	ADBannerView *adView;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
- (void) createLetterSlots:(int) rows columns:(int) cols firstGame:(BOOL) firstGameFlag;
- (void) createDictionary;
- (void) updateAnswer;
- (void) checkAnswer;
- (void) switchTo:(int) player countFlip:(BOOL) flag;
- (void) clearAllSelectedLetters;
- (void) clearLetters;
- (void) updateCellOwnerTo:(int) playerId;
- (void) addScore:(int) point toPlayer:(int) playerId anchorCell:(Cell *) cell;
- (void) openRandomLetters:(int) n;
- (BOOL) isThisStarPoint:(Cell *) cell;
- (void) setStarPoints;
- (int) countStarPointandRemoveStars;

@end
