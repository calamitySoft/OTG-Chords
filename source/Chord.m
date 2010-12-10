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

@synthesize chordTypes, noteNames, chordName, noteMembers;



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
	[chordName release];
	[noteMembers release];
	
	[super dealloc];
}



#pragma mark -
#pragma mark Public


// picks root from noteNames >> derives noteMembers using chordTypes array, inverts if necessary
- (NSArray*)createChord {
	
	return nil;
}


#pragma mark Private


//	root >> create chord array >> return array
- (NSArray*)deriveNotesFrom:(NSUInteger)root {
	return nil;
}


// inverts the chord by increasing the bottom note by an octave, moving it to the back of the array
- (void)invert {
}


// check that the chord will fit without exceeding our note ceiling
// I don't understand how this will do that.
- (NSUInteger)selectNextRootToFitUnder:(NSUInteger)size {
	return 0;
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


/* Proposed */
- (NSArray*)getChordWithRoot:(NSUInteger)root ofType:(NSString*)type withNumInversions:(NSUInteger)numInversions {
	return nil;
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
