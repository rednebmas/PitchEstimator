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

- (id) initWithFrequency:(double)frequency
{
    self = [self init];
    if (self)
    {
        self.frequency = frequency;
        [self setNotePropertiesForFrequency:frequency];
    }
    return self;
}

- (void) setNotePropertiesForFrequency:(float)frequency
{
    double centdif = floor(1200 * log(frequency / A4_FREQUENCY) / log(2));
    double notedif = floor(centdif / 100);
    
    if (fmod(centdif, 100) > 50)
    {
        notedif = notedif + 1;
    }
    
    NSArray *noteNames = @[@"C" , @"C#", @"D" , @"D#" , @"E" , @"F" , @"F#", @"G" , @"G#" , @"A" , @"A#" , @"B"];
    
    self.centsOff = centdif - notedif * 100;
    double notenumber = notedif + 9 + 12*4;
    int octavenumber = (int)floor((notenumber)/12);
    int place = (int)fmod(notenumber, 12) + 1;
    
    
    self.nameWithOctave = [NSString stringWithFormat:@"%@%d", noteNames[place], octavenumber];
}

@end
