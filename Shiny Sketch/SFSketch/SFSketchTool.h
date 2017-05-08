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

@property (copy) UIColor *color;

- (CGRect) boundsForLine: (SFSketchLine *) line;
- (CGRect) boundsForLastLineSegmnet: (SFSketchLine *) line;

- (void) drawPoints: (NSArray *) points inContext: (CGContextRef) context;

@end                                                    
