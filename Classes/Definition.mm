//
//  Definition.m
//  HundredSeconds
//
//  Created by Michael Ho on 5/19/11.
//  Copyright 2011 experiencesquad. All rights reserved.
//

#import "Definition.h"


@implementation Definition


@synthesize allWords = _allWords;
@synthesize dict = _dictionary;

static Definition* _sharedDefinition = nil;

+(Definition*) sharedDefinition {
	@synchronized([Definition class]) {
		if (!_sharedDefinition) {
			[[self alloc] init];
			return _sharedDefinition;
		}
		return _sharedDefinition;
	}
}

+(id) alloc {
	@synchronized ([Definition class]) {
		NSAssert(_sharedDefinition == nil,
				 @"Attempted to allocated a second instance of the Definition singleton");
		_sharedDefinition = [super alloc];
		return _sharedDefinition;
	}
	return nil;
}

-(id) init {
	self = [super init];
	if ((self = [super init])) {
		// Definition Initialized
		NSLog(@"Definition Singleton,, init");
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"definition" ofType:@"txt"];
		NSError *error;
		// read everything from text
		NSString *fileContents = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error] retain];
		_allWords = [[fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] retain];
		_dictionary = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void) loadDefinition {
	if(_sharedDefinition) {
		for(NSString *s in [_sharedDefinition allWords]) {
			if (s && [s length] > 0) {
                //MCH -- parse out the word and the definition
                NSArray *components = [s componentsSeparatedByString:@"|"];
                NSString *word = [components objectAtIndex:0];
                NSString *definition = [components objectAtIndex:1];
				[[_sharedDefinition dict] setObject:definition forKey:word];
			}
		}
		NSLog(@"Load Dictionary Done");
	}
}

-(void) dealloc {
	NSLog(@"Dictionary dealloc");
	[_allWords release];
	[_dictionary release];
	[_sharedDefinition release];
	_allWords = nil;
	_dictionary = nil;
	_sharedDefinition = nil;
	[super dealloc];
}

@end

