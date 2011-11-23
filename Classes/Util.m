//
//  Util.m
//  HundredSeconds
//
//  Created by Jae Kim on 11/16/11.
//  Copyright (c) 2011 experiencesquad. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSString *) formatName:(NSString *) name withLimit:(int) cutOff {
    NSString *formattedName = @"";
    
    if (name) {
        formattedName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    if (cutOff <= 0) {
        cutOff = [formattedName length];
    }
    
    if ([formattedName length] > cutOff) {
        formattedName = [NSString stringWithFormat:@"%@...", [formattedName substringToIndex:--cutOff]];
    }
    
    return formattedName;
}

+ (NSString *) trimName:(NSString *) name {
    NSString *trimmedName = nil;
    if (name) {
        trimmedName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    return trimmedName;
}
@end
