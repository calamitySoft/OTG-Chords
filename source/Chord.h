//
//  Chord.h
//  OTG-Chords
//
//  Created by Logan Moseley on 12/9/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Chord : NSObject {
	
	/* Proposed */
	// Only have chordTypes.
	NSDictionary	*chordTypes;	// contains all chord types, which are arrays of set intervals, referenceable by name

	NSArray			*noteNames;		// Basically just the array we previously had in the delegate
	NSString		*chordName;		// contains the name of the instance chord
	NSArray			*noteMembers;	// contains the note names belonging to this chord, this is what we will send to the DJ.
	NSUInteger		inversions;		// holds number of inversions
}


@property (nonatomic, retain) NSDictionary *chordTypes;
@property (nonatomic, retain) NSArray *noteNames;
@property (nonatomic, retain) NSString *chordName;
@property (nonatomic, retain) NSArray *noteMembers;



#pragma mark -
#pragma mark Proposed

/* Proposed */
+ (NSArray*)getChordWithRoot:(NSUInteger)root ofType:(NSString*)type withNumInversions:(NSUInteger)numInversions;
//	This will create the chord we want, including inversions.
//	This can return  nil  if the chord cannot be created
//		(i.e. doesn't fit within the note ceiling).



#pragma mark -
#pragma mark Spec's Member Methods

- (NSArray*)createChord;		// picks root from noteNames >> derives noteMembers using chordTypes array, inverts if necessary
- (void)invert;		// inverts the chord in creasing the bottom note by an octave, moving it to the back of the array (why?)
- (NSArray*)deriveNotesFrom:(NSUInteger)root;	//	root >> create chord array >> return array
- (NSUInteger)selectNextRootToFitUnder:(NSUInteger)size;	// check that the chord will fit without exceeding our note ceiling



@end
