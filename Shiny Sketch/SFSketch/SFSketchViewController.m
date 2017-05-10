//
//  ViewController.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 15/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "SFSketchViewController.h"
#import "SFSketchPenTool.h"
#import "SFSketchFountainPenTool.h"
#import "SFSketchHighligherTool.h"
#import "SFSketchEraserTool.h"
#import "SFSketchScrollView.h"

@interface SFSketchViewController ()

@end

@implementation SFSketchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [self newDrawCanvasWithSize:size];
    
    [self usePenTool:self];
    
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.contentSize=size;
    self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

        CGFloat newScale;
        if (self.sketchView.initialSize.width > self.sketchView.initialSize.height) {
            newScale = size.width / self.sketchView.initialSize.width;
        }
        else {
            newScale = size.height / self.sketchView.initialSize.height;
        }
        
        CGFloat currentZoom = self.scrollView.zoomScale;

        // Setting the new minimum scale
        self.scrollView.minimumZoomScale = newScale;
        
        // if the current canvas is zoomed we don't change anything
        if (currentZoom <= 1.0) {
            [self.scrollView setZoomScale:newScale];
        }
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

    }];
}

- (void)newDrawCanvasWithSize:(CGSize)size
{
    [self.sketchView removeFromSuperview];
    
    SFSketchView *sketchView = [[SFSketchView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sketchView.backgroundColor = [UIColor whiteColor];
    
    self.sketchView = sketchView;
    
    UIView *superView = self.scrollView;
    
    [superView addSubview:self.sketchView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [(SFSketchScrollView *)self.scrollView centerContent];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.sketchView;
}

#pragma mark - Actions

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

- (IBAction)usePenTool:(id)sender
{
    SFSketchPenTool *tool = [SFSketchPenTool new];
    self.sketchView.currentTool = tool;
}

- (IBAction)useHighlighterTool:(id)sender
{
    SFSketchHighligherTool *tool = [SFSketchHighligherTool new];
    self.sketchView.currentTool = tool;
}


- (IBAction)useEraserTool:(id)sender
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

#pragma mark - Undo / Redo

- (IBAction)undo:(id)sender
{
    [self.sketchView undo:sender];
}

- (IBAction)redo:(id)sender
{
    [self.sketchView redo:sender];
}


@end
