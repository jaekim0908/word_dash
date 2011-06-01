//
//  Definition.h
//  HundredSeconds
//
//  Created by Michael Ho on 5/19/11.
//  Copyright 2011 experiencesquad. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Definition : NSObject {
        NSMutableArray *_allWords;
        NSMutableDictionary *_dictionary;
}
    
@property (nonatomic, retain) NSMutableArray *allWords;
    @property (nonatomic, retain) NSMutableDictionary *dict;
    
+(Definition*) sharedDefinition;
-(void) loadDefinition;
    
@end
