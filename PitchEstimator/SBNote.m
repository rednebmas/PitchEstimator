//
//  SBNote.m
//  PitchEstimator
//
//  Created by Sam Bender on 12/24/15.
//  Copyright © 2015 Sam Bender. All rights reserved.
//

#import "SBNote.h"

#define A4_FREQUENCY 440.0f
#define TWO_TO_THE_ONE_OVER_TWELVE 1.059463094359f
// http://pianoandsynth.com/wp-content/uploads/2009/05/music-keyboard.gif
// based on noteNames constant
#define HALF_STEPS_AWAY_FROM_A4_TO_NOTE_IN_4TH_OCTAVE @[@-9, @-8, @-7, @-6, @-5, @-4, @-3, @-2, @-1, @0, @1, @2]
#define SAMPLE_RATE 44100.0f

@interface SBNote()

// public
@property (nonatomic, readwrite) double frequency;
@property (nonatomic, readwrite) double centsOff;
@property (nonatomic, retain, readwrite) NSString *nameWithOctave;
@property (nonatomic, retain, readwrite) NSString *nameWithoutOctave;

// private
@property (nonatomic) int halfStepsFromA4;

@end

@implementation SBNote

#pragma mark - Initialization

- (id) initWithFrequency:(double)frequency
{
    self = [self init];
    if (self)
    {
        self.frequency = frequency;
        [self frequencyToNote:frequency];
    }
    return self;
}

- (id) initWithName:(NSString*)name
{
    self = [self init];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Calculation methods

/**
 * Algorithm comes from a MATLAB script called freq2note
 */
- (void) frequencyToNote:(double)frequency
{
    if (frequency < 25.00)
    {
        return;
    }
    
    double centDiff = floor(1200 * log(frequency / A4_FREQUENCY) / log(2));
    double noteDiff = floor(centDiff / 100);
    
    double matlabModulus = centDiff - 100.0 * floor(centDiff / 100.0);
    if (matlabModulus > 50)
    {
        noteDiff = noteDiff + 1;
    }
    
    NSArray *noteNames = [SBNote noteNames];
    
    self.centsOff = centDiff - noteDiff * 100;
    double noteNumber = noteDiff + 9 + 12 * 4;
    int octave = (int)floor((noteNumber)/12);
    int place = (int)fmod(noteNumber, 12) + 1;
    
    self.nameWithOctave = [NSString stringWithFormat:@"%@%d", noteNames[place - 1], octave];
    self.nameWithoutOctave = [NSString stringWithFormat:@"%@", noteNames[place - 1]];
    
    self.halfStepsFromA4 = [SBNote halfStepsFromA4FromNameWithoutOctave:self.nameWithoutOctave
                                                              andOctave:octave];
    self.frequency = [SBNote frequencyForNoteWithHalfStepsFromA4:self.halfStepsFromA4];
}

/**
 * Only takes octaves from 0 - 9
 */
- (void) calculateFrequencyForNoteName:(NSString*)name
{
    //
    // parse out name and octave
    //
    NSMutableString *letterName = [[NSMutableString alloc] init];
    int octave = 0;
    for (int i = 0; i < name.length; i++)
    {
        unichar charAtIndex = [name characterAtIndex:i];
        // unichar is a typealias for short int
        // in unicode, A is 0x41 and Z is 0x5A
        if (charAtIndex >= 0x41 && charAtIndex < 0x5A)
        {
            [letterName appendFormat:@"%C", charAtIndex];
        }
        else
        {
            octave = [[NSString stringWithFormat:@"%C", charAtIndex] intValue];
            break;
        }
    }
    
    self.nameWithOctave = name;
    self.nameWithoutOctave = [NSString stringWithFormat:@"%@", letterName];

    self.halfStepsFromA4 = [SBNote halfStepsFromA4FromNameWithoutOctave:self.nameWithoutOctave
                                                              andOctave:octave];
    self.frequency = [SBNote frequencyForNoteWithHalfStepsFromA4:self.halfStepsFromA4];
}


#pragma mark - Misc

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@ - %f Hz (%@%f cents)",
            self.nameWithOctave,
            self.frequency,
            self.centsOff < 0 ? @"" : @"+",
            self.centsOff];
}

#pragma mark - Class methods

+ (NSArray*) noteNames
{
    static NSArray *_noteNames;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _noteNames = @[@"C", @"C#", @"D" , @"D#" , @"E" , @"F" , @"F#", @"G" , @"G#" , @"A" , @"A#" , @"B"];
    });
    return _noteNames;
}

+ (int) halfStepsFromA4FromNameWithoutOctave:(NSString*)nameWithoutOctave andOctave:(int)octave
{
    int indexOfNoteName = (int)[[SBNote noteNames] indexOfObject:nameWithoutOctave];
    int halfStepsFromA4 = [HALF_STEPS_AWAY_FROM_A4_TO_NOTE_IN_4TH_OCTAVE[indexOfNoteName] intValue] + 12 * (octave - 4);
    
    return halfStepsFromA4;
}

+ (double) frequencyForNoteWithHalfStepsFromA4:(int)halfStepsFromA4
{
    return A4_FREQUENCY * powf(TWO_TO_THE_ONE_OVER_TWELVE, halfStepsFromA4);
}

@end
