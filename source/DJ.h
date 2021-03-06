//
//  DJ.h
//  OTG-Chords
//
//  Created by Sam on 8/24/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface DJ : NSObject {

	NSArray			*noteNames;				// NSStrings (C2, C#2,..B4) to fill the NSArray
	NSArray			*noteStringsToPlay;		// If a series of notes to be played is entered, this is set to it
											// NSArray of NSStrings to play
	NSMutableArray	*noteObjectsToPlay;		// NSArray of Note objects to play
	NSMutableArray	*oldNoteObjectsToPlay;	// Allows the old Notes to stay alive for a while, sidestepping a crash (hack)
	NSUInteger		curNote;				// Keeps track of where in the notesToPlay array we are
	
//	NSIndexSet		*viableNotes;		// What was this for?
}


@property (nonatomic, retain) NSArray *noteNames;
@property (nonatomic, retain) NSArray *noteStringsToPlay;
@property (nonatomic, retain) NSMutableArray *noteObjectsToPlay;
@property (nonatomic, retain) NSMutableArray *oldNoteObjectsToPlay;
@property (nonatomic) NSUInteger curNote;
//@property (nonatomic, retain) NSIndexSet *viableNotes;


- (id)init;
- (void)playNote:(NSObject*)_note;				// plays 
- (BOOL)playNoteAtIndex:(NSUInteger)_index;		// plays from self.noteObjectsToPlay
- (BOOL)playNotes:(NSArray*)_notes isArpeggiated:(BOOL)isArpeggiated; 
		// Plays a series of notes by setting up a notification center
		// Accepts NSArray of either NSStrings or NSNumbers
- (void)playNextNote:(NSNotification *)note;
- (void)stop;	// Stops playing notes in sequence

- (void)echo; // Used to test if I exist.


@end
