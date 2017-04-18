//
//  Shiny_SketchTests.m
//  Shiny SketchTests
//
//  Created by Matteo Rattotti on 14/04/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SFSketchGeometryUtils.h"

@interface Shiny_SketchTests : XCTestCase

@end

@implementation Shiny_SketchTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {

    CGFloat distance = [SFSketchGeometryUtils perpendicularDistanceFromPoint:CGPointMake(1, 0) linePointA:CGPointMake(0, 0) linePointB:CGPointMake(0, 1)];
    
    XCTAssertEqual(distance, 1);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
