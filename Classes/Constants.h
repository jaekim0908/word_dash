//
//  Constants.h
//  HundredSeconds
//
//  Created by Jae Kim on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	kInvalidScene = 0,
    kWordGameScene,
	kMainMenuScene,
	kLoadingScene,
	kIntroScene,
	kMutiPlayerScene,
	kPlayAndPassScene,
    kHowToPlayScene,
    kSinglePlayerScene,
    kSinglePlayHistoryScene,
    kSinglePlayLevelMenu,
    kScoreSummaryScene,
    kWordSummaryScene,
	kMaxScene
} SceneTypes;

typedef enum {
	kInvalidStatus = 0,
	kGameNone,
	kGameStarted,
	kGameFinished
} GameStatus;

/****
typedef enum {
	kLevel1 = 1,
	kLevel2,
	kLevel3,
	kLevel4,
    kLevel6,
	kLevel7,
	kLevel8,
	kLevel9,
    kLevel10
} SinglePlayerGameLevels;
******/

typedef enum {
	kSinglePlayer = 0,
	kPlayAndPass,
	kMultiplayer
} GameMode;


typedef enum {
    kMessageTypeRandomNumber = 0,
    kMessageTypeGameBegin,
    kMessageTypeMove,
    kMessageTypeBoard,
    kMessageTypeCell,
    kMessageTypePlayButtonPressed,
    kMessageTypeSetStarPoint,
    kMessageTypeOpenCell,
    kMessageTypeSendTimer,
    kMessageTypeCellSelected,
    kMessageTypeCellUnSelected,
    kMessageTypeTripleTab,
    kMessageTypeCheckAnswer,
    kMessageTypeSendTileFlipCount,
    kMessageTypeResetTileFlipCount,
    kMessageTypeSendEndTurn,
    kMessageTypeGameOver,
    kMessageTypeEndOfBoard,
    kMessageTypeReadyToStartGame
} MessageType;

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
    uint32_t randomNumber;
} MessageRandomNumber;

typedef struct {
    Message message;
} MessageGameBegin;

typedef struct {
    Message message;
} MessageMove;

typedef struct {
    Message message;
} MessageTimer;

typedef struct {
    Message message;
    int row;
    int col;
    char ch;
    BOOL isVisible;
    BOOL isStarPoint;
    BOOL endTurn;
    BOOL countScore;
} MessageCell;

typedef struct {
    Message message;
    BOOL player1Won;
} MessageGameOver;

typedef struct {
    Message message;
} MessageCheckAnswer;

typedef struct {
    Message message;
    int count;
} MessageSendTileFlipCount;

typedef struct {
    Message message;
} MessageResetTileFlipCount;

typedef struct {
    Message message;
} MessageSendEndTurn;

typedef struct {
    Message message;
} MessageEndOfBoard;

typedef struct {
    Message message;
} MessageReadyToStartGame;

typedef enum {
    kEndReasonWin,
    kEndReasonLose,
    kEndReasonDisconnect
} EndReason;

typedef enum {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
} GameState;
