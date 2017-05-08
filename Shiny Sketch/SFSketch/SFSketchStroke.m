//
//  SFSketchStroke.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 30/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "SFSketchStroke.h"

@implementation SFSketchStroke

- (CGRect) drawTouches:(NSSet *)touches event: (UIEvent *) event inContext: (CGContextRef) context;
{
    NSUInteger currentLineIndex = self.line.points.count ? self.line.points.count-2 : 0;
    
    for (UITouch *touch in touches) {
        [self.line addPointForTouch:touch type:SFSketchPointTypeStandard];
    }
    
    if (self.line.points.count < 3) {
        return CGRectZero;
    }

    NSArray *pointToDraw = [self.line.points subarrayWithRange:NSMakeRange(currentLineIndex, touches.count+2)];
        
    [self.tool drawPoints:pointToDraw inContext:context];
    
    return [self boundsForLastSegment];
}

- (void) drawInContext: (CGContextRef) context;
{
    [self.tool drawPoints:self.line.points inContext:context];
}

- (CGRect) boundsForLastSegment
{
    return [self.tool boundsForLastLineSegmnet:self.line];
}

@end
