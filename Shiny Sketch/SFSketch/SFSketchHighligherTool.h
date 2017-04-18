//
//  SFSketchHighligherTool.h
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 04/04/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

@import Foundation;

#import "SFSketchTool.h"

@interface SFSketchHighligherTool : NSObject <SFSketchTool>

@property (nonatomic) CGFloat tipSize;
@property (copy) UIColor *color;

@end
