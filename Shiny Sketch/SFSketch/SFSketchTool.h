//
//  SFSketchTool.h
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 30/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

@import Foundation;

#import "SFSketchLine.h"
#import "SFSketchGeometryUtils.h"

@protocol SFSketchTool <NSObject>

- (CGRect) boundsForLine: (SFSketchLine *) line;
- (CGRect) boundsForLastLineSegmnet: (SFSketchLine *) line;

- (void) drawLine: (SFSketchLine *) line inRect: (CGRect) rect context: (CGContextRef) context;
- (void) drawPoints: (NSArray *) points inContext: (CGContextRef) context;

@end                                                    
