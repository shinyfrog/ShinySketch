//
//  SFSketchStroke.h
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 30/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "SFSketchTool.h"
#import "SFSketchLine.h"

@interface SFSketchStroke : NSObject

@property (strong) SFSketchLine *line;
@property (copy) id <SFSketchTool> tool;

- (CGRect) boundsForLastSegment;
- (void) drawInContext: (CGContextRef) context;

- (CGRect) drawTouches:(NSSet *)touches event: (UIEvent *) event inContext: (CGContextRef) context;

@end
