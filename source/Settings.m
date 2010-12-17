//
//  Settings.m
//  OTG-Chords
//
//  Created by Logan Moseley on 11/24/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "Settings.h"
#import "SynthesizeSingleton.h"
#import "LoadFromFile.h"

@implementation Settings

SYNTHESIZE_SINGLETON_FOR_CLASS(Settings);	// necessary for singelton-ness. DO NOT REMOVE.

@synthesize currentDifficulty, isArpeggiated, allowInversions, enabledRoot;


- (id)init {
	self.enabledChords = self.easyDifficulty;
	[self setIsArpeggiated:TRUE];
	[self setAllowInversions:NO];
	return self;
}

- (void)dealloc {
	[chordNames release];
	[enabledRoot release];
	[easyDifficulty release];
	[mediumDifficulty release];
	[hardDifficulty release];
	[customDifficulty release];
	
	[super dealloc];
}


#pragma mark -
#pragma mark Private Methods

- (NSArray*)loadDifficulty:(NSString*)_difficulty {
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	
	// read the _difficulty data from the plist
	NSString *thePath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
	NSDictionary *rawConfigDict = [NSDictionary dictionaryWithContentsOfFile:thePath];
	NSDictionary *difficultyDict = [NSDictionary dictionaryWithDictionary:[rawConfigDict objectForKey:_difficulty]];
	
	for (NSUInteger i=0; i<[self.chordNames count]; i++) {
		NSString *chordName = [self.chordNames objectAtIndex:i];
		Boolean isEnabled = [[difficultyDict valueForKey:chordName] boolValue];		
		[tempArray addObject:[NSNumber numberWithBool:isEnabled]];
	}
	
	
	return tempArray;
}

- (NSUInteger)numChordsEnabledInCustomDifficulty {
	NSUInteger numEnabled = 0;
	NSEnumerator *e = [customDifficulty objectEnumerator];
	NSNumber *obj;
	while (obj = [e nextObject]) {
		if ([obj boolValue]) {
			numEnabled++;
		}
	}
	
	return numEnabled;
}

#pragma mark -
#pragma mark Inter-file Methods

/*
 *	enabledChordsByName
 *
 *	Purpose:	Currently used in MainVC to show the correct answer options
 *	Returns:	NSArray of NSStrings -- ONLY the ones enabled.
 *				[enabledChordsByName count] should == [numChordsEnabled]
 */
- (NSArray*)enabledChordsByName {
	NSMutableArray *enabledChordNames = [[NSMutableArray alloc] init];
	for (NSUInteger i=0; i<[self.chordNames count] && i<[enabledChords count]; i++) {
		if ([[enabledChords objectAtIndex:i] boolValue]) {
			[enabledChordNames addObject:[self.chordNames objectAtIndex:i]];
		}
	}
	
	// there should always be at least one chord enabled
	// but this guards against 0 enabled anyway
	if ([enabledChordNames count]==0) {
		return nil;
	}
	
	[enabledChordNames autorelease];
	
	return (NSArray*)enabledChordNames;
}


/*
 *	numChordsEnabled
 *
 *	Purpose:	Exactly like the private numChordsEnabledInCustomDifficulty,
 *				except it's public and for current difficulty only.
 */
- (NSUInteger)numChordsEnabled {
	NSUInteger numEnabled = 0;
	NSEnumerator *e = [enabledChords objectEnumerator];
	NSNumber *obj;
	while (obj = [e nextObject]) {
		if ([obj boolValue]) {
			numEnabled++;
		}
	}
	
	return numEnabled;
}


- (BOOL)chordIsEnabled:(NSString*)_chordName {
	NSString *str;
	for (str in [self enabledChordsByName]) {
		if ([str isEqualToString:_chordName]) {
			return YES;
		}
	}
	return NO;
}


/*
 *	setCustomDifficultyAtIndex: toValue:
 *
 *	Purpose:	Allows other classes/views to change the settings one at a time.
 *	Arguments:	(NSUInteger)_index:	index of self.customDifficulty
 *				(BOOL)_value:		chord is ON/OFF
 *	Returns:	(BOOL):				1 if the change leaves >=1 chord enabled
 *									0 if there would be 0 chords enabled
 *										(the last chord is NOT disabled)
 */
- (BOOL)setCustomDifficultyAtIndex:(NSUInteger)_index toValue:(BOOL)_value {
	
	// If making the change would mean 0 chords enabled
	if (_value == FALSE && [self numChordsEnabledInCustomDifficulty] == 1) {
		return 0;
	}
	
	// All other situations should be acceptable
	else {
		NSNumber *tempValue = [[NSNumber alloc] initWithBool:_value];
		[self.customDifficulty replaceObjectAtIndex:_index withObject:tempValue];
		[tempValue release];
		return 1;
	}
}

