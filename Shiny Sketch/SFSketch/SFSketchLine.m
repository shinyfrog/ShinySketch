//
//  SFSketchLine.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 15/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

@import UIKit;

#import "SFSketchLine.h"

@interface SFSketchLine ()
@end

@implementation SFSketchLine

- (id)init
{
    self = [super init];
    if (self) {
        self.points = [NSMutableArray array];
        self.lineBounds = CGRectMake(NSNotFound, 0, 0, 0);
    }
    return self;
}

- (CGRect) boundsForLastSegment
{
    CGRect boundsForLastUpdate = CGRectMake(NSNotFound, 0, 0, 0);
    
    // Using up to 3 point backward to calculate the bounds of the latest segment
    NSInteger backwardPoint = 3;
    NSInteger backwardIndex = self.points.count-1;
    
    // Not keeing in count the predicted points
    while (backwardIndex > 0 && [(SFSketchPoint *)[self.points objectAtIndex:backwardIndex] type] == SFSketchPointTypePredicted) {
        backwardPoint++;
        backwardIndex--;
    }
    
    NSUInteger numberOfPoint = self.points.count;
    while (numberOfPoint > 0 && numberOfPoint > self.points.count-backwardPoint) {
        numberOfPoint--;
        SFSketchPoint *point = [self.points objectAtIndex:numberOfPoint];
        CGRect pointRect = CGRectMake(point.location.x, point.location.y, 0, 0);
        if (boundsForLastUpdate.origin.x == NSNotFound) {
            boundsForLastUpdate = pointRect;
        }
        else {
            boundsForLastUpdate = CGRectUnion(boundsForLastUpdate, pointRect);
        }
    }

    return boundsForLastUpdate;
}

- (void) updateLineBoundsForPoint: (SFSketchPoint *) point
{
    CGRect pointRect = CGRectMake(point.location.x, point.location.y, 0, 0);
    self.lineBounds = self.lineBounds.origin.x == NSNotFound ? pointRect : CGRectUnion(self.lineBounds, pointRect);
}

- (void) addPointForTouch:(UITouch *) touch type:(SFSketchPointType) type
{
    SFSketchPoint *point = [[SFSketchPoint alloc] initWithTouch:touch type:type];

    [self.points addObject:point];
    [self updateLineBoundsForPoint:point];
}

- (void) removePointsForType:(SFSketchPointType) type
{
    NSIndexSet *indexes = [self.points indexesOfObjectsPassingTest:^BOOL(SFSketchPoint *point, NSUInteger idx, BOOL * _Nonnull stop) {
        return point.type == type;
    }];
    
    [self.points removeObjectsAtIndexes:indexes];
}

@end
