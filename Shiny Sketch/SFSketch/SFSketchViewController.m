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

typedef NS_ENUM(NSInteger, SFSketchPointSize)
{
    SFSketchPointSizeSmall,
    SFSketchPointSizeMedium,
    SFSketchPointSizeLarge,
};

@interface SFSketchViewController ()

@property (strong) NSArray *availableColors;

@property (strong) UIColor *currentColor;
@property (nonatomic) SFSketchPointSize currentPointSize;

@property (nonatomic) BOOL paletteClosed;

@end

@implementation SFSketchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.paletteClosed = YES;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
    
    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [self newDrawCanvasWithSize:size];
    
    self.currentColor = [UIColor blackColor];
    self.currentPointSize = SFSketchPointSizeSmall;

    [self setupCanvasScrollViewWithSize:size];
    [self setupColorPalette];

    [self usePenTool:self];
    [self updatePointPickerIcons];
    [self updatePaletteToggleIcon];
}

- (void)viewDidAppear:(BOOL)animated
{
    CGPoint bottomOffset = CGPointMake(0, self.colorPaletteView.contentSize.height - self.colorPaletteView.bounds.size.height);
    [self.colorPaletteView setContentOffset:bottomOffset animated:NO];

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

#pragma mark - Setups

- (void) setupCanvasScrollViewWithSize: (CGSize) size
{
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.contentSize=size;
    self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
}

- (void) setupColorPalette
{
    self.availableColors = @[
                             [UIColor colorWithRed:0.86 green:0.32 blue:0.32 alpha:1.0],
                             [UIColor colorWithRed:0.95 green:0.60 blue:0.24 alpha:1.0],
                             [UIColor colorWithRed:1.00 green:0.83 blue:0.21 alpha:1.0],
                             [UIColor colorWithRed:0.36 green:0.78 blue:0.50 alpha:1.0],
                             [UIColor colorWithRed:0.38 green:0.68 blue:0.93 alpha:1.0],
                             [UIColor colorWithRed:0.18 green:0.31 blue:0.65 alpha:1.0],
                             [UIColor colorWithRed:0.69 green:0.45 blue:0.80 alpha:1.0],
                             [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
                             [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.0],
                             [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0],
                             [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0],
                             ];
    
    CGFloat buttonSize = 40;
    CGFloat buttonSpacing = 10;
    __block CGFloat yOffset = 0;
    [self.availableColors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, yOffset, buttonSize, buttonSize)];
        [button addTarget:self action:@selector(colorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorPaletteView addSubview:button];
        [button setTag:idx];
        UIImage *image = [SFSketchIconsKit imageOfColorToolWithSize:CGSizeMake(buttonSize, buttonSize) toolFillColor:color toolStrokeColor:[kToolStrokeColor colorWithAlphaComponent:0.3]];
        
        [button setImage:image forState:UIControlStateNormal];
        button.contentMode = UIViewContentModeScaleToFill;
        
        yOffset += buttonSize + buttonSpacing;
    }];
    
    [self.colorPaletteView setContentSize:CGSizeMake(40, yOffset)];
    [self.colorPaletteView setContentInset:UIEdgeInsetsMake(buttonSpacing, 0, 0, 0)];
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

#pragma mark - UI

- (UIButton *) buttonForTool: (id <SFSketchTool>) tool
{
    if ([tool isKindOfClass:[SFSketchPenTool class]]) {
        return self.penToolButton;
    }
    else if ([tool isKindOfClass:[SFSketchHighligherTool class]]) {
        return self.markerToolButton;
    }
    else {
        return self.eraserToolButton;
    }
}

- (UIButton *) buttonForPointSize: (SFSketchPointSize) pointSize
{
    switch (pointSize) {
        case SFSketchPointSizeSmall:
            return self.smallPointButton;
            break;
        case SFSketchPointSizeMedium:
            return self.mediumPointButton;
            break;
        case SFSketchPointSizeLarge:
            return self.bigPointButton;
            break;
        default:
            return nil;
            break;
    }
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

#pragma mark - Palette handling

- (IBAction)togglePalette:(id)sender
{
    self.paletteClosed = !self.paletteClosed;
    
    [self.colorPaletteView setHidden:self.paletteClosed];
    [self.pointPickerView setHidden:self.paletteClosed];

    [self updatePaletteToggleIcon];
}


#pragma mark - Points

- (IBAction)setSmallPointSize:(id)sender
{
    [self setPointSize:SFSketchPointSizeSmall];
    [self updatePointPickerIcons];
    [self updatePaletteToggleIcon];
}

- (IBAction)setMediumPointSize:(id)sender
{
    [self setPointSize:SFSketchPointSizeMedium];
    [self updatePointPickerIcons];
    [self updatePaletteToggleIcon];
}

- (IBAction)setLargePointSize:(id)sender
{
    [self setPointSize:SFSketchPointSizeLarge];
    [self updatePointPickerIcons];
    [self updatePaletteToggleIcon];
}

- (void) setPointSize: (SFSketchPointSize) pointSize
{
    self.currentPointSize = pointSize;
    self.currentTool.tipSize = [self pixelSizeForPointSize:pointSize tool:self.currentTool];
}

- (CGFloat) pixelSizeForPointSize: (SFSketchPointSize) pointSize tool: (id <SFSketchTool>) tool
{
    switch (pointSize) {
        case SFSketchPointSizeSmall:
            if ([tool isKindOfClass:[SFSketchPenTool class]]) { return 0.8; }
            else { return  20; }
            break;
        case SFSketchPointSizeMedium:
            if ([tool isKindOfClass:[SFSketchPenTool class]]) { return 3; }
            else { return  30; }
            break;
        case SFSketchPointSizeLarge:
            if ([tool isKindOfClass:[SFSketchPenTool class]]) { return 10; }
            else { return  40; }
            break;
        default:
            break;
    }
    
    return 1;
}


#pragma mark - Tools

- (IBAction)usePenTool:(id)sender
{
    SFSketchPenTool *tool = [SFSketchPenTool new];
    [self setCurrentTool:tool];
    [self updateToolIcons];
}

- (IBAction)useHighlighterTool:(id)sender
{
    SFSketchHighligherTool *tool = [SFSketchHighligherTool new];
    [self setCurrentTool:tool];
    [self updateToolIcons];
}


- (IBAction)useEraserTool:(id)sender
{
    SFSketchEraserTool *tool = [SFSketchEraserTool new];
    [self setCurrentTool:tool];
    [self updateToolIcons];
}


- (id <SFSketchTool>) currentTool
{
    return self.sketchView.currentTool;
}

- (void) setCurrentTool: (id <SFSketchTool>) tool
{
    tool.color = self.currentColor;
    tool.tipSize =  [self pixelSizeForPointSize:self.currentPointSize tool:tool];
    self.sketchView.currentTool = tool;
}

#pragma mark - Colors

- (IBAction)colorButtonTapped:(id)sender
{
    UIButton *button = sender;
    button.transform = CGAffineTransformMakeScale(0.85f, 0.85f);
    [UIView animateWithDuration:0.2f animations:^{
        button.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }completion:nil];

    
    UIColor *color = [self.availableColors objectAtIndex:[sender tag]];
    [self setPointColor:color];
    
    [self updateToolIcons];
    [self updatePointPickerIcons];
    [self updatePaletteToggleIcon];
}

- (void) setPointColor: (UIColor *) pointColor
{
    self.currentColor = pointColor;
    self.currentTool.color = pointColor;
}

#pragma mark - Icons

- (void) updateToolIcons
{
    UIButton *currentToolButton = [self buttonForTool:self.currentTool];
    
    // Pen
    {
        BOOL selected = self.penToolButton == currentToolButton;
        UIImage *image = [SFSketchIconsKit imageOfPenToolWithToolFillColor:kToolFillColor
                                                            pointFillColor: selected ? self.currentColor : kToolPointColor
                                                           toolStrokeColor:kToolStrokeColor];
        [self.penToolButton setImage:image forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.20 animations:^{
            CGRect newFrame = self.penToolButton.frame;
            newFrame.origin.y = selected ? 20 : 40;
            self.penToolButton.frame = newFrame;
        }];
    }

    // Marker
    {
        BOOL selected = self.markerToolButton == currentToolButton;
        UIImage *image = [SFSketchIconsKit imageOfMarkerToolWithToolFillColor:kToolFillColor
                                                               pointFillColor:selected ? self.currentColor : kToolPointColor
                                                              toolStrokeColor:kToolStrokeColor];
        [self.markerToolButton setImage:image forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.20 animations:^{
            CGRect newFrame = self.markerToolButton.frame;
            newFrame.origin.y = selected ? 20 : 40;
            self.markerToolButton.frame = newFrame;
        }];
    }
    
    // Eraser
    {
        BOOL selected = self.eraserToolButton == currentToolButton;
        UIImage *image = [SFSketchIconsKit imageOfEraserToolWithToolFillColor:kToolFillColor
                                                               pointFillColor:kToolPointColor
                                                              toolStrokeColor:kToolStrokeColor];
        [self.eraserToolButton setImage:image forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.20 animations:^{
            CGRect newFrame = self.eraserToolButton.frame;
            newFrame.origin.y = selected ? 15 : 40;
            self.eraserToolButton.frame = newFrame;
        }];

    }
}

- (CGRect) iconPointRectForPointSize: (SFSketchPointSize) pointSize
{
    switch (pointSize) {
        case SFSketchPointSizeSmall:
            return CGRectMake(16.5, 16.5, 7.5, 7.5);
            break;
        case SFSketchPointSizeMedium:
            return CGRectMake(12, 12, 16.5, 16.5);
            break;
        case SFSketchPointSizeLarge:
            return CGRectMake(8, 8, 24.5, 24.5);
            break;
        default:
            break;
    }
    
    return CGRectZero;
}

- (void) updatePointPickerIcons
{
    CGSize buttonSize = CGSizeMake(40, 40);
    
    UIButton *currentPointButton = [self buttonForPointSize:self.currentPointSize];
    
    UIImage *smallPointIcon = [SFSketchIconsKit imageOfPointToolWithSize:buttonSize
                                                           toolFillColor:kToolFillColor
                                                          pointFillColor:self.smallPointButton == currentPointButton ? self.currentColor : kToolStrokeColor
                                                         toolStrokeColor:kToolStrokeColor
                                                               pointRect:[self iconPointRectForPointSize:SFSketchPointSizeSmall]];
    [self.smallPointButton setImage:smallPointIcon forState:UIControlStateNormal];
    
    
    UIImage *mediumPointIcon = [SFSketchIconsKit imageOfPointToolWithSize:buttonSize
                                                            toolFillColor:kToolFillColor
                                                           pointFillColor:self.mediumPointButton == currentPointButton ? self.currentColor : kToolStrokeColor
                                                          toolStrokeColor:kToolStrokeColor
                                                                pointRect:[self iconPointRectForPointSize:SFSketchPointSizeMedium]];
    [self.mediumPointButton setImage:mediumPointIcon forState:UIControlStateNormal];
    
    
    UIImage *bigPointIcon = [SFSketchIconsKit imageOfPointToolWithSize:buttonSize
                                                         toolFillColor:kToolFillColor
                                                        pointFillColor:self.bigPointButton == currentPointButton ? self.currentColor : kToolStrokeColor
                                                       toolStrokeColor:kToolStrokeColor
                                                             pointRect:[self iconPointRectForPointSize:SFSketchPointSizeLarge]];
    [self.bigPointButton setImage:bigPointIcon forState:UIControlStateNormal];
    
}

- (void) updatePaletteToggleIcon
{
    CGSize buttonSize = CGSizeMake(40, 40);

    UIImage *icon;
    
    if (self.paletteClosed) {
        icon = [SFSketchIconsKit imageOfPointToolWithSize:buttonSize
                                            toolFillColor:kToolFillColor
                                           pointFillColor:self.currentColor
                                          toolStrokeColor:kToolStrokeColor
                                                pointRect:[self iconPointRectForPointSize:self.currentPointSize]];
    }
    else {
        icon = [SFSketchIconsKit imageOfCloseIconWithToolStrokeColor:kToolStrokeColor];
    }
    
    [self.paletteToggleButton setImage:icon forState:UIControlStateNormal];
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [(SFSketchScrollView *)self.scrollView centerContent];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.sketchView;
}

@end
