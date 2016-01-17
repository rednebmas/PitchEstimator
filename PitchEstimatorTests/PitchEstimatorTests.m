//
//  PitchEstimatorTests.m
//  PitchEstimatorTests
//
//  Created by Sam Bender on 12/24/15.
//  Copyright © 2015 Sam Bender. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SBNote.h"
#import "SBMath.h"

@interface PitchEstimatorTests : XCTestCase

@end

@implementation PitchEstimatorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/**
 * Tests that frequency to note name is correct
 */
- (void)testSBNoteFrequencyToNote {
    SBNote *a4 = [[SBNote alloc] initWithFrequency:440.00];
    XCTAssert([a4.nameWithOctave isEqualToString:@"A4"], @"A4");
    
    SBNote *a3 = [[SBNote alloc] initWithFrequency:220.00];
    XCTAssert([a3.nameWithOctave isEqualToString:@"A3"], @"A3");
    
    SBNote *c3 = [[SBNote alloc] initWithFrequency:130.813];
    XCTAssert([c3.nameWithOctave isEqualToString:@"C3"], @"C3");
    
    SBNote *c4 = [[SBNote alloc] initWithFrequency:261.62];
    XCTAssert([c4.nameWithOctave isEqualToString:@"C4"], @"C4");
    
    SBNote *b1 = [[SBNote alloc] initWithFrequency:61.73];
    XCTAssert([b1.nameWithOctave isEqualToString:@"B1"], @"B1");
    
    SBNote *b2 = [[SBNote alloc] initWithFrequency:123.47];
    XCTAssert([b2.nameWithOctave isEqualToString:@"B2"], @"B2");
    
    SBNote *b3 = [[SBNote alloc] initWithFrequency:246.94];
    XCTAssert([b3.nameWithOctave isEqualToString:@"B3"], @"B3");
    
    SBNote *b4 = [[SBNote alloc] initWithFrequency:493.88];
    XCTAssert([b4.nameWithOctave isEqualToString:@"B4"], @"B4");
}

- (void)testSBNoteNoteToFrequency
{
    SBNote *a4 = [[SBNote alloc] initWithName:@"A4"];
    XCTAssert(a4.frequency == 440.00, @"A4 %f", a4.frequency);
    
    SBNote *c3 = [[SBNote alloc] initWithName:@"C3"];
    XCTAssert([SBMath value:c3.frequency withinTolerance:.01 ofProjected:130.8126], @"C3");
    
    SBNote *cs2 = [[SBNote alloc] initWithName:@"C#2"];
    XCTAssert([SBMath value:cs2.frequency withinTolerance:.01 ofProjected:69.29], @"C#2");
    
    SBNote *gb7 = [[SBNote alloc] initWithName:@"Gb7"];
    XCTAssert([SBMath value:gb7.frequency withinTolerance:.01 ofProjected:2959.95], @"C#2");
}

@end
