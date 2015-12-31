//
//  PitchEstimator.h
//  PitchEstimator
//
//  Created by Sam Bender on 12/23/15.
//  Copyright © 2015 Sam Bender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EZAudio/EZAudio.h>
#import <PitchEstimator/SBNote.h>

//! Project version number for PitchEstimator.
FOUNDATION_EXPORT double PitchEstimatorVersionNumber;

//! Project version string for PitchEstimator.
FOUNDATION_EXPORT const unsigned char PitchEstimatorVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <PitchEstimator/PublicHeader.h>

//---------------------------------------------------------------------
// Pitch Estimator Class
//---------------------------------------------------------------------

@class Note;

@interface PitchEstimator : NSObject

@property (nonatomic, readonly) float loudness;
@property (nonatomic, readonly) float fundamentalFrequency;
@property (nonatomic, retain) Note *note;
@property (nonatomic, readonly) vDSP_Length fundamentalFrequencyIndex;
// delta frequency between bins
@property (nonatomic, readonly) float binSize;
@property (nonatomic) float *oneIfHarmonicOtherwiseZero;
@property (nonatomic, retain) NSString *debugString;

+ (float) loudness:(float**)buffer ofSize:(UInt32)size;

- (void) processAudioBuffer:(float**)buffer ofSize:(UInt32)size;
- (void) processFFT:(EZAudioFFTRolling*)fft withFFTData:(float*)fftData ofSize:(vDSP_Length)size;

@end
