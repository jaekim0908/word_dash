//
//  OFDelegate.h
//  HundredSeconds
//
//  Created by Jae Kim on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenFeintDelegate.h"
#import "OFUser.h"
#import "OFMultiplayer.h"
#import "OFMultiplayerGame.h"
#import "OFMultiplayerDelegate.h"
#import "OFFriendPickerController.h"
#import "ChallengeRequestDialog.h"

@interface MyOFDelegate : NSObject <OpenFeintDelegate, OFUserDelegate, OFMultiplayerDelegate, UIActionSheetDelegate, OFFriendPickerDelegate> {
	NSString *localPlayerName;
	NSString *challengerName;
	NSString *challengeeName;
}

@property (nonatomic, retain) NSString *localPlayerName;
@property (nonatomic, retain) NSString *challengerName;
@property (nonatomic, retain) NSString *challengeeName;

-(void) dashboardWillAppear;
-(void) dashboardDidAppear;
-(void) dashboardWillDisappear;
-(void) dashboardDidDisappear;
-(void) userLoggedIn:(NSString *)userId;
-(BOOL) showCustomOpenFeintApprovalScreen;
-(void) gameDidFinish:(OFMultiplayerGame *)game;
-(void) playerLeftGame:(unsigned int)playerNumber;
-(void) networkDidUpdateLobby;
-(void) networkFailureWithReason:(NSUInteger)reason;
-(BOOL) gameMoveReceived:(OFMultiplayerMove *)move;
-(void) handlePushRequestGame:(OFMultiplayerGame *)game options:(NSDictionary *)options;
-(void) gameLaunchedFromPushRequest:(OFMultiplayerGame *)game withOptions:(NSDictionary *)options;
-(void) gameRequestedFromPushRequest:(OFMultiplayerGame *)game withOptions:(NSDictionary *)options;
-(void) gameSlotDidBecomeEmpty:(OFMultiplayerGame *)game;
-(void) gameSlotDidBecomeActive:(OFMultiplayerGame *)game;
-(void) gameDidAdvanceTurnToPlayerNumber:(unsigned int)playerNumber;
-(void) showActionSheet;
-(void)pickerFinishedWithSelectedUser:(OFUser*)selectedUser;
-(void) closeMultiPlayerGame;

@end
