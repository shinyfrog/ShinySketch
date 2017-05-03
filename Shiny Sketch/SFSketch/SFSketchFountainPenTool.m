//
//  SFSketchFountainPenTool.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 04/04/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "SFSketchFountainPenTool.h"

@implementation SFSketchFountainPenTool

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
    SFSketchFountainPenTool *toolCopy = [[[self class] allocWithZone:zone] init];
    if (toolCopy) {
        toolCopy.tipSize = _tipSize;
        toolCopy.color = [_color copyWithZone:zone];
    }
    
    return toolCopy;
}

- (CGRect) boundsForLine: (SFSketchLine *) line
{
    return CGRectInset(line.lineBounds, -self.tipSize * 4.0 * 4.0, -self.tipSize * 4.0 * 4.0);
}

- (CGRect) boundsForLastLineSegmnet: (SFSketchLine *) line
{
    CGRect boundsForLastLineSegmnet = [line boundsForLastSegment];
    
    return CGRectInset(boundsForLastLineSegmnet, -self.tipSize * 4.0 * 4.0, -self.tipSize * 4.0 * 4.0);
}

- (CGFloat) tipSizeForPoint: (SFSketchPoint *) point
{
    CGFloat tipSize = self.tipSize;
    if (point.force > 0) {
        NSLog(@"%f", point.force);
        tipSize = MAX(tipSize, point.force * 4.0);
    }
    
    return tipSize;
}

- (void) drawLine: (SFSketchLine *) line inRect: (CGRect) rect context: (CGContextRef) context;
{
    NSArray *linePoints = line.points;
    
    // The first round is using only the initial point
    __block SFSketchPoint *previousPoint1 = [linePoints firstObject];
    __block SFSketchPoint *previousPoint2 = [linePoints firstObject];
    
    CGContextSetLineCap(context, kCGLineCapRound);
    UIColor *strokeColor = self.color;
    
    CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
    
    [linePoints enumerateObjectsUsingBlock:^(SFSketchPoint *currentPoint, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // calculate mid point
        CGPoint mid1 = [SFSketchGeometryUtils midPointForPoint:previousPoint1.location secondPoint:previousPoint2.location];
        CGPoint mid2 = [SFSketchGeometryUtils midPointForPoint:currentPoint.location secondPoint:previousPoint1.location];
        
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, mid1.x, mid1.y);
        CGContextAddQuadCurveToPoint(context, previousPoint1.location.x, previousPoint1.location.y, mid2.x, mid2.y);
        
        CGFloat tipSize = [self tipSizeForPoint:currentPoint];
        CGContextSetLineWidth(context, tipSize);

        CGContextStrokePath(context);
        
        previousPoint2 = previousPoint1;
        previousPoint1 = currentPoint;
    }];
}

@end
