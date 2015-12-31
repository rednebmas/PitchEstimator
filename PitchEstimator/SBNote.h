//
//  SBNote.h
//  PitchEstimator
//
//  Created by Sam Bender on 12/24/15.
//  Copyright © 2015 Sam Bender. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBNote : NSObject

@property (nonatomic, readonly) double frequency;
@property (nonatomic, readonly) double centsOff;
@property (nonatomic, retain, readonly) NSString *nameWithOctave;

- (id) initWithFrequency:(double)frequency;

@end
