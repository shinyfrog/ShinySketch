//
//  SFSketchLine.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 15/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

@import UIKit;

#import "SFSketchLine.h"

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}


@interface SFSketchLine ()

@property (strong) NSMutableArray *points;

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

/**
 Returns the smallest rectangle needed to redraw the last section of the line.

 @return A rectangle needed to redraw the last section of the line.
 */
- (CGRect) boundsForLastUpdate
{
    CGRect boundsForLastUpdate = CGRectMake(NSNotFound, 0, 0, 0);
        
    NSInteger backwardPoint = 3;
    NSInteger backwardIndex = self.points.count-1;
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

    boundsForLastUpdate = CGRectInset(boundsForLastUpdate, -3, -3);

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


- (void) drawInContext: (CGContextRef) context
{
    // The first round is using only the initial point
    __block SFSketchPoint *previousPoint1 = [self.points firstObject];
    __block SFSketchPoint *previousPoint2 = [self.points firstObject];

    CGContextSetLineCap(context, kCGLineCapRound);
    UIColor *strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
    CGContextSetLineWidth(context, 1.1);
    
    [self.points enumerateObjectsUsingBlock:^(SFSketchPoint *currentPoint, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // calculate mid point
        CGPoint mid1 = midPoint(previousPoint1.location, previousPoint2.location);
        CGPoint mid2 = midPoint(currentPoint.location, previousPoint1.location);
        
        CGContextBeginPath(context);

        CGContextMoveToPoint(context, mid1.x, mid1.y);
        CGContextAddQuadCurveToPoint(context, previousPoint1.location.x, previousPoint1.location.y, mid2.x, mid2.y);
        CGContextStrokePath(context);
        
        
        //[self drawPoint:mid1 inContext:context color:[UIColor greenColor].CGColor];
        //[self drawPoint:mid2 inContext:context color:[UIColor blueColor].CGColor];
        //[self drawPoint:currentPoint.location inContext:context color:[UIColor redColor].CGColor];
        
        previousPoint2 = previousPoint1;
        previousPoint1 = currentPoint;
        
    }];
}

- (void) drawPoint: (CGPoint) point inContext: (CGContextRef) context color: (CGColorRef) color
{
    CGContextSetFillColorWithColor(context, color);
    CGContextFillEllipseInRect(context, CGRectInset(CGRectMake(point.x, point.y, 0, 0), -2, -2));
}

@end
