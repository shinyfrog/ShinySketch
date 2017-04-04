//
//  SFSketchPenTool.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 30/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "SFSketchPenTool.h"

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

@implementation SFSketchPenTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tipSize = 1.1;
        self.color = [UIColor blackColor];
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone;
{
    SFSketchPenTool *toolCopy = [[[self class] allocWithZone:zone] init];
    if (toolCopy) {
        toolCopy.tipSize = _tipSize;
        toolCopy.color = [_color copyWithZone:zone];        
    }

    return toolCopy;
}

- (CGPoint) midPointForPoint: (CGPoint) p1 secondPoint: (CGPoint) p2
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (CGFloat) distanceBetweenPoint: (CGPoint) p1 secondPoint: (CGPoint) p2
{
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
}

- (CGRect) boundsForLine: (SFSketchLine *) line
{
    return CGRectInset(line.lineBounds, -self.tipSize, -self.tipSize);
}

- (CGRect) boundsForLastLineSegmnet: (SFSketchLine *) line
{
    CGRect boundsForLastLineSegmnet = [line boundsForLastSegment];
    
    return CGRectInset(boundsForLastLineSegmnet, -self.tipSize, -self.tipSize);
}

- (void) drawLine: (SFSketchLine *) line inContext: (CGContextRef) context
{
    NSArray *linePoints = line.points;
    
    // The first round is using only the initial point
    __block SFSketchPoint *previousPoint1 = [linePoints firstObject];
    __block SFSketchPoint *previousPoint2 = [linePoints firstObject];
    
    CGContextSetLineCap(context, kCGLineCapRound);
    UIColor *strokeColor = self.color;
    
    CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
    CGContextSetLineWidth(context, self.tipSize);
    
    [linePoints enumerateObjectsUsingBlock:^(SFSketchPoint *currentPoint, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // calculate mid point
        CGPoint mid1 = [self midPointForPoint:previousPoint1.location secondPoint:previousPoint2.location];
        CGPoint mid2 = [self midPointForPoint:currentPoint.location secondPoint:previousPoint1.location];
        
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, mid1.x, mid1.y);
        CGContextAddQuadCurveToPoint(context, previousPoint1.location.x, previousPoint1.location.y, mid2.x, mid2.y);
        CGContextStrokePath(context);

        previousPoint2 = previousPoint1;
        previousPoint1 = currentPoint;
        
//        [self drawPoint:mid1 inContext:context color:[[UIColor greenColor] colorWithAlphaComponent:0.5].CGColor];
//        [self drawPoint:mid2 inContext:context color:[[UIColor blueColor] colorWithAlphaComponent:0.5].CGColor];
//        [self drawPoint:currentPoint.location inContext:context color:[[UIColor redColor] colorWithAlphaComponent:0.5].CGColor];
        
    }];
}

- (void) drawPoint: (CGPoint) point inContext: (CGContextRef) context color: (CGColorRef) color
{
    CGContextSetFillColorWithColor(context, color);
    CGContextFillEllipseInRect(context, CGRectInset(CGRectMake(point.x, point.y, 0, 0), -2, -2));
}

@end
