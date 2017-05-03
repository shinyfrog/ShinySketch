//
//  SFSketchHighligherTool.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 04/04/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "SFSketchHighligherTool.h"
#import "SFSketchDouglasPeucker.h"

@implementation SFSketchHighligherTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tipSize = 20;
        self.color = [UIColor colorWithRed:0.271 green:0.914 blue:0.678 alpha:1];
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone;
{
    SFSketchHighligherTool *toolCopy = [[[self class] allocWithZone:zone] init];
    if (toolCopy) {
        toolCopy.tipSize = _tipSize;
        toolCopy.color = [_color copyWithZone:zone];
    }
    
    return toolCopy;
}


- (CGRect) boundsForLine: (SFSketchLine *) line
{
    return CGRectInset(line.lineBounds, -self.tipSize, -self.tipSize);
}

- (CGRect) boundsForLastLineSegmnet: (SFSketchLine *) line
{
    CGRect boundsForLastLineSegmnet = [line boundsForLastSegment];
    return CGRectInset(boundsForLastLineSegmnet, -self.tipSize*5, -self.tipSize*5);
}

- (void) drawLine: (SFSketchLine *) line inRect: (CGRect) rect context: (CGContextRef) context;
{
    
}

- (void) drawPoints: (NSArray *) points inContext: (CGContextRef) context
{
    NSArray *linePoints = points;// [SFSketchDouglasPeucker reducePoints:points epsilon:.5];
    
    // The first round is using only the initial point
    __block SFSketchPoint *previousPoint1 = [linePoints firstObject];
    __block SFSketchPoint *previousPoint2 = [linePoints firstObject];
    
    UIColor *strokeColor = self.color;
    
    CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
    CGContextSetLineWidth(context, self.tipSize);
    CGContextSetBlendMode(context, kCGBlendModeDarken);
    CGContextSetLineCap(context, kCGLineCapRound);


    [linePoints enumerateObjectsUsingBlock:^(SFSketchPoint *currentPoint, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if (idx < 2) {
            previousPoint2 = previousPoint1;
            previousPoint1 = currentPoint;
            return;
        }
        
        CGContextBeginPath(context);

        // calculate mid point
        CGPoint mid1 = [SFSketchGeometryUtils midPointForPoint:previousPoint1.location secondPoint:previousPoint2.location];
        CGPoint mid2 = [SFSketchGeometryUtils midPointForPoint:currentPoint.location secondPoint:previousPoint1.location];
        
        CGContextMoveToPoint(context, mid1.x, mid1.y);
        
        CGContextAddQuadCurveToPoint(context, previousPoint1.location.x, previousPoint1.location.y, mid2.x, mid2.y);
        
        //CGContextMoveToPoint(context, previousPoint1.location.x, previousPoint1.location.y);
        //CGContextAddLineToPoint(context, currentPoint.location.x, currentPoint.location.y);
        
        previousPoint2 = previousPoint1;
        previousPoint1 = currentPoint;
        
        CGContextStrokePath(context);
    }];


}

- (void) drawPoint: (CGPoint) point inContext: (CGContextRef) context color: (CGColorRef) color
{
    CGContextSetFillColorWithColor(context, color);
    CGContextFillEllipseInRect(context, CGRectInset(CGRectMake(point.x, point.y, 0, 0), -2, -2));
}

@end
