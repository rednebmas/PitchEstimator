//
//  PitchEstimatorTests.m
//  PitchEstimatorTests
//
//  Created by Sam Bender on 12/24/15.
//  Copyright © 2015 Sam Bender. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SBNote.h"

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
- (void)testSBNote {
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

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
