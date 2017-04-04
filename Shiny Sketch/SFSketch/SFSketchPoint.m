//
//  SFSketchPoint.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 16/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "SFSketchPoint.h"

@interface SFSketchPoint ()

@end

@implementation SFSketchPoint

- (instancetype)initWithTouch:(UITouch *) touch type:(SFSketchPointType) type;
{
    self = [super init];
    if (self) {
        UIView *view = touch.view;
        _type = type;
        _location = [touch locationInView:view];
        _preciseLocation = [touch preciseLocationInView:view];
        _force = (touch.type == UITouchTypeStylus || touch.force > 0) ? touch.force : 1;
        _altitudeAngle = touch.altitudeAngle;
        _azimuthAngle = [touch azimuthAngleInView:view];
    }
    return self;
}

- (CGPoint) locationPointUsingPreciseLocation: (BOOL) usingPreciseLocation
{
    return usingPreciseLocation ? self.preciseLocation : self.location;
}

@end
