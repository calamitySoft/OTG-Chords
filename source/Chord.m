//
//  Chord.m
//  OTG-Chords
//
//  Created by Logan Moseley on 12/9/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "Chord.h"
#import "LoadFromFile.h"


@implementation Chord

@synthesize chordTypes, noteNames, chordType, chord;



#pragma mark -
#pragma mark Setup


- (id)init {
	self = [super init];
	if (!self)
		return nil;
	
	[chordTypes count];
	[noteNames count];
	
	return self;
}



- (void)dealloc {
	[chordTypes release];
	[noteNames release];
	[chordType release];
	[chord release];
	
	[super dealloc];
}



#pragma mark -
#pragma mark Public


// picks root from noteNames >> derives noteMembers using chordTypes array, inverts if necessary
- (NSArray*)createChord {
	
	return nil;
}



#pragma mark Private


- (NSArray*)chooseType {
	// Config.plist's ChordNames
	// match to ChordConstructions and return its array
	// (make it an array as ints)
	
	
	// Initialize chordNames from file
	NSError *loadError;
	NSArray *chordNames = (NSArray*) [LoadFromFile objectForKey:@"ChordNames" error:&loadError];
	if (!chordNames) {
		NSLog(@"(MainVC) Error in loading chord names: %@", [loadError domain]);
		return nil;
	}
	
	
	
	// Settings doesn't have the difficulties atm.
	// work a settings check in later
	
	
	
	// Choose a type
	NSUInteger randomIndex = arc4random() % [chordNames count];
	NSString *chosenType = [chordNames objectAtIndex:randomIndex];

	// Initialize chordConstructions from file
	NSDictionary *chordConstructions = (NSDictionary*) [LoadFromFile objectForKey:@"ChordNames" error:&loadError];
	if (!chordConstructions) {
		NSLog(@"(MainVC) Error in loading chord names: %@", [loadError domain]);
		return nil;
	}
	
	// Turn the array of strings into array of ints
	NSArray *chordAsStrings = [chordConstructions objectForKey:chosenType];
	NSMutableArray *chordAsInts = [[NSMutableArray alloc] initWithCapacity:[chordConstructions count]];
	for (NSString *str in chordAsStrings) {
		[chordAsInts addObject:[str intValue]];
	}
	
	// make chordAsInts an NSArray
	NSArray *retArray = [NSArray arrayWithArray:(NSArray*)chordAsInts];
	[chordAsInts release];
	
	return retArray;
}


- (NSArray*)chooseInversionForChord:(NSArray*)chord {
	// if inversions are allowed in Settings
	//
	// invert the chord by subtracting 12 from some numbers
	// we do this so that the root stays 0, which means we can get its chord name
	//		and allow/disallow based on Root settings
}


- (NSArray*)chooseRootForChord:(NSArray*)chord {
	// pick a root that works with the array we have so far
	// (includes type and inversions)
}


// check that the chord will fit without exceeding our note ceiling
- (BOOL)canPlayChord:(NSArray*)chord {
	NSEnumerator *e = [chord objectEnumerator];
	NSUInteger *position;
	while (position = [e nextObject]) {
		if (position >= [noteNames count])
			return FALSE;
	}
	
	return TRUE;
}



#pragma mark -
#pragma mark Accessor Methods


- (NSDictionary*)chordTypes {
	if (chordTypes == nil) {
		NSError *loadError;
		chordTypes = (NSDictionary*) [LoadFromFile objectForKey:@"ChordConstructions" error:&loadError];
		if (!chordTypes) {
			NSLog(@"(Chord) Error in loading chord constructions:%@", [loadError domain]);
		}
	}
	return chordTypes;
}


- (NSArray*)noteNames {
	if (noteNames == nil) {
		
		NSError *loadError;
		NSDictionary *noteNameDict = (NSDictionary*) [LoadFromFile objectForKey:@"NoteNames" error:&loadError];
		if (!noteNameDict) {
			NSLog(@"(Chord) Error in loading chord constructions:%@", [loadError domain]);
			return noteNames;
		}
		
		
		NSArray *notes = [NSArray arrayWithArray:[noteNameDict objectForKey:@"Notes"]];
		NSArray *octaves = [NSArray arrayWithArray:[noteNameDict objectForKey:@"Octaves"]];
		NSMutableArray *tempNoteStrings = [[NSMutableArray alloc] initWithCapacity:1];
		for (NSUInteger i = 0; i < [octaves count]; i++) {
			for (NSUInteger k = 0; k < [notes count]; k++) {
				NSString *tempStr = [[NSString alloc] initWithString:[[notes objectAtIndex:k] 
																	  stringByAppendingString:[octaves objectAtIndex:i]]];
				[tempNoteStrings addObject:tempStr];
			}
		}
		noteNames = [NSArray arrayWithArray:tempNoteStrings];
	}
	return noteNames;
}


@end
