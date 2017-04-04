//
//  ViewController.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 15/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "ViewController.h"
#import "SFSketchPenTool.h"
#import "SFSketchFountainPenTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)clear:(id)sender
{
    [self.sketchView clear];
}

- (IBAction)redraw:(id)sender
{
    [self.sketchView setNeedsDisplayInRect:self.sketchView.bounds];
}

- (IBAction)increaseTipSize:(id)sender
{
    SFSketchPenTool *tool = self.sketchView.currentTool;
    tool.tipSize++;
}

- (IBAction)decreaseTipSize:(id)sender
{
    SFSketchPenTool *tool = self.sketchView.currentTool;
    if (tool.tipSize > 2) {
        tool.tipSize--;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //SFSketchFountainPenTool *tool = [SFSketchFountainPenTool new];
    SFSketchPenTool *tool = [SFSketchPenTool new];

    self.sketchView.currentTool = tool;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
