//
//  Chord.h
//  OTG-Chords
//
//  Created by Logan Moseley on 12/9/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Chord : NSObject {
	
	/* Loaded from file, unchanging */
	NSDictionary	*chordTypes;	// contains all chord types, which are arrays of set intervals, referenceable by name
	NSArray			*noteNames;		// (C2, C#2,..B4) to fill the array to return to delegate, which sends to DJ
	
	/* These change for each new chord */
	NSString		*chordType;		// contains the name of the instance chord
	NSArray			*chord;			// contains the NSUINTEGERS belonging to the chord.
	NSString		*rootName;		// holds the name of the name
	NSUInteger		inversions;		// holds number of inversions
	
	/*  chordType, chordName, and inversions are
		held for answer verification
	 */
}


@property (nonatomic, retain) NSDictionary *chordTypes;
@property (nonatomic, retain) NSArray *noteNames;

@property (nonatomic, retain) NSString *chordType;
@property (nonatomic, retain) NSArray *chord;
@property (nonatomic, retain) NSString *rootName;
@property (nonatomic) NSUInteger inversions;


#pragma mark -
#pragma mark Public

- (NSArray*)createChord;		// picks type, then inverts, then picks root
- (BOOL)verifyChordAnswer:(NSString*)_chordType;		// is _chordType the correct guess?
- (BOOL)verifyChordAnswer:(NSString*)_chordType andNumInversions:(NSUInteger)_inversions;
			// are _chordType and _inversions
			// the correct answers?

- (void)echo;


#pragma mark Private

- (NSArray*)chooseType;
- (NSArray*)chooseInversionForChord:(NSArray*)_chord;
- (NSArray*)chooseRootForChord:(NSArray*)_chord;
- (BOOL)canPlayChord:(NSArray*)_chord;



@end
