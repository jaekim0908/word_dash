//
//  Cell.m
//  WordToo
//
//  Created by Jae Kim on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"


@implementation Cell

@synthesize letter = _letter;
@synthesize letterSprite = _letterSprite;
@synthesize letterBackground = _letterBackground;
@synthesize letterSelected = _letterSelected;
@synthesize letterSelected2 = _letterSelected2;
@synthesize value = _value;
@synthesize center = _center;
@synthesize owner = _owner;
@synthesize currentOwner = _currentOwner;
@synthesize redBackground = _redBackground;
@synthesize star = _star;

-(void) selectLetter {
    self.letterSelected.visible = YES;
}
-(void) unSelectLetter {
    self.letterSelected.visible = NO;
}

@end
