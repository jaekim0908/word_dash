//
//  ResultPages.h
//  HundredSeconds
//
//  Created by Michael Ho on 8/15/11.
//  Copyright 2011 experiencesquad. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResultPages : NSObject {
    int pageWordsArrayStartIndex;
    int maxWordsPerColumn;
    int maxColumnsPerPlayer;
    int numColumnsToDisplay;
    int numWordsOnPage;
    float player1Edge;
    float player2Edge;
    CGSize winSize;
    int *pNumWordsInColumn;
    float *pColumnIndentFromLeftEdge;
}

@property (nonatomic, assign) int pageWordsArrayStartIndex;
@property (nonatomic, assign) int maxWordsPerColumn;
@property (nonatomic, assign) int maxColumnsPerPlayer;
@property (nonatomic, assign) int numColumnsToDisplay;
@property (nonatomic, assign) int numWordsOnPage;
@property (nonatomic, assign) float player1Edge;
@property (nonatomic, assign) float player2Edge;
@property (nonatomic, assign) CGSize winSize;
@property (nonatomic, assign) int *pNumWordsInColumn;
@property (nonatomic, assign) float *pColumnIndentFromLeftEdge;



- (id) init:(CGSize) windowSize;
- (int) getPageLayout:(NSMutableArray *) pWords forPlayer:(int) playerNum forPageNum:(int) pageNum;
- (int) calcNumWordsToDisplayOnPage:(NSMutableArray *) pWords forPageNum:(int) pageNum;
- (int) calcNumColumnsToDisplayOnPage:(int) numWordsOnPage;
- (int) calcNumWordsInColumn:(int)colNum forNumWordsOnPage:(int) numWordsOnPage;
- (int) calcLongestWordLengthInColumn:(NSMutableArray *)pWords forPageNum:(int)pageNum forColNum:(int)colNum forNumWordsInColumn:(int)numWordsInColumn;

@end
