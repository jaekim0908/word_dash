//
//  Util.h
//  HundredSeconds
//
//  Created by Jae Kim on 11/16/11.
//  Copyright (c) 2011 experiencesquad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject {
    
}

+ (NSString *) formatName:(NSString *) name withLimit:(int) cutOff;
+ (NSString *) trimName:(NSString *) name;

@end
