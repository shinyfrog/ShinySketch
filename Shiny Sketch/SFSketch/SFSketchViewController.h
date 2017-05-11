//
//  ViewController.h
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 15/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSketchView.h"

@interface SFSketchViewController : UIViewController

@property (strong) IBOutlet UIScrollView *scrollView;
@property (strong) IBOutlet SFSketchView *sketchView;

@property (assign) IBOutlet UIButton *penToolButton;
@property (assign) IBOutlet UIButton *markerToolButton;
@property (assign) IBOutlet UIButton *eraserToolButton;

@property (assign) IBOutlet UIButton *smallPointButton;
@property (assign) IBOutlet UIButton *mediumPointButton;
@property (assign) IBOutlet UIButton *bigPointButton;

@property (assign) IBOutlet UIButton *paletteToggleButton;

@property (assign) IBOutlet UIScrollView *colorPaletteView;
@property (assign) IBOutlet UIView *pointPickerView;

@end

