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
#define HALF_STEPS_AWAY_FROM_A4_TO_NOTE_IN_4TH_OCTAVE @[@0, @2, @-9, @-7, @-5, @-4, @-2]
#define SAMPLE_RATE 44100.0f

@interface SBNote()

@property (nonatomic, readwrite) double frequency;
@property (nonatomic, readwrite) double centsOff;
@property (nonatomic, retain, readwrite) NSString *nameWithOctave;

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
    
    NSArray *noteNames = @[@"C" , @"C#", @"D" , @"D#" , @"E" , @"F" , @"F#", @"G" , @"G#" , @"A" , @"A#" , @"B"];
    
    self.centsOff = centDiff - noteDiff * 100;
    double noteNumber = noteDiff + 9 + 12 * 4;
    int octaveNumber = (int)floor((noteNumber)/12);
    int place = (int)fmod(noteNumber, 12) + 1;
    
    self.nameWithOctave = [NSString stringWithFormat:@"%@%d", noteNames[place - 1], octaveNumber];
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


@end
