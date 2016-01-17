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
        [self calculateFrequencyForNoteName:name];
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
 * Does not support double flats or sharps
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
        // in unicode, A is 0x41 and G is 0x47
        // # is 0x23, b is 0x62
        // 0 is 0x30, 9 is 0x39
        if ((charAtIndex >= 0x41 && charAtIndex <= 0x47)
            || charAtIndex == 0x23
            || charAtIndex == 0x62)
        {
            [letterName appendFormat:@"%C", charAtIndex];
        }
        else if (charAtIndex >= 0x30 && charAtIndex <= 0x39)
        {
            octave = [[NSString stringWithFormat:@"%C", charAtIndex] intValue];
            break;
        }
        else
        {
            [NSException raise:@"Invalid character while parsing note name: %@" format:name];
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


+ (NSDictionary*) sharpToFlat
{
    static NSDictionary *_sharpToFlat;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharpToFlat = @{
                         @"Bb" : @"A#",
                         @"Eb" : @"D#",
                         @"Ab" : @"G#",
                         @"Db" : @"C#",
                         @"Gb" : @"F#",
                         @"Cb" : @"B",
                         @"Fb" : @"E"
                         };
    });
    return _sharpToFlat;
}

+ (int) halfStepsFromA4FromNameWithoutOctave:(NSString*)nameWithoutOctave andOctave:(int)octave
{
    // Note names need to not have enharmonics because we are using the index, so we must
    // check if the name without octave is a flat and convert it, otherwise index for object
    // will be not found.
    NSString *sharpToFlatConversion = [[self sharpToFlat] objectForKey:nameWithoutOctave];
    if (sharpToFlatConversion != nil)
    {
        nameWithoutOctave = sharpToFlatConversion;
    }
    
    int indexOfNoteName = (int)[[SBNote noteNames] indexOfObject:nameWithoutOctave];
    int halfStepsFromA4 = [HALF_STEPS_AWAY_FROM_A4_TO_NOTE_IN_4TH_OCTAVE[indexOfNoteName] intValue] + 12 * (octave - 4);
    
    return halfStepsFromA4;
}

+ (double) frequencyForNoteWithHalfStepsFromA4:(int)halfStepsFromA4
{
    return A4_FREQUENCY * powf(TWO_TO_THE_ONE_OVER_TWELVE, halfStepsFromA4);
}

@end
