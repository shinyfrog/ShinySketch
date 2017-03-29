//
//  SFSketchLine.h
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 15/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

@import CoreGraphics;
@import Foundation;

#import "SFSketchPoint.h"

@interface SFSketchLine : NSObject

@property (nonatomic) CGRect lineBounds;

- (void) addPointForTouch:(UITouch *) touch type:(SFSketchPointType) type;
- (void) removePointsForType:(SFSketchPointType) type;

- (CGRect) boundsForLastUpdate;
- (void) drawInContext: (CGContextRef) context;

@end
