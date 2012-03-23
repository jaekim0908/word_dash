//
//  Multiplayer.h
//  HundredSeconds
//
//  Created by Jae Kim on 12/12/11.
//  Copyright (c) 2011 experiencesquad. All rights reserved.
//

#import "cocos2d.h"
#import <iAd/iAd.h>
#import "SimpleAudioEngine.h"
#import "WordGame.h"
#import "GCHelper.h"
#import "Constants.h"

@class Cell;
@class PauseMenu;

@interface Multiplayer : WordGame <GCHelperDelegate> {
    PauseMenu *pauseMenuPlayAndPass;
    BOOL      pauseState;
    
    BOOL myTurn;
    BOOL isPlayer1;        
    GameState gameState;
    uint32_t ourRandom;   
    BOOL receivedRandom;    
    NSString *otherPlayerID;
}

-(BOOL) stopTimer;
-(BOOL) startTimer;
-(void) setGameState:(GameState)state;
-(void) sendData:(NSData *)data;
-(void) sendRandomNumber;
-(void) sendGameBegin;
-(void) sendMove;
-(void) sendGameOver;
-(void) setupStringsWithOtherPlayerId:(NSString *)playerID;
-(void) setCellAtRow:(int) r Col:(int) c Value:(NSString *) v Visible:(BOOL) isVisible StartPoint:(BOOL) isThisStarPoint EndTurn:(BOOL) endTurn;
-(void) sendPlayer1Board;
-(void) sendStarPointAtRow:(int) r atCol:(int) c;
-(void) sendOpenCellAtRow:(int) r atCol:(int) c countScore:(BOOL) flag;
-(void) sendTimer;
-(void) sendCellSelectedAtRow:(int) r atCol:(int) c;
-(void) sendCellUnSelectedAtRow:(int) r atCol:(int)c;
-(void) sendTripleTabAtRow:(int) r atCol:(int) c;
-(void) sendCheckAnswer;
-(void) sendTileFlipCount:(int) cnt;
-(void) sendResetTileFlipCount;
-(void) sendEndTurn;
-(void) sendReadyToStartGame;
-(void) tryStartGame;
-(void) hideLetter:(id) sender;
-(void) endScene:(EndReason)endReason;
-(void) showGameDisconnectedAlert;
-(void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void) matchDisconnected;
-(void) checkAnswerNoPenalty;

@end