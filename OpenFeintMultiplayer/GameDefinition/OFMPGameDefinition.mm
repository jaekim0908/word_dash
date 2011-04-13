////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// 
///  Copyright 2009 Aurora Feint, Inc.
/// 
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///  
///  	http://www.apache.org/licenses/LICENSE-2.0
///  	
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
/// 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "OFMPGameDefinition.h"
#import "OFResourceDataMap.h"

@implementation OFMPGameDefinition

@synthesize name, imageUrl, maxTurnLengthInSeconds;

#pragma mark Boilerplate

- (id)init
{
	self = [super init];
	if (self != nil)
	{
	}
	
	return self;
}

- (void)dealloc
{
	OFSafeRelease(name);
	OFSafeRelease(imageUrl);
	[super dealloc];
}

#pragma mark XML Data Field Setters

- (void)setName:(NSString*)value
{
	OFSafeRelease(name);
	name = [value retain];
}

- (void)setImageUrl:(NSString*)value
{
	OFSafeRelease(imageUrl);
	imageUrl = [value retain];
}

- (void)setMaxTurnLengthInSeconds:(NSString*)value
{
	maxTurnLengthInSeconds = [value floatValue];
}

#pragma mark OFResource Overrides

+ (OFResourceDataMap*)getDataMap
{
	static OFPointer<OFResourceDataMap> dataMap;
	
	if(dataMap.get() == NULL)
	{
		dataMap = new OFResourceDataMap;
		dataMap->addField(@"name", @selector(setName:), nil);
		dataMap->addField(@"image_url", @selector(setImageUrl:), nil);
		dataMap->addField(@"max_turn_seconds", @selector(setMaxTurnLengthInSeconds:), nil);
	}
	
	return dataMap.get();
}

+ (NSString*)getResourceName
{
	return @"multiplayer_game_definition";
}

@end
