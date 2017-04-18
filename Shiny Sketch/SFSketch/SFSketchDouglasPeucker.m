//
//  SFSketchDouglasPeucker.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 14/04/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "SFSketchDouglasPeucker.h"
#import "SFSketchGeometryUtils.h"

@implementation SFSketchDouglasPeucker

+ (NSArray *)reducePoints:(NSArray <SFSketchPoint *> *)points epsilon:(CGFloat)epsilon
{
    NSUInteger count = [points count];
    if(count < 3)
    {
        return points;
    }
    
    //Find the point with the maximum distance
    CGFloat dmax = 0;
    NSUInteger index = 0;
    for(NSUInteger i = 1; i < count - 1; i++) {
        CGPoint point = [[points objectAtIndex:i] location];
        CGPoint lineA = [[points objectAtIndex:0] location];
        CGPoint lineB = [[points objectAtIndex:count - 1] location];
        CGFloat d = [SFSketchGeometryUtils perpendicularDistanceFromPoint:point linePointA:lineA linePointB:lineB];
        if(d > dmax) {
            index = i;
            dmax = d;
        }
    }
    
    //If max distance is greater than epsilon, recursively simplify
    NSArray *resultList;
    if(dmax > epsilon)
    {
        NSArray *recResults1 = [SFSketchDouglasPeucker reducePoints:[points subarrayWithRange:NSMakeRange(0, index + 1)] epsilon:epsilon];
        
        NSArray *recResults2 = [SFSketchDouglasPeucker reducePoints:[points subarrayWithRange:NSMakeRange(index, count - index)] epsilon:epsilon];
        
        NSMutableArray *tmpList = [NSMutableArray arrayWithArray:recResults1];
        [tmpList removeLastObject];
        [tmpList addObjectsFromArray:recResults2];
        resultList = tmpList;
    }
    else
    {
        resultList = [NSArray arrayWithObjects:[points objectAtIndex:0], [points objectAtIndex:count - 1],nil];
    }
    
    return resultList;
}


@end
