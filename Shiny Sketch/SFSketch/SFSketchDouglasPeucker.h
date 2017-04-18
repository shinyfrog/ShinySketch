//
//  SFSketchDouglasPeucker.h
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 14/04/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSketchPoint.h"

@interface SFSketchDouglasPeucker : NSObject

+ (NSArray *)reducePoints:(NSArray <SFSketchPoint *> *)points epsilon:(CGFloat)epsilon;

@end
