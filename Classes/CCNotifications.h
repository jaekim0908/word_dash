//
//  CCNotifications.h
//  FullVersion
//
//  Created by Manuel Martinez-Almeida Castañeda on 21/03/10.
//  Copyright 2010 Manuel Martínez-Almeida. All rights reserved.
//	http://manucorporat.wordpress.com
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol CCNotificationsDelegate <NSObject>
- (void) notificationChangeState:(char)state tag:(int)tag;
- (BOOL) touched:(int)tag;
@end

@protocol CCNotificationsDesignProtocol <NSObject>
- (void) setTitle:(NSString*)title message:(NSString*)message texture:(CCTexture2D*)texture;
@end

enum {
	kCCNotificationStateHide,
	kCCNotificationStateAnimationOut,
	kCCNotificationStateShowing,
	kCCNotificationStateAnimationIn,
};

enum {
	kCCNotificationPositionBottom,
	kCCNotificationPositionTop,
};

enum {
	kCCNotificationAnimationMovement,
	kCCNotificationAnimationFade,
	kCCNotificationAnimationScale,
};

@interface CCNotificationDefaultDesign : CCColorLayer <CCNotificationsDesignProtocol>
{
	CCLabelTTF *title_;
	CCLabelTTF *message_;
	CCSprite *image_;
}

@end


@interface CCNotifications : NSObject <CCStandardTouchDelegate>
{
	id <CCNotificationsDelegate> delegate_;
	CCNode <CCNotificationsDesignProtocol> *notification;
	char state_;
	char position_;
	int	tag_;
	ccTime timeShowing_;
	ccTime timeAnimationIn_;
	ccTime timeAnimationOut_;
	char typeAnimationIn_;
	char typeAnimationOut_;
	BOOL animated_;
	
	CCActionInterval *animationIn_;
	CCActionInterval *animationOut_;
	CCTimer *timer_;
}
@property(nonatomic, retain) id <CCNotificationsDelegate> delegate;
@property(nonatomic, retain) CCActionInterval *animationIn;
@property(nonatomic, retain) CCActionInterval *animationOut;
@property(nonatomic, readwrite, assign) char state;

+ (CCNotifications *) sharedManager;
+ (void) purgeSharedManager;
- (void) setAnimationIn:(char)type time:(ccTime)time;
- (void) setAnimationOut:(char)type time:(ccTime)time;
- (void) setAnimation:(char)type time:(ccTime)time;
- (void) addNotificationTitle:(NSString*)title message:(NSString*)message texture:(CCTexture2D*)texture tag:(int)tag animate:(BOOL)animate;
- (void) addNotificationTitle:(NSString*)title message:(NSString*)message image:(NSString*)image tag:(int)tag animate:(BOOL)animate;
- (void) visit;
- (void) updateAnimations;
@end
