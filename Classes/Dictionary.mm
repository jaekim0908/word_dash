//
//  Dictionary.mm
//  HundredSeconds
//
//  Created by Jae Kim on 3/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Dictionary.h"


@implementation Dictionary

@synthesize allWords = _allWords;
@synthesize dict = _dictionary;

static Dictionary* _sharedDictionary = nil;

+(Dictionary*) sharedDictionary {
	@synchronized([Dictionary class]) {
		if (!_sharedDictionary) {
			[[self alloc] init];
			return _sharedDictionary;
		}
		return _sharedDictionary;
	}
}

+(id) alloc {
	@synchronized ([Dictionary class]) {
		NSAssert(_sharedDictionary == nil,
				 @"Attempted to allocated a second instance of the Dictionary singleton");
		_sharedDictionary = [super alloc];
		return _sharedDictionary;
	}
	return nil;
}

-(id) init {
	self = [super init];
	if ((self = [super init])) {
		// Dictionary Initialized
		NSLog(@"Dictionary Singleton,, init");
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"crab_plus_words_unique" ofType:@"txt"];
		NSError *error;
		// read everything from text
		NSString *fileContents = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error] retain];
		_allWords = [[fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] retain];
		_dictionary = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void) loadDictionary {
	if(_sharedDictionary) {
		for(NSString *s in [_sharedDictionary allWords]) {
			if (s && [s length] > 0) {
				[[_sharedDictionary dict] setObject:s forKey:s];
			}
		}
		NSLog(@"Load Dictionary Done");
	}
}

-(void) dealloc {
	NSLog(@"Dictionary dealloc");
	[_allWords release];
	[_dictionary release];
	[_sharedDictionary release];
	_allWords = nil;
	_dictionary = nil;
	_sharedDictionary = nil;
	[super dealloc];
}

@end
