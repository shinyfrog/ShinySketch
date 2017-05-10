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
#import "SFSketchIconsKit.h"

#define kToolStrokeColor [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.0]
#define kToolPointColor  [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.0]
#define kToolFillColor   [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]

@interface SFSketchViewController ()

@property (strong) NSArray *availableColors;

@end

@implementation SFSketchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
    
    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [self newDrawCanvasWithSize:size];
    
    [self usePenTool:self];
    
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.contentSize=size;
    self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    
    [self updateToolIcons];
    [self setupColorPalette];
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

#pragma mark - Icons

- (void) updateToolIcons
{
    [self setPenToolIconWithTipColor:nil];
    [self setMarkerToolIconWithTipColor:nil];
    [self setEraserToolIconWithTipColor:nil];
}

- (void) setPenToolIconWithTipColor: (UIColor *) tipColor
{
    
    UIImage *image = [SFSketchIconsKit imageOfPenToolWithToolFillColor:kToolFillColor pointFillColor:kToolPointColor toolStrokeColor:kToolStrokeColor];
    [self.penToolButton setImage:image forState:UIControlStateNormal];
}

- (void) setMarkerToolIconWithTipColor: (UIColor *) tipColor
{
    UIImage *image = [SFSketchIconsKit imageOfMarkerToolWithToolFillColor:kToolFillColor pointFillColor:kToolPointColor toolStrokeColor:kToolStrokeColor];
    [self.markerToolButton setImage:image forState:UIControlStateNormal];
}

- (void) setEraserToolIconWithTipColor: (UIColor *) tipColor
{
    UIImage *image = [SFSketchIconsKit imageOfEraserToolWithToolFillColor:kToolFillColor pointFillColor:kToolPointColor toolStrokeColor:kToolStrokeColor];
    [self.eraserToolButton setImage:image forState:UIControlStateNormal];
}

#pragma mark - Colors

- (void) setupColorPalette
{
    self.availableColors = @[
                             [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0],
                             [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0],
                             [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.0],
                             [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
                             [UIColor colorWithRed:0.69 green:0.45 blue:0.80 alpha:1.0],
                             [UIColor colorWithRed:0.18 green:0.31 blue:0.65 alpha:1.0],
                             [UIColor colorWithRed:0.38 green:0.68 blue:0.93 alpha:1.0],
                             [UIColor colorWithRed:0.36 green:0.78 blue:0.50 alpha:1.0],
                             [UIColor colorWithRed:1.00 green:0.83 blue:0.21 alpha:1.0],
                             [UIColor colorWithRed:0.95 green:0.60 blue:0.24 alpha:1.0],
                             [UIColor colorWithRed:0.86 green:0.32 blue:0.32 alpha:1.0],
                             ];
    
    __block CGFloat yOffset = CGRectGetMaxY(self.colorPaletteView.bounds) - 40;
    [self.availableColors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, yOffset, 40, 40)];
        [button addTarget:self action:@selector(colorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorPaletteView  addSubview:button];
        [button setTag:idx];
        UIImage *image = [SFSketchIconsKit imageOfColorToolWithSize:CGSizeMake(40, 40) toolFillColor:color toolStrokeColor:[kToolStrokeColor colorWithAlphaComponent:0.3]];
        
        [button setImage:image forState:UIControlStateNormal];
        
        yOffset -= 50;
    }];
}

- (IBAction)colorButtonTapped:(id)sender
{
    self.sketchView.currentTool.color = [self.availableColors objectAtIndex:[sender tag]];
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
