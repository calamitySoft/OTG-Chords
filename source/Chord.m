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
	
	
	NSError *loadError;
	chordTypes = (NSDictionary*) [LoadFromFile objectForKey:@"ChordConstructions" error:&loadError];
	if (!chordTypes) {
		NSLog(@"(Chord) Error in loading chord constructions:%@", [loadError domain]);
		return nil;
	}
	
	
	/*** Initialize noteNames ***/
	// I would really like to read from a file.
	// We'll change it soon if still necessary.
	NSArray *tempNoteNames = [[NSArray alloc] initWithObjects:@"C",@"C#",@"D",@"D#",@"E",@"F",@"F#",@"G",@"G#",@"A",@"A#",@"B",nil];
	NSArray *tempNoteOctaves = [[NSArray alloc] initWithObjects:@"2",@"3",@"4",nil];
	NSMutableArray *tempNoteStrings = [[NSMutableArray alloc] initWithCapacity:1];
	for (NSUInteger i = 0; i < [tempNoteOctaves count]; i++) {
		for (NSUInteger k = 0; k < [tempNoteNames count]; k++) {
			NSString *tempStr = [[NSString alloc] initWithString:[[tempNoteNames objectAtIndex:k] stringByAppendingString:[tempNoteOctaves objectAtIndex:i]]];
			[tempNoteStrings addObject:tempStr];
		}
	}
	[self setNoteNames:(NSArray*)tempNoteStrings];
	[tempNoteStrings release];
	[tempNoteNames release];
	[tempNoteOctaves release];
	
	
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
#pragma mark Proposed


+ (NSArray*)getChordWithRoot:(NSUInteger)root ofType:(NSString*)type withNumInversions:(NSUInteger)numInversions {
	return nil;
}




#pragma mark -
#pragma mark Spec's Member Methods


// picks root from noteNames >> derives noteMembers using chordTypes array, inverts if necessary
- (NSArray*)createChord {
	return nil;
}



// inverts the chord in creasing the bottom note by an octave, moving it to the back of the array (why?)
- (void)invert {
}



//	root >> create chord array >> return array
- (NSArray*)deriveNotesFrom:(NSUInteger)root {
	return nil;
}



// check that the chord will fit without exceeding our note ceiling
- (NSUInteger)selectNextRootToFitUnder:(NSUInteger)size {
	return 0;
}




@end
