//
//  SFSketchGeometryUtils.h
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 14/04/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

@interface SFSketchGeometryUtils : NSObject

+ (CGFloat) distanceBetweenPoint: (CGPoint) p1 secondPoint: (CGPoint) p2;
+ (CGFloat) perpendicularDistanceFromPoint: (CGPoint) point linePointA: (CGPoint) linePointA linePointB: (CGPoint) linePointB;

@end
