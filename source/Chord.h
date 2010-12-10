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
	NSUInteger		inversions;		// holds number of inversions
}


@property (nonatomic, retain) NSDictionary *chordTypes;
@property (nonatomic, retain) NSArray *noteNames;

@property (nonatomic, retain) NSString *chordType;
@property (nonatomic, retain) NSArray *chord;


#pragma mark -
#pragma mark Public

- (NSArray*)createChord;		// picks root from noteNames >> derives noteMembers using chordTypes array, inverts if necessary


#pragma mark Private

- (NSArray*)chooseType;
- (NSArray*)chooseInversionForChord:(NSArray*)chord;
- (NSArray*)chooseRootForChord:(NSArray*)chord;
- (BOOL)canPlayChord:(NSArray*)chord;



@end
