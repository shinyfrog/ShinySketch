//
//  SFSketchTool.h
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 30/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

@import Foundation;

#import "SFSketchLine.h"

@protocol SFSketchTool <NSObject>

- (CGRect) boundsForLine: (SFSketchLine *) line;
- (CGRect) boundsForLastLineSegmnet: (SFSketchLine *) line;

- (void) drawLine: (SFSketchLine *) line inContext: (CGContextRef) context;

@end                                                    
