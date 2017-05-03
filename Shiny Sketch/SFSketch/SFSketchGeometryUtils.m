//
//  SFSketchGeometryUtils.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 14/04/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "SFSketchGeometryUtils.h"

@implementation SFSketchGeometryUtils

+ (CGFloat) perpendicularDistanceFromPoint: (CGPoint) point linePointA: (CGPoint) linePointA linePointB: (CGPoint) linePointB
{
    CGFloat lineLenght = [self distanceBetweenPoint:linePointA secondPoint:linePointB];
    
    if (lineLenght == 0) {
        return [self distanceBetweenPoint:point secondPoint:linePointA];
    }
    
    CGFloat numerator = fabs((linePointB.y - linePointA.y) * point.x - (linePointB.x - linePointA.x) * point.y + (linePointB.x * linePointA.y) - (linePointB.y * linePointA.x));
    
    return numerator / lineLenght;
}

+ (CGFloat) distanceBetweenPoint: (CGPoint) p1 secondPoint: (CGPoint) p2
{
    double dx = (p2.x-p1.x);
    double dy = (p2.y-p1.y);
    double dist = sqrt(dx*dx + dy*dy);
    
    return dist;
}


+ (CGPoint) midPointForPoint: (CGPoint) p1 secondPoint: (CGPoint) p2
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}


@end
