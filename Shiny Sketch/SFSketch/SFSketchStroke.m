//
//  SFSketchStroke.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 30/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "SFSketchStroke.h"

@implementation SFSketchStroke

- (void) drawRect: (CGRect) rect inContext: (CGContextRef) context;
{
    [self.tool drawLine:self.line inContext:context];
}

- (CGRect) boundsForLastSegment
{
    return [self.tool boundsForLastLineSegmnet:self.line];
}

@end
