//
//  SinglePlayGameHistory.h
//  HundredSeconds
//
//  Created by Jae Kim on 11/2/11.
//  Copyright 2011 experiencesquad. All rights reserved.
//

#import "cocos2d.h"

@interface ScoreSummary : CCLayer {
    CCLabelTTF *titleRow;
    CCLabelTTF *playHistory;
    CCLabelTTF *previousHistory;
    CCLabelTTF *nextHistory;
    CCLabelTTF *noRecordFound;
    BOOL previousHistoryActive;
    BOOL nextHistoryActive;
    NSMutableArray *paginationMatrix;
    NSMutableArray *keysOrderByCreatedAt;
    NSMutableDictionary *gameScoreSummary;
    UIActivityIndicatorView *spinner;
}

+(id) scene;
- (void) createCurrentHistoryLabel:(int) page;
- (void) updatePagination;
- (void) displaySummaryatPage:(int) pageIdx from:(int) start toEnd:(int) end;
- (void) initPagination:(int) count;
- (void) goBackToMainMenu;

@end
