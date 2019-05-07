//
//  SFSketchView.h
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 15/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSketchTool.h"

@protocol SFSketchViewDelegate;

@interface SFSketchView : UIView

@property (weak) id <SFSketchViewDelegate> delegate;

@property (strong) id <SFSketchTool> currentTool;
@property (nonatomic) CGSize initialSize;
@property (strong) NSUndoManager *sketchUndoManager;
@property (nonatomic) BOOL imageChanged;

- (void) clear;

- (void) scaleViewForNewSize:(CGSize)size;

- (UIImage *) bitmapImage;

- (void) setInitialImage:(CGImageRef)image;

#pragma mark - Undo / Redo

- (IBAction)undo:(id)sender;
- (IBAction)redo:(id)sender;

@end

@protocol SFSketchViewDelegate <NSObject>

- (void) sketchView: (SFSketchView *) sketchView touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end