- (char)getDifficulty {
	char *chars;
	[self.currentDifficulty characterAtIndex:0];
	NSLog(@"\t\t(Settings)\t\t%c", chars[0]);
	
	return chars[0];
}

- (NSUInteger)getDifficultyAsUInt {
	// easy
	if ([self.currentDifficulty isEqualToString:kEasyDifficulty]) {
		return 0;
	}
	
	// medium
	else if ([self.currentDifficulty isEqualToString:kMediumDifficulty]) {
		return 1;
	}
	
	// hard
	else if ([self.currentDifficulty isEqualToString:kHardDifficulty]) {
		return 2;
	}
	
	// custom
	else if ([self.currentDifficulty isEqualToString:kCustomDifficulty]) {
		return 3;
	}
	
	else {
		return 4;
	}
}

- (void)setDifficulty:(char)_difficulty {
	switch (_difficulty) {
		case 'e':
			[self setCurrentDifficulty:kEasyDifficulty];
			break;
		case 'm':
			[self setCurrentDifficulty:kMediumDifficulty];
			break;
		case 'h':
			[self setCurrentDifficulty:kHardDifficulty];
			break;
		case 'c':
			[self setCurrentDifficulty:kCustomDifficulty];
			break;
		default:
			break;
	}	
}

- (void)setDifficultyWithUInt:(NSUInteger)_difficulty {
	switch (_difficulty) {
		case 0:
			[self setCurrentDifficulty:kEasyDifficulty];
			break;
		case 1:
			[self setCurrentDifficulty:kMediumDifficulty];
			break;
		case 2:
			[self setCurrentDifficulty:kHardDifficulty];
			break;
		case 3:
			[self setCurrentDifficulty:kCustomDifficulty];
			break;
		default:
			break;
	}
}


#pragma mark -
#pragma mark Accessor Methods

/*
 *	lazy init of our vars
 */

- (NSArray*)chordNames {
	if (chordNames == nil) {
		NSString *thePath = [[NSBundle mainBundle]  pathForResource:@"Config" ofType:@"plist"];
		NSDictionary *rawConfigDict = [[NSDictionary alloc] initWithContentsOfFile:thePath];
		chordNames = [rawConfigDict objectForKey:@"ChordNames"];
	}
	return chordNames;
}

#pragma mark -

- (NSString*)enabledRoot {
	if (enabledRoot == nil) {
		NSString *temp = [[NSString alloc] initWithString:@"any"];
		[self setEnabledRoot:temp];
		[temp release];
	}
	return enabledRoot;
}

#pragma mark -

- (NSArray*)easyDifficulty {
	if (easyDifficulty == nil) {
		easyDifficulty = [self loadDifficulty:kEasyDifficulty];
	}
	return easyDifficulty;
}

- (NSArray*)mediumDifficulty {
	if (mediumDifficulty == nil) {
		mediumDifficulty = [self loadDifficulty:kMediumDifficulty];
	}
	return mediumDifficulty;
}

- (NSArray*)hardDifficulty {
	if (hardDifficulty == nil) {
		hardDifficulty = [self loadDifficulty:kHardDifficulty];
	}
	return hardDifficulty;
}

- (NSMutableArray*)customDifficulty {
    if (customDifficulty == nil) {
		customDifficulty = (NSMutableArray*) [self loadDifficulty:kCustomDifficulty];
    }
    return customDifficulty;	
}

- (void)setCustomDifficulty:(NSMutableArray *)_customDifficulty {
	self.customDifficulty = _customDifficulty;
}

- (NSString*)currentDifficulty {
	if (currentDifficulty == nil) {
		currentDifficulty = kEasyDifficulty;
	}
	return currentDifficulty;
}

- (void)setCurrentDifficulty:(NSString*)_difficulty {
	currentDifficulty = _difficulty;
	
	// easy
	if ([_difficulty isEqualToString:kEasyDifficulty]) {
		[self setEnabledChords:self.easyDifficulty];
	}
	
	// medium
	else if ([_difficulty isEqualToString:kMediumDifficulty]) {
		[self setEnabledChords:self.mediumDifficulty];
	}
	
	// hard
	else if ([_difficulty isEqualToString:kHardDifficulty]) {
		[self setEnabledChords:self.hardDifficulty];
	}
	
	// custom
	else if ([_difficulty isEqualToString:kCustomDifficulty]) {
		[self setEnabledChords:self.customDifficulty];
	}
	
	// default
	else {
		[self setEnabledChords:self.easyDifficulty];
	}
	
	NSLog(@"(Settings)Difficulty is now %@", currentDifficulty);
}

#pragma mark -

- (NSArray*)enabledChords {
	if (enabledChords == nil) {
		enabledChords = self.easyDifficulty;
	}
	return enabledChords;
}

- (void)setEnabledChords:(NSArray*)_enabledChords; {
	enabledChords = _enabledChords;
}



@end






