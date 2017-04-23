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
        self.color = [UIColor colorWithRed:0.271 green:0.914 blue:0.678 alpha:0.9];
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

- (CGPoint) midPointForPoint: (CGPoint) p1 secondPoint: (CGPoint) p2
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (CGFloat) distanceBetweenPoint: (CGPoint) p1 secondPoint: (CGPoint) p2
{
    double dx = (p2.x-p1.x);
    double dy = (p2.y-p1.y);
    double dist = sqrt(dx*dx + dy*dy);

    return dist;
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
//    CGContextSetFlatness(context, 0.1f);

    //CGContextSetMiterLimit(context, 100);
    
//    CGContextSetLineJoin(context, kCGLineJoinBevel);
//    CGContextSetLineCap(context, kCGLineCapButt);

    
    [linePoints enumerateObjectsUsingBlock:^(SFSketchPoint *currentPoint, NSUInteger idx, BOOL * _Nonnull stop) {
        
        /*if (idx == 0) {
         CGContextMoveToPoint(context, currentPoint.location.x, currentPoint.location.y);
         previousPoint2 = previousPoint1;
         previousPoint1 = currentPoint;
         
         return;
         }*/
        
        /*
         if (idx == 1 || idx == linePoints.count-1) {
         CGContextSetLineCap(context, kCGLineCapButt);
         
         } else {
         CGContextSetLineCap(context, kCGLineCapRound);
         }*/
        
        if (idx < 2) {
            previousPoint2 = previousPoint1;
            previousPoint1 = currentPoint;
            return;
        }

        
        // calculate mid point
        CGPoint mid1 = [self midPointForPoint:previousPoint1.location secondPoint:previousPoint2.location];
        CGPoint mid2 = [self midPointForPoint:currentPoint.location secondPoint:previousPoint1.location];
        
        
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, mid1.x, mid1.y);
        
        CGContextAddQuadCurveToPoint(context, previousPoint1.location.x, previousPoint1.location.y, mid2.x, mid2.y);
        CGContextStrokePath(context);
        
        //CGContextAddLineToPoint(context, currentPoint.location.x, currentPoint.location.y);
        
        previousPoint2 = previousPoint1;
        previousPoint1 = currentPoint;
        
        
    }];

    /*
    previousPoint1 = [linePoints firstObject];
    previousPoint2 = [linePoints firstObject];
    
    [linePoints enumerateObjectsUsingBlock:^(SFSketchPoint *currentPoint, NSUInteger idx, BOOL * _Nonnull stop) {
        


        // calculate mid point
        CGPoint mid1 = [self midPointForPoint:previousPoint1.location secondPoint:previousPoint2.location];
        CGPoint mid2 = [self midPointForPoint:currentPoint.location secondPoint:previousPoint1.location];

        //[self drawPoint:mid1 inContext:context color:[[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor];
        //[self drawPoint:mid2 inContext:context color:[[UIColor blueColor] colorWithAlphaComponent:0.5].CGColor];
        [self drawPoint:currentPoint.location inContext:context color:[[UIColor redColor] colorWithAlphaComponent:0.5].CGColor];
        
            previousPoint2 = previousPoint1;
            previousPoint1 = currentPoint;

 
        

    }];*/
    


}

- (void) drawPoint: (CGPoint) point inContext: (CGContextRef) context color: (CGColorRef) color
{
    CGContextSetFillColorWithColor(context, color);
    CGContextFillEllipseInRect(context, CGRectInset(CGRectMake(point.x, point.y, 0, 0), -2, -2));
}

@end
