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
#import "SFSketchHighligherTool.h"
#import "SFSketchEraserTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [self newDrawCanvasWithSize:size];
    
    [self usePenTool:self];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.sketchView scaleViewForNewSize:size];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    }];
}

- (void) newDrawCanvasWithSize: (CGSize) size
{
    [self.sketchView removeFromSuperview];
    
    SFSketchView *sketchView = [[SFSketchView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sketchView.backgroundColor = [UIColor whiteColor];
    [sketchView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.sketchView = sketchView;
    
    [self.view addSubview:self.sketchView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.sketchView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.sketchView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.sketchView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.f
                                                           constant:size.width]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.sketchView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.f
                                                           constant:size.height]];
}

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

- (IBAction) usePenTool:(id)sender
{
    SFSketchPenTool *tool = [SFSketchPenTool new];
    self.sketchView.currentTool = tool;
}

- (IBAction) useHighlighterTool:(id)sender
{
    SFSketchHighligherTool *tool = [SFSketchHighligherTool new];
    self.sketchView.currentTool = tool;
}


- (IBAction) useEraserTool:(id)sender
{
    SFSketchEraserTool *tool = [SFSketchEraserTool new];
    self.sketchView.currentTool = tool;
}

- (IBAction)greenColor:(id)sender
{
    self.sketchView.currentTool.color = [UIColor colorWithRed:0.271 green:0.914 blue:0.678 alpha:1];
}

- (IBAction)redColor:(id)sender
{
    self.sketchView.currentTool.color = [UIColor colorWithRed:0.771 green:0.314 blue:0.378 alpha:1];
}

@end
