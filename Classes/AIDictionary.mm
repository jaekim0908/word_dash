//
//  Dictionary.mm
//  HundredSeconds
//
//  Created by Jae Kim on 3/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AIDictionary.h"
#import "GameManager.h"
#import "Dictionary.h"


@implementation AIDictionary

@synthesize allWords = _allWords;
@synthesize dict = _dictionary;

static AIDictionary* _sharedDictionary = nil;

+(AIDictionary*) sharedDictionary {
	@synchronized([AIDictionary class]) {
		if (!_sharedDictionary) {
			[[self alloc] init];
			return _sharedDictionary;
		}
		return _sharedDictionary;
	}
}

+(id) alloc {
	@synchronized ([AIDictionary class]) {
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
        
        /*******
        int currentLevel = [GameManager sharedGameManager].singlePlayerLevel;
        NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] 
                                          objectForKey:[NSString stringWithFormat:@"Level%i",currentLevel]];
        NSString *dictionaryFilename = [levelInfo objectForKey:@"AIDictionaryFilename"];

        NSString *filePath;
        
        if (!dictionaryFilename) {
            NSLog(@"WARNING: Path for dictionary file not found.");
            filePath = [[NSBundle mainBundle] pathForResource:@"ai-dictionary-1-8-grades" ofType:@"txt"];
        }
        else{
            filePath = [[NSBundle mainBundle] pathForResource:dictionaryFilename ofType:@"txt"];
        }
        
		NSError *error;
		// read everything from text
		NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
		_allWords = (NSMutableArray *) [[fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] retain];
         *********/
		_dictionary = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(NSMutableArray *) loadAllWords{
    
    if(_sharedDictionary) {
        int currentLevel = [GameManager sharedGameManager].singlePlayerLevel;
        NSMutableDictionary *levelInfo = [ [[GameManager sharedGameManager] getGameLevelDictionary] 
                                          objectForKey:[NSString stringWithFormat:@"Level%i",currentLevel]];
        NSString *dictionaryFilename = [levelInfo objectForKey:@"AIDictionaryFilename"];
        
        NSString *filePath;
        
        if (!dictionaryFilename) {
            NSLog(@"WARNING: Path for dictionary file not found.");
            filePath = [[NSBundle mainBundle] pathForResource:@"ai-dictionary-1-8-grades" ofType:@"txt"];
        }
        //LOAD THE LARGE DICTIONARY FROM ALL WORDS OF DICTIONARY CLASS TO SAVE LOADING FROM FILE
        //MCH -- LOOK INTO THIS, LOGIC SEEMS FLAWED
        else if([dictionaryFilename isEqualToString:@"new_dictionary_no_acronym"]){
            self.allWords = [[Dictionary sharedDictionary] allWords];
            return self.allWords;
        }
        else{
            filePath = [[NSBundle mainBundle] pathForResource:dictionaryFilename ofType:@"txt"];
        }
        
        NSLog(@"filePath=%@",filePath);
    
        NSError *error;
        // read everything from text
        NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        self.allWords = (NSMutableArray *) [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        NSLog(@"NUMBER OF WORDS in allWords:%i",self.allWords.count);
        
        
        
    }
    return self.allWords;
    
  }

-(void) loadDictionary {
	if(_sharedDictionary) {
		for(NSString *s in [_sharedDictionary allWords]) {
			if (s && [s length] > 0) {
				[[_sharedDictionary dict] setObject:s forKey:s];
			}
		}
		NSLog(@"Load AIDictionary Done");
	}
}

-(void) dealloc {
	NSLog(@"AIDictionary dealloc");
	[_allWords release];
	[_dictionary release];
	[_sharedDictionary release];
	_allWords = nil;
	_dictionary = nil;
	_sharedDictionary = nil;
	[super dealloc];
}

@end

