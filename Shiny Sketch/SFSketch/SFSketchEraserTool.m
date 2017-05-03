//
//  SFSketchEraserTool.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 07/04/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "SFSketchEraserTool.h"

@implementation SFSketchEraserTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tipSize = 30;
        self.color = nil;
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone;
{
    SFSketchEraserTool *toolCopy = [[[self class] allocWithZone:zone] init];
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
    
    return CGRectInset(boundsForLastLineSegmnet, -self.tipSize, -self.tipSize);
}

- (void) drawLine: (SFSketchLine *) line inRect: (CGRect) rect context: (CGContextRef) context;
{
    [self drawPoints:line.points inContext:context];
}

- (void) drawPoints: (NSArray *) points inContext: (CGContextRef) context
{
    // The first round is using only the initial point
    __block SFSketchPoint *previousPoint1 = [points firstObject];
    __block SFSketchPoint *previousPoint2 = [points firstObject];
    
    UIColor *strokeColor = self.color;
    
    CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
    CGContextSetLineWidth(context, self.tipSize);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);


    [points enumerateObjectsUsingBlock:^(SFSketchPoint *currentPoint, NSUInteger idx, BOOL * _Nonnull stop) {
 
        // calculate mid point
        CGPoint mid1 = [SFSketchGeometryUtils midPointForPoint:previousPoint1.location secondPoint:previousPoint2.location];
        CGPoint mid2 = [SFSketchGeometryUtils midPointForPoint:currentPoint.location secondPoint:previousPoint1.location];
        
        CGContextBeginPath(context);

        CGContextMoveToPoint(context, mid1.x, mid1.y);
        CGContextAddQuadCurveToPoint(context, previousPoint1.location.x, previousPoint1.location.y, mid2.x, mid2.y);

        CGContextStrokePath(context);

        previousPoint2 = previousPoint1;
        previousPoint1 = currentPoint;
    }];
    
    
}

@end
