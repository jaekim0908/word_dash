//
//  Parse.h
//  Parse
//
//  Created by Ilya Sukhar on 9/29/11.
//  Copyright 2011 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFConstants.h"
#import "PFObject.h"
#import "PFPointer.h"
#import "PFPush.h"
#import "PFQuery.h"
#import "PF_FBConnect.h"
#import "PFUser.h"
#import "PFFile.h"


@interface Parse : NSObject

+ (void)setApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey;
+ (void)setFacebookApplicationId:(NSString *)applicationId;
+ (BOOL)hasFacebookApplicationId;

+ (NSString *)getApplicationId;
+ (NSString *)getClientKey;
+ (NSString *)getFacebookApplicationId;

@end