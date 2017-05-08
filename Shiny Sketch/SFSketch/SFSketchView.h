//
//  SFSketchView.h
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 15/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSketchTool.h"

@interface SFSketchView : UIView

@property (strong) id <SFSketchTool> currentTool;
@property (nonatomic) CGSize initialSize;

- (void) clear;

- (void) scaleViewForNewSize:(CGSize)size;


#pragma mark - Undo / Redo

- (IBAction)undo:(id)sender;
- (IBAction)redo:(id)sender;

@end
