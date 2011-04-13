//
//  DialogLayer.h
//  HundredSeconds
//
//  Created by Jae Kim on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DialogLayer : CCLayerColor {
	NSInvocation *callback;
}

-(id) initWithHeader:(NSString *)header andLine1:(NSString *)line1 andLine2:(NSString *)line2 andLine3:(NSString *)line3 target:(id)callbackObj selector:(SEL)selector;
-(void) okButtonPressed:(id) sender;

@end
