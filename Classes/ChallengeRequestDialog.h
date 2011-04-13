//
//  DialogLayer.h
//  HundredSeconds
//
//  Created by Jae Kim on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ChallengeRequestDialog : CCLayerColor {
	NSInvocation *callback;
	UIActivityIndicatorView *spinner;
}

-(id) initWithActivityInd:(BOOL) actInd target:(id)callbackObj selector:(SEL)selector;
-(void) okButtonPressed:(id) sender;

@end
