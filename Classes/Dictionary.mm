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
@synthesize dictionaryLoaded = _dictionaryLoaded;

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
        
        _dictionaryLoaded = NO;
		// Dictionary Initialized
		NSLog(@"Dictionary Singleton,, init");
        // JHK - 10/04/11 trying a new dictionary file (plurals removed and potty mouth filtered).
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"new_dictionary" ofType:@"txt"];
		NSError *error;
		// read everything from text
		NSString *fileContents = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error] retain];
		_allWords = (NSMutableArray *) [[fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] retain];
		_dictionary = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void) loadDictionary {
	if(_sharedDictionary && !_dictionaryLoaded) {
		for(NSString *s in [_sharedDictionary allWords]) {
			if (s && [s length] > 0) {
				[[_sharedDictionary dict] setObject:s forKey:s];
			}
		}
        _dictionaryLoaded=YES;
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
