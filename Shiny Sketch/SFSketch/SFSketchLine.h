//
//  SFSketchLine.h
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 15/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

@import CoreGraphics;
@import Foundation;
@import UIKit;

#import "SFSketchPoint.h"

@interface SFSketchLine : NSObject

@property (strong) NSMutableArray *points;
@property (nonatomic) CGRect lineBounds;

/**
 Returns the smallest rectangle needed to redraw the last section of the line.
 
 @return A rectangle needed to redraw the last section of the line.
 */
- (CGRect) boundsForLastSegment;

- (void) addPointForTouch:(UITouch *) touch type:(SFSketchPointType) type;
- (void) removePointsForType:(SFSketchPointType) type;


@end
