//
//  Chord.m
//  OTG-Chords
//
//  Created by Logan Moseley on 12/9/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "Chord.h"
#import "Settings.h"
#import "LoadFromFile.h"


@implementation Chord

@synthesize chordTypes, noteNames, chordType, chord, inversions;

NSString *possibleType;
NSUInteger possibleInversions;


/*	A C-function used as the comparator for our call to 
	NSArray:sortedArrayUsingFunction below. (in chooseInversionForChord:)
 */
NSInteger intSort(id num1, id num2, void *context)
{
    int v1 = [num1 intValue];
    int v2 = [num2 intValue];
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}


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


/*
 *	-createChord
 *
 *	Strategy:	Picks root from noteNames >> derives noteMembers using chordTypes array, inverts if necessary.
 *	Returns:	nil			if the chord cannot be created
 *				(NSArray*)	the created chord in NSNumber format
 *							Example: Major 6/4, root of C4: {19, 24, 28}
 */
- (NSArray*)createChord {
	
	// Pick a chord type
	NSArray *chordShape = [self chooseType];
	if (!chordShape) {
		return nil;
	}
	
	// Pick and apply inversions
	chordShape = [self chooseInversionForChord:chordShape];
	
	// Pick and apply root
	NSArray *newChord = [self chooseRootForChord:chordShape];
	[self setChord:newChord];
	
	return self.chord;
}



#pragma mark Private

/*
 *	-chooseType
 *
 *	Returns:	(NSArray*) of NSNumbers representing the chord construction.
 *				Example: "Major" type: array {0, 4, 7}
 *	Strategy:	Get Config.plist's ChordNames.
 *				Match to ChordConstructions and return its array (as NSNumbers).
 */
- (NSArray*)chooseType {	
	
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
	possibleType = chosenType;
	
	
	// Turn the array of strings into array of ints
	NSArray *chordAsStrings = [self.chordTypes objectForKey:chosenType];
	NSMutableArray *chordAsInts = [[NSMutableArray alloc] initWithCapacity:[self.chordTypes count]];
	for (NSString *str in chordAsStrings) {
		[chordAsInts addObject:[NSNumber numberWithInteger:[str integerValue]]];
	}
	
	// make chordAsInts an NSArray
	NSArray *retArray = [NSArray arrayWithArray:(NSArray*)chordAsInts];
	[chordAsInts release];
	
	return retArray;
}


/*
 *	-chooseInversionForChord:
 *
 *	Arguments:	(NSArray*) of NSNumbers representing the chord construction.
 *				Example: "Major" type: array {0, 4, 7}
 *	Returns:	(NSArray*) of NSNumbers representing the inverted chord construction.
 *				Example: "Major 6/4": array {-5, 0, 4}
 *	Strategy:	Invert the chord by subtracting 12 from some numbers, then add 12
 *					to a note for each inversion, starting at the root.
 *				We do this so that the root stays 0, which means we can
 *					allow/disallow based on Root settings.
 */
- (NSArray*)chooseInversionForChord:(NSArray*)_chord {
	
	// if inversions aren't allowed, return given array
	if (![[Settings sharedSettings] allowInversions])
		return _chord;
	
	
	//
	// Choose num inversions
	//		rand % count-1 :: only invert fewer times than there are notes
	//		(count==3 ---> can't invert 3x, that would just be the original)
	//
	NSUInteger randomNumInversions = arc4random() % [_chord count]-1;
	possibleInversions = randomNumInversions;
	
	//
	// Invert the chord
	//		0 inversions is easy
	//		Phase 2 below, combined with rand%count-1 from above,
	//			ensures that the root always == 0
	//
	if (randomNumInversions == 0) {		// nothing to do
		return _chord;
	} else {
		/* Phase 1 */
		// subtract 12 from all, move them up from there
		NSEnumerator *e1 = [_chord objectEnumerator];
		NSNumber *num;
		while (num = [e1 nextObject]) {
			num = [NSNumber numberWithInteger:[num integerValue]-12];
		}
		
		/* Phase 2 */
		// add 12 to notes for each inversion, starting at the root
		NSEnumerator *e2 = [_chord objectEnumerator];
		while (randomNumInversions > 0) {
			NSNumber *num = [e2 nextObject];							// next from the front
			num = [NSNumber numberWithInteger:[num integerValue]+12];	// add 12
			randomNumInversions--;										// countdown
		}
	}
	
	//
	// Now "Major 6/4" _chord == {0, 4, -5}
	// Sort to be == {-5, 0, 4}
	//
	NSArray *sortedArray = [_chord sortedArrayUsingFunction:intSort context:NULL];
	
	return sortedArray;
}


/*
 *	-chooseRootForChord:
 *
 *	Arguement:	(NSArray*)	_chord includes type and inversions
 *				Example: "Major 6/4": array {-5, 0, 4}
 *	Returns:	(NSArray*) of NSNumbers representing the complete chord construction.
 *				Example: "Major 6/4" about C4: array {19, 24, 28}
 *	Strategy:	Get a new random root in uinteger form
 *					while that root is not enabled and
 *					while the new chord is not allowed (out of bounds)
 *
 */
- (NSArray*)chooseRootForChord:(NSArray*)_chord {
	
	NSUInteger randomRoot;
	NSMutableArray *possibleChord;
	do {
		randomRoot = arc4random() % [self.noteNames count];
		
		[possibleChord removeAllObjects];					// setup to try again
		NSEnumerator *e = [_chord objectEnumerator];		// make a chord to check
		NSNumber *num;
		while (num = [e nextObject]) {
			num = [NSNumber numberWithInteger:[num integerValue]+randomRoot];	// add randomRoot value
			[possibleChord addObject:num];
		}
	} while (![self canPlayChord:possibleChord]);
	
	NSArray *retArray = [NSArray arrayWithArray:possibleChord];
	[possibleChord release];
	
	return retArray;
}


/*
 *	-canPlayChord:
 *
 *	Purpose:	Check that the chord will fit without exceeding 
 *					our note ceiling or going below 0.
 */
- (BOOL)canPlayChord:(NSArray*)_chord {
	NSEnumerator *e = [_chord objectEnumerator];
	NSNumber *num;
	while (num = [e nextObject]) {
		if ([num integerValue] >= [noteNames count]  ||  [num integerValue] < 0)
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
