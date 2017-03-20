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
@property (strong) NSMutableArray *predictedPoints;

@property (nonatomic) CGRect lineBoundsForPreviousPoints;
@property (nonatomic) CGRect lineBoundsForCurrentPoints;

@end

@implementation SFSketchLine

- (id)init
{
    self = [super init];
    if (self) {
        self.points = [NSMutableArray array];
        self.predictedPoints = [NSMutableArray array];
        self.lineBounds = CGRectMake(NSNotFound, 0, 0, 0);
        self.lineBoundsForPreviousPoints = CGRectMake(NSNotFound, 0, 0, 0);
        self.lineBoundsForCurrentPoints = CGRectMake(NSNotFound, 0, 0, 0);

    }
    return self;
}

- (CGRect) boundForLatestUpdate
{
    CGRect boundForLatestUpdate;
    
    if (self.lineBoundsForPreviousPoints.origin.x == NSNotFound) {
        boundForLatestUpdate = self.lineBoundsForCurrentPoints;
        NSLog(@"not using prev");
    }
    else {
        boundForLatestUpdate = CGRectUnion(self.lineBoundsForPreviousPoints, self.lineBoundsForCurrentPoints);
    }
    
    boundForLatestUpdate = CGRectInset(boundForLatestUpdate, -3, -3);
    
    return boundForLatestUpdate;
}

- (void) updateLineBoundsForPoint: (SFSketchPoint *) point
{
    CGRect pointRect = CGRectMake(point.location.x, point.location.y, 0, 0);
    self.lineBounds = self.lineBounds.origin.x == NSNotFound ? pointRect : CGRectUnion(self.lineBounds, pointRect);
}

- (void) updateLineBoundsForCurrentPointsWithPoint: (SFSketchPoint *) point
{
    CGRect pointRect = CGRectMake(point.location.x, point.location.y, 0, 0);
    self.lineBoundsForCurrentPoints = self.lineBoundsForCurrentPoints.origin.x == NSNotFound ? pointRect : CGRectUnion(self.lineBoundsForCurrentPoints, pointRect);
}

- (void) addPointForTouch:(UITouch *) touch type:(SFSketchPointType) type
{
    self.lineBoundsForPreviousPoints = self.lineBoundsForCurrentPoints;
    self.lineBoundsForCurrentPoints = CGRectMake(NSNotFound, 0, 0, 0);
    
    SFSketchPoint *previousPoint = [self.points lastObject];
    NSUInteger sequenceIndex = previousPoint ? previousPoint.sequenceIndex +1 : 0;
    
    SFSketchPoint *point = [[SFSketchPoint alloc] initWithTouch:touch sequenceIndex:sequenceIndex type:type];

    [self.points addObject:point];
    [self updateLineBoundsForPoint:point];
    [self updateLineBoundsForCurrentPointsWithPoint:point];
}

- (void) addPointsForPredictedTouches: (NSArray *) touches
{
    [self.predictedPoints removeAllObjects];
    NSUInteger sequenceIndex = 0;
    for (UITouch *touch in touches) {
        SFSketchPoint *point = [[SFSketchPoint alloc] initWithTouch:touch sequenceIndex:sequenceIndex type:SFSketchPointTypePredicted];
        [self.predictedPoints addObject:point];
        [self updateLineBoundsForPoint:point];
        [self updateLineBoundsForCurrentPointsWithPoint:point];
    }
}

- (void) addPointsForCoalescedTouches: (NSArray *) touches
{
    for (UITouch *touch in touches) {
        SFSketchPoint *point = [[SFSketchPoint alloc] initWithTouch:touch sequenceIndex:0 type:SFSketchPointTypePredicted];
        [self updateLineBoundsForCurrentPointsWithPoint:point];
    }
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
    
    NSArray *pointToDraw;
    if (self.predictedPoints.count) {
        pointToDraw = [self.points arrayByAddingObject:[self.predictedPoints firstObject]];
    }
    else {
        pointToDraw = self.points;
    }
    
    [pointToDraw enumerateObjectsUsingBlock:^(SFSketchPoint *currentPoint, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // calculate mid point
        CGPoint mid1 = midPoint(previousPoint1.location, previousPoint2.location);
        CGPoint mid2 = midPoint(currentPoint.location, previousPoint1.location);
        
        CGContextBeginPath(context);

        CGContextMoveToPoint(context, mid1.x, mid1.y);
        CGContextAddQuadCurveToPoint(context, previousPoint1.location.x, previousPoint1.location.y, mid2.x, mid2.y);
        CGContextStrokePath(context);
        
        [self drawPoint:currentPoint inContext:context];
        
        previousPoint2 = previousPoint1;
        previousPoint1 = currentPoint;
        
    }];
}

- (void) drawPoint: (SFSketchPoint *) point inContext: (CGContextRef) context
{
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextFillEllipseInRect(context, CGRectInset(CGRectMake(point.location.x, point.location.y, 0, 0), -1.5, -1.5));
}

@end
