//
//  SFSketchPoint.h
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 16/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SFSketchPointTypeStandard,
    SFSketchPointTypePredicted,
} SFSketchPointType;

@interface SFSketchPoint : NSObject

@property (nonatomic) NSUInteger sequenceIndex;
@property (nonatomic) SFSketchPointType type;
@property (nonatomic) CGPoint location;
@property (nonatomic) CGPoint preciseLocation;
@property (nonatomic) CGFloat force;
@property (nonatomic) CGFloat altitudeAngle;
@property (nonatomic) CGFloat azimuthAngle;

- (instancetype)initWithTouch:(UITouch *) touch sequenceIndex:(NSUInteger) sequenceIndex type:(SFSketchPointType) type;

- (CGPoint) locationPointUsingPreciseLocation: (BOOL) usingPreciseLocation;

@end
