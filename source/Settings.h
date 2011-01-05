//
//  Settings.h
//  OTG-Chords
//
//  Created by Logan Moseley on 11/24/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kEasyDifficulty @"EasyDifficulty"
#define kMediumDifficulty @"MediumDifficulty"
#define kHardDifficulty @"HardDifficulty"
#define kCustomDifficulty @"CustomDifficulty"

typedef enum interval { unison, minSecond, majSecond, minThird, majThird, perFourth, tritone, 
	perFifth, minSixth, majSixth, minSeventh, majSeventh, octave} interval;


@interface Settings : NSObject {
	NSUserDefaults	*userDefaults;			// Saving user settings between sessions
	
	NSArray			*chordNames;			// NSArray of NSStrings (Major, Minor, Augmented, etc)
	NSArray			*inversionNames;		// NSArray of NSStrings ("First Inversion", etc)
	
	BOOL			isArpeggiated;			// True if we're arpeggiating as a base
	BOOL			allowInversions;		// YES if inversions are allowed
	
	NSString		*enabledRoot;			// "any" or "A", "A#", "B",...
	
	NSArray			*easyDifficulty;		// NSArray of NSNumbers
	NSArray			*mediumDifficulty;		// NSArray of NSNumbers
	NSArray			*hardDifficulty;		// NSArray of NSNumbers
	NSMutableArray	*customDifficulty;		// NSArray of NSNumbers
	NSString		*currentDifficulty;		// kEasyDifficulty, or kMediumDifficulty, etc
	
	NSArray			*enabledChords;			// always points to easyDifficulty, or mediumDifficulty, etc
	NSArray			*enabledInversions;		// like enabledChords; used in MainVC for answer picker
}

@property (nonatomic, retain) NSUserDefaults *userDefaults;

@property (nonatomic, retain, readonly) NSArray *chordNames;
@property (nonatomic, retain, readonly) NSArray *inversionNames;

@property (nonatomic) BOOL isArpeggiated;
@property (nonatomic) BOOL allowInversions;

@property (nonatomic, retain) NSString *enabledRoot;

@property (nonatomic, retain, readonly) NSArray *easyDifficulty;
@property (nonatomic, retain, readonly) NSArray *mediumDifficulty;
@property (nonatomic, retain, readonly) NSArray *hardDifficulty;
@property (nonatomic, retain) NSMutableArray *customDifficulty;
@property (nonatomic, retain) NSString *currentDifficulty;

@property (nonatomic, retain) NSArray *enabledChords;
@property (nonatomic, retain) NSArray *enabledInversions;



+ (Settings *)sharedSettings;	// necessary for singelton-ness. DO NOT REMOVE.

// Chord accessing
- (NSArray*)enabledChordsByName;	// currently used in MainVC to show the correct answer options
- (NSUInteger)numChordsEnabled;
- (BOOL)chordIsEnabled:(NSString*)_chordName;

// Inversions accessing
- (NSArray*)enabledInversionsByName;
- (NSUInteger)numInversionsEnabled;

// Change particulars of customDifficulty.
// Used in CustomDiffTableViewController.
- (BOOL)setCustomDifficultyAtIndex:(NSUInteger)_index toValue:(BOOL)_value;

- (char)getDifficulty;									// need this to easily get diff from other code. for now.
- (NSUInteger)getDifficultyAsUInt;						// need this to easily get diff from other code. for now.
- (void)setDifficulty:(char)_difficulty;				// need this to easily set diff from other code. for now.
- (void)setDifficultyWithUInt:(NSUInteger)_difficulty;	// need this to easily set diff from other code. for now.


@end
