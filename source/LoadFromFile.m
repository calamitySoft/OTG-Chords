//
//  LoadFromFile.m
//  OTG-Chords
//
//  Created by Logan Moseley on 12/9/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "LoadFromFile.h"
#import "SynthesizeSingleton.h"

@implementation LoadFromFile

/*
- (id)init {
	return self;
}

- (void)dealloc {
	[super dealloc];
}
 */


+ (NSInteger)getObject:(NSObject**)object forKey:(NSString*)key {

	if (key==nil) {
		NSLog(@"(LoadFromFile) key == nil");
		return -1;
	}
	
	NSString *thePath = [[NSBundle mainBundle]  pathForResource:@"Config" ofType:@"plist"];
	NSDictionary *rawConfigDict = [[NSDictionary alloc] initWithContentsOfFile:thePath];
	*object = [rawConfigDict objectForKey:key];
	
	if (*object==nil) {
		NSLog(@"(LoadFromFile) key \"%@\" does not exist in Config.plist", key);
		return -2;
	} else {
		return 1;
	}
}


@end






