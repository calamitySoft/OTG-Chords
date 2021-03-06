//
//  MainViewController.h
//  OTG-Chords
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "Chord.h"

@protocol ChordsApplicationDelegate;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	id <ChordsApplicationDelegate> delegate;
	
	IBOutlet UINavigationBar *scoreBar;
	IBOutlet UINavigationItem *scoreTextItem;
	
	IBOutlet UILabel *devHelpLabel;		// ** dev help ** //
	IBOutlet UIButton *printDiffBtn;	// ** dev help ** //
	
	IBOutlet UILabel *chordLabel;		// big "Listen" or "<chord>" label
	
	IBOutlet UIBarButtonItem *replayBarBtn;
	IBOutlet UIBarButtonItem *nextOrGiveUpBarBtn;
	IBOutlet UIBarButtonItem *doneBarBtn;
	
	IBOutlet UIButton *switchAnswerLeftBtn;
	IBOutlet UIButton *switchAnswerRightBtn;
	IBOutlet UILabel *currentAnswerLabel;
	IBOutlet UIButton *switchInversionsLeftBtn;
	IBOutlet UIButton *switchInversionsRightBtn;
	IBOutlet UILabel *currentInversionsLabel;
	// helps determine if we should switch questions
	NSArray *oldDifficulty;
	
	
	NSArray *chordStrings;
	NSUInteger chordPickerIndex;	// accompanies currentAnswerLabel. This is an int of the current chord answer.
									// NOTE:	chordPickerIndex is the index in the enabledChordsByName array.
									//			The index in relation to chordStrings (all chords) is figured
									//				immediately before submitting the answer.
	NSUInteger inversionPickerIndex;
}

@property (nonatomic, assign) <ChordsApplicationDelegate> delegate;
@property (nonatomic, retain) NSArray *oldDifficulty;
@property (nonatomic, retain) NSArray *chordStrings;
@property (nonatomic) NSUInteger chordPickerIndex;
@property (nonatomic) NSUInteger inversionPickerIndex;

- (IBAction)showSettings:(id)sender;		// flips to the settings view
- (IBAction)showInstructions:(id)sender;	// repops the instruction alert
- (IBAction)replayNote:(id)sender;			// replays the root note of the chord
- (IBAction)giveUp:(id)sender;				// displays the chord
- (IBAction)nextNote:(id)sender;			// tells delegate to generate another chord question
- (IBAction)submitAnswer:(id)sender;		// answers with the chord displayed
- (IBAction)separate:(id)sender;			// plays the notes seperately

/* Answer Picking */
//	Chords
- (IBAction)switchAnswerLeft:(id)sender;	// sets the user's tentative answer
- (IBAction)switchAnswerRight:(id)sender;	// sets the user's tentative answer
- (void)setOptionTextToChordIndex:(NSUInteger)chordIndex;	// wrapper for easy answer option setting
//	Inversions
- (IBAction)switchInversionsLeft:(id)sender;	// sets the user's tentative answer
- (IBAction)switchInversionsRight:(id)sender;	// sets the user's tentative answer
- (void)setInversionsTextToInversionIndex:(NSUInteger)inversionIndex;	// wrapper for easy answer option setting
//	Both
- (void)resetArrowVisibility;				// rechecks and sets answer picker arrows


- (void)displayChord:(NSString *)theInterval;	// sets the big label of MainView.xib
- (void)checkIsArpeggiatedForGiveUpBtn;				// makes the btn read "Separate" or "Together", whichever's correct and if it should
- (void) goToNextQuestion;							// goes to the next question. can be used from anywhere -- ex. nextNote:, flipsideViewControllerDidFinish:

- (IBAction)printDifficulty:(id)sender;

@end



@protocol ChordsApplicationDelegate

- (void)generateQuestion;
- (void)replayNote;
- (void)printDifficulty;
- (void)arpeggiate;
- (NSString *)getScoreString;
- (BOOL)submitAnswer:(NSString*)chordTypeGuessed;
- (BOOL)submitAnswer:(NSString*)chordTypeGuessed andNumInversions:(NSUInteger)inversionGuessed;


@property (nonatomic, retain) Chord *myChord;

@end