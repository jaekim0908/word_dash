//
//  GKMatchmakerViewController-LandscapeOnly.m
//  CatRace
//
//  Created by Ray Wenderlich on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GKMatchmakerViewController-LandscapeOnly.h"

@implementation GKMatchmakerViewController (LandscapeOnly)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { 
    return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
}

@end
