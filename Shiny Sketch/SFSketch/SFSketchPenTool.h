//
//  SFSketchPenTool.h
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 30/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

@import Foundation;

#import "SFSketchTool.h"

@interface SFSketchPenTool : NSObject <SFSketchTool>

@property (nonatomic) CGFloat tipSize;
@property (copy) UIColor *color;

@end
