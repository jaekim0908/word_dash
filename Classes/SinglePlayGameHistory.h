//
//  SinglePlayGameHistory.h
//  HundredSeconds
//
//  Created by Jae Kim on 11/2/11.
//  Copyright 2011 experiencesquad. All rights reserved.
//

#import "cocos2d.h"

@interface SinglePlayGameHistory : CCLayer {
    CCLabelTTF *titleRow;
    CCLabelTTF *playHistory;
    CCLabelTTF *previousHistory;
    CCLabelTTF *nextHistory;
    BOOL previousHistoryActive;
    BOOL nextHistoryActive;
    NSMutableArray *paginationMatrix;
}

+(id) scene;
-(NSString *) stringRightPad:(NSString *) str length:(int) len;
- (void) createRowLabelWithName:(NSString *) name withScore:(NSString *) score withResult:(NSString *) result withWhen:(NSString *) when forRow:(int) row;
- (void) createCurrentHistoryLabel:(int) page;
- (void) updatePagination;

@end
