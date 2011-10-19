//
//  ResultPages.m
//  HundredSeconds
//
//  Created by Michael Ho on 8/15/11.
//  Copyright 2011 experiencesquad. All rights reserved.
//

#import "ResultPages.h"

/*
 1) Need winsize
 
 */
@implementation ResultPages

@synthesize pageWordsArrayStartIndex;
@synthesize maxWordsPerColumn;
@synthesize maxColumnsPerPlayer;
@synthesize winSize;
@synthesize numColumnsToDisplay;
@synthesize numWordsOnPage;
@synthesize player1Edge;
@synthesize player2Edge;
@synthesize pNumWordsInColumn;
@synthesize pColumnIndentFromLeftEdge;



#define MAX_LETTERS_PER_LINE 76.0f
#define MAX_LETTERS_PER_WORD 15.0f


- (id) init:(CGSize) windowSize{
    
    //ResultPages *pResultPages = [ResultPages alloc];
    self = [super init];
    self.maxWordsPerColumn = 11;
    //self.maxColumnsPerPlayer = (MAX_LETTERS_PER_LINE / 2) / MAX_LETTERS_PER_WORD;
    self.maxColumnsPerPlayer = 1;
    
    
    
    NSLog(@"maxColumnsPerPlayer:%i",self.maxColumnsPerPlayer);
    
    self.winSize = windowSize;
    self.player1Edge = (windowSize.width / 2);
    self.player2Edge = 0;
    NSLog(@"player1Edge:%f",self.player1Edge);
    
    return (self);
}

- (float) calcColumnIndentFromLeftEdge:(int)colNum forPlayer:(int)playerNum withLongestWordInColumn:(int)longestWordInColumn
{
    float colIndentFromLeftEdge;
    float previousColsIndent;
    float currentColIndentFromColEdge;
    float playerLineMargin;
    float playerEdge;
    
    //CALCULATE LINE MARGIN FOR PLAYER IN PIXELS
    playerLineMargin = ((( (MAX_LETTERS_PER_LINE / 2.0f) - (numColumnsToDisplay * MAX_LETTERS_PER_WORD) ) / 2.0f) / MAX_LETTERS_PER_LINE) * winSize.width;
    NSLog(@"playerLineMargin:%f",playerLineMargin);
    
    if(playerNum == 1)
    {
        playerEdge = player1Edge;
    }
    else
    {
        playerEdge = player2Edge;
    }
    
    previousColsIndent = ( ((colNum * MAX_LETTERS_PER_WORD) / MAX_LETTERS_PER_LINE) * winSize.width);
    currentColIndentFromColEdge = (((MAX_LETTERS_PER_WORD - longestWordInColumn) / 2) / MAX_LETTERS_PER_LINE) * winSize.width;
    colIndentFromLeftEdge = playerEdge + playerLineMargin + previousColsIndent + currentColIndentFromColEdge;
    
    //HARDCODE VALUES
    if(playerNum == 1)
    {
        colIndentFromLeftEdge = 340.0f;
    }
    else
    {
        colIndentFromLeftEdge = 145.0f;
    }

    return (colIndentFromLeftEdge);
    
}
- (int) calcLongestWordLengthInColumn:(NSMutableArray *)pWords forPageNum:(int)pageNum forColNum:(int)colNum forNumWordsInColumn:(int)numWordsInColumn
{
    int maxLen=0;
    int colWordsArrayStartIndex = (pageNum * maxWordsPerColumn * maxColumnsPerPlayer) + (colNum * maxWordsPerColumn);
    int colWordsArrayEndIndex = colWordsArrayStartIndex + numWordsInColumn;
    
    NSLog(@"wordsArrayStartIndex:%i",colWordsArrayStartIndex);
    NSLog(@"wordsArrayEndIndex:%i",colWordsArrayEndIndex);
    
    for (int i=colWordsArrayStartIndex;i<colWordsArrayEndIndex;i++)
    {
        NSString *pCurrentWord = [pWords objectAtIndex:i];
        int currentWordLength = [pCurrentWord length];
        
        if (currentWordLength > maxLen)
        {
            maxLen = currentWordLength;
        }
    }
    
    return (maxLen);
    
}
- (int) calcNumWordsInColumn:(int)colNum forNumWordsOnPage:(int) numWordsOnPage
{
    int numFullColumns;
    int numWordsInColumn;
    
    numFullColumns = numWordsOnPage / maxWordsPerColumn;
    if (colNum < numFullColumns )
    {
        numWordsInColumn = maxWordsPerColumn;
    }
    else
    {
        numWordsInColumn = numWordsOnPage % maxWordsPerColumn;
    }
    
    return (numWordsInColumn);

    
}

- (int) calcNumColumnsToDisplayOnPage:(int) numWordsOnPage
{
    int partialColumns=0;
    
    int numFullColumns = numWordsOnPage / maxWordsPerColumn;
    
    if (numWordsOnPage % maxWordsPerColumn > 0)
    {
        partialColumns = 1;
    }
    
    //return(numFullColumns + partialColumns);
    
    //MCH - always return 0 now
    return 1;
    
}


// 0 BASED PAGE NUMBERS
- (int) calcNumWordsToDisplayOnPage:(NSMutableArray *) pWords forPageNum:(int) pageNum
{
    
    if([pWords count] >= ((pageNum+1) * maxColumnsPerPlayer * maxWordsPerColumn)){
        return (maxColumnsPerPlayer * maxWordsPerColumn);
    }
    else
    {
        return ([pWords count] - (pageNum * maxColumnsPerPlayer * maxWordsPerColumn));
    }
        
    
}
- (int) getPageLayout:(NSMutableArray *) pWords forPlayer:(int) playerNum forPageNum:(int) pageNum
{
    
    /* NEXT: TEST AND PRINT OUT VARIABLES */
    /* NEXT: determine longest word for a given column to calculate columnMarginPositions 
     1) determine leftEnd of each column
     - if player 1 ...
     - take the remainder (mod) of max_letters_per_line / max_letters_per_word to determine playerLineMargins
     - if player 2 ...
     
     */
        
    
    pageWordsArrayStartIndex = (pageNum * maxWordsPerColumn * maxColumnsPerPlayer);
    
    //INDICATE IF THERE ARE NO MORE WORDS TO DISPLAY
    if ([pWords count] <= (pageNum * maxColumnsPerPlayer * maxWordsPerColumn)){
        return -1;
    }
    
    //GET THE NUMBER OF WORDS ON THE PAGE
    numWordsOnPage = [self calcNumWordsToDisplayOnPage:pWords forPageNum:pageNum];
    NSLog(@"numWordsOnPage:%i",numWordsOnPage);
    
    //GET THE NUMBER OF COLUMNS ON THE PAGE
    numColumnsToDisplay = [self calcNumColumnsToDisplayOnPage:numWordsOnPage];
    NSLog(@"numColumnsOnPage:%i",numColumnsToDisplay);
       
    pNumWordsInColumn = (int *)malloc(sizeof(int)*numColumnsToDisplay);
    pColumnIndentFromLeftEdge = (float *)malloc(sizeof(float)*numColumnsToDisplay);
    
    for(int i=0;i<numColumnsToDisplay;i++)
    {
        pNumWordsInColumn[i] = [self calcNumWordsInColumn:i forNumWordsOnPage:numWordsOnPage];
        NSLog(@"numWordsInColumn:%i",pNumWordsInColumn[i]);
        
        int longestWordInColumn = [self calcLongestWordLengthInColumn:pWords forPageNum:pageNum forColNum:i forNumWordsInColumn:pNumWordsInColumn[i]]; 
        NSLog(@"longestWordInColumn:%i",longestWordInColumn);
        
        pColumnIndentFromLeftEdge[i] = [self calcColumnIndentFromLeftEdge:i forPlayer:playerNum withLongestWordInColumn:longestWordInColumn];
        NSLog(@"columnIndentFromLeftEdge:%f",pColumnIndentFromLeftEdge[i]);
        
    }
        
        //calculateLongestWord
        
    return 0;
    
}
-(void) dealloc {
	
    free(pNumWordsInColumn);
    free(pColumnIndentFromLeftEdge);
	[super dealloc];
	NSLog(@"ResultPages dealloc end");
}


@end
