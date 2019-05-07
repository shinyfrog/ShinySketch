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

typedef NS_ENUM(NSInteger, SFSketchToolKind)
{
    SFSketchToolPen,
    SFSketchToolHighligher,
    SFSketchToolEraser,
};

@interface SFSketchViewController () <SFSketchViewDelegate, UIPencilInteractionDelegate>

@property (strong) NSArray *availableColors;

@property (strong) UIColor *currentColor;
@property (nonatomic) SFSketchPointSize currentPointSize;

@property (nonatomic) BOOL paletteClosed;

@property (nonatomic, strong) UIImage *initialImage;

@property (strong) id <SFSketchTool> previousTool;


@end

@implementation SFSketchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.paletteClosed = YES;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
    
    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    if (self.initialImage) {
        size = self.initialImage.size;
    }
    
    [self newDrawCanvasWithSize:size image:self.initialImage];

    [self setupCanvasScrollViewWithSize:self.view.bounds.size contentSize:size];
    [self setupColorPalette];
    [self setupToolbarIcons];
    [self setupApplePencil];

    [self loadToolFromPreference];
    [self loadPointSizeFromPreference];
    [self loadColorFromPreferences];

    [self updatePointPickerIcons];
    [self updatePaletteToggleIcon];
    [self updateUndoRedoButtonStatus];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [(SFSketchScrollView *)self.scrollView centerContent];
}

- (void)viewDidAppear:(BOOL)animated
{
    CGPoint bottomOffset = CGPointMake(0, self.colorPaletteView.contentSize.height - self.colorPaletteView.bounds.size.height);
    [self.colorPaletteView setContentOffset:bottomOffset animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveCurrentToolToPreferences];
    [self saveCurrentPointSizeToPreferences];
    [self saveCurrentColorToPreferences];
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

        [self updateScrollViewForSize:size];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self updateColorSeparatorVisibility];
    }];
    
    [self updateToolPaletteVisibilityForSize:size animated:YES];
}

#pragma mark - Setups

- (void) setInitialImage: (UIImage *) image
{
    _initialImage = image;
}

- (void) setupCanvasScrollViewWithSize: (CGSize) size contentSize: (CGSize) contentSize
{
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.contentSize=contentSize;
    self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    
    [self updateScrollViewForSize:size];
}

- (void) updateScrollViewForSize: (CGSize) size
{
#warning lo zoom non tiene conto se una delle due dimensioni è maggiore del contenitore, guardare come fare a fixare
    CGFloat newScale;
    if (self.sketchView.initialSize.width > self.sketchView.initialSize.height) {
        newScale = size.width / self.sketchView.initialSize.width;
    }
    else {
        newScale = size.height / self.sketchView.initialSize.height;
    }
    
    
    // Setting the new minimum scale
    self.scrollView.minimumZoomScale = newScale;
    
    // if the current canvas is zoomed we don't change anything
    //CGFloat currentZoom = self.scrollView.zoomScale;
    //if (currentZoom <= 1.0) {
    [self.scrollView setZoomScale:newScale];
    //}
    
    [(SFSketchScrollView *)self.scrollView centerContent];

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

- (void) setupToolbarIcons
{
    // Dinamically creating the background image for the nav bar
    UIGraphicsBeginImageContext(CGSizeMake(50, 50));
    [[[UIColor whiteColor] colorWithAlphaComponent:0.9] setFill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 50, 50)] fill];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Removing the 1px bottom shadow
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    // Using our custom alpha background image
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    [self.undoButton setImage:[SFSketchIconsKit imageOfUndoIconWithIconStrokeColor:kToolStrokeColor] forState:UIControlStateNormal];
    [self.redoButton setImage:[SFSketchIconsKit imageOfRedoIconWithIconStrokeColor:kToolStrokeColor] forState:UIControlStateNormal];
    [self.backButton setImage:[SFSketchIconsKit imageOfBackIconWithIconStrokeColor:kToolStrokeColor] forState:UIControlStateNormal];
    [self.shareButton setImage:[SFSketchIconsKit imageOfShareIconWithIconStrokeColor:kToolStrokeColor] forState:UIControlStateNormal];
}


- (void)newDrawCanvasWithSize:(CGSize)size image: (UIImage *) image
{
    [self.sketchView removeFromSuperview];
    
    SFSketchView *sketchView = [[SFSketchView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sketchView.backgroundColor = [UIColor whiteColor];
    
    self.sketchView = sketchView;
    self.sketchView.delegate = self;
    
    UIView *superView = self.scrollView;
    [superView addSubview:self.sketchView];
    
    if (image) {
        [self.sketchView setInitialImage:[image CGImage]];
    }
}

- (UIImage *)currentImage
{
    return [self.sketchView bitmapImage];
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

- (IBAction)share:(id)sender
{
    NSMutableArray *activityItems = [NSMutableArray array];
    
    UIImage *image = [self.sketchView bitmapImage];
    
    [activityItems addObject:image];

    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    if ( [controller respondsToSelector:@selector(popoverPresentationController)] ) {
        // defines the source view of the activity controller in iOS8 (prevent crashes on iPad)
        controller.popoverPresentationController.sourceView = sender;
        controller.popoverPresentationController.sourceRect = [sender bounds];
    }
    [self presentViewController:controller animated:YES completion:nil];

}

- (IBAction)clear:(id)sender
{
    [self.sketchView clear];
}

- (IBAction)redraw:(id)sender
{
    [self.sketchView setNeedsDisplayInRect:self.sketchView.bounds];
}

- (IBAction)dismissSketcher:(id)sender
{
    if (![self.delegate respondsToSelector:@selector(sketchViewController:didFinishSketching:)]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    UIImage *bitmapImage;
    if (self.sketchView.imageChanged) {
        bitmapImage = [self.sketchView bitmapImage];
    }
    
    // the parent view controller should handle the dismissal of the current view controller
    // in order to be able to manage the completion
    [self.delegate sketchViewController:self didFinishSketching:bitmapImage];
}

#pragma mark - Palette handling

- (IBAction)togglePalette:(id)sender
{
    self.paletteClosed = !self.paletteClosed;
    
    [self.colorPaletteView setHidden:self.paletteClosed];
    [self.pointPickerView setHidden:self.paletteClosed];

    CGFloat alphaBefore = self.paletteClosed ? 1 : 0;
    CGFloat alphaAfter = self.paletteClosed ? 0 : 1;
    
    self.colorPaletteView.alpha = alphaBefore;
    self.pointPickerView.alpha = alphaBefore;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.colorPaletteView.alpha = alphaAfter;
        self.pointPickerView.alpha = alphaAfter;
    }completion:nil];

    

    [self updatePaletteToggleIcon];
    [self updateToolPaletteVisibilityForSize:self.view.bounds.size animated:NO];
    [self updateColorSeparatorVisibility];
}

- (void) updateToolPaletteVisibilityForSize: (CGSize) size animated: (BOOL) animated
{
    if (!self.paletteClosed) {
        if (size.width <= 400) {
            [self setToolPaletteVisible:NO animated:animated];
        }
        else {
            [self setToolPaletteVisible:YES animated:animated];
        }
    }
    else {
        [self setToolPaletteVisible:YES animated:animated];
    }
}

- (void) updateColorSeparatorVisibility
{
    if (self.paletteClosed) {
        [self.colorSeparatorView setHidden:YES];
        return;
    }
    
    CGFloat diff = self.colorPaletteView.contentSize.height - self.colorPaletteView.frame.size.height;
    if (diff - self.colorPaletteView.contentOffset.y > 10) {
        [self.colorSeparatorView setHidden:NO];
    }
    else {
        [self.colorSeparatorView setHidden:YES];
    }
}

- (void) setToolPaletteVisible: (BOOL) visible animated: (BOOL) animated
{
    CGFloat alphaBefore = visible ? 0 : 1;
    CGFloat alphaAfter = visible ? 1 : 0;

    if (visible) {
        [self.toolPickerView setHidden:NO];
    }
    
    self.toolPickerView.alpha = alphaBefore;

    CGFloat duration = animated ? 0.2f : 0;
    [UIView animateWithDuration:duration animations:^{
        self.toolPickerView.alpha = alphaAfter;
    } completion:^(BOOL finished) {
        [self.toolPickerView setHidden:!alphaAfter];
    }];

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

- (IBAction)switchToPreviousTool:(id)sender
{
    [self setCurrentTool:self.previousTool];
    [self updateToolIcons];
}

- (IBAction)toggleEraser:(id)sender
{
    if ([[self currentTool] isKindOfClass:[SFSketchEraserTool class]]) {
        [self switchToPreviousTool:sender];
    }
    else {
        [self useEraserTool:self];
    }
}

- (id <SFSketchTool>) currentTool
{
    return self.sketchView.currentTool;
}

- (void) setCurrentTool: (id <SFSketchTool>) tool
{
    self.previousTool = self.sketchView.currentTool;
    
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
    
}

- (void) setPointColor: (UIColor *) pointColor
{
    self.currentColor = pointColor;
    self.currentTool.color = pointColor;
    
    [self updateToolIcons];
    [self updatePointPickerIcons];
    [self updatePaletteToggleIcon];
}

#pragma mark - Icons

- (void) updateToolIcons
{
    UIButton *currentToolButton = [self buttonForTool:self.currentTool];
    
    // Pen
    {
        BOOL selected = self.penToolButton == currentToolButton;
        
        UIImage *image = [SFSketchIconsKit imageOfPenToolStrokeWithToolFillColor:kToolFillColor
                                                                  pointFillColor:selected ? self.currentColor : kToolPointColor
                                                                 toolStrokeColor:kToolStrokeColor
                                                                pointStrokeColor:[kToolStrokeColor colorWithAlphaComponent:0.5]];

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
        
        UIImage *image = [SFSketchIconsKit imageOfMarkerToolStrokeWithToolFillColor:kToolFillColor
                                                                     pointFillColor:selected ? self.currentColor : kToolPointColor
                                                                    toolStrokeColor:kToolStrokeColor
                                                                   pointStrokeColor:[kToolStrokeColor colorWithAlphaComponent:0.5]];

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
        UIImage *image = [SFSketchIconsKit imageOfEraserToolWithToolFillColor:kToolFillColor toolStrokeColor:kToolStrokeColor];

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
            return CGRectMake(16, 16, 8.5, 8.5);
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
                                                        pointStrokeColor:[kToolStrokeColor colorWithAlphaComponent:0.4]
                                                               pointRect:[self iconPointRectForPointSize:SFSketchPointSizeSmall]
                                                         strokePointRect:CGRectInset([self iconPointRectForPointSize:SFSketchPointSizeSmall], 0.5, 0.5)];
    
    
    
    [self.smallPointButton setImage:smallPointIcon forState:UIControlStateNormal];
    
    
    UIImage *mediumPointIcon = [SFSketchIconsKit imageOfPointToolWithSize:buttonSize
                                                            toolFillColor:kToolFillColor
                                                           pointFillColor:self.mediumPointButton == currentPointButton ? self.currentColor : kToolStrokeColor
                                                          toolStrokeColor:kToolStrokeColor
                                                         pointStrokeColor:[kToolStrokeColor colorWithAlphaComponent:0.4]
                                                                pointRect:[self iconPointRectForPointSize:SFSketchPointSizeMedium]
                                                          strokePointRect:CGRectInset([self iconPointRectForPointSize:SFSketchPointSizeMedium], 0.5, 0.5)];

    [self.mediumPointButton setImage:mediumPointIcon forState:UIControlStateNormal];
    
    
    UIImage *bigPointIcon = [SFSketchIconsKit imageOfPointToolWithSize:buttonSize
                                                         toolFillColor:kToolFillColor
                                                        pointFillColor:self.bigPointButton == currentPointButton ? self.currentColor : kToolStrokeColor
                                                       toolStrokeColor:kToolStrokeColor
                                                      pointStrokeColor:[kToolStrokeColor colorWithAlphaComponent:0.4]
                                                             pointRect:[self iconPointRectForPointSize:SFSketchPointSizeLarge]
                                                       strokePointRect:CGRectInset([self iconPointRectForPointSize:SFSketchPointSizeLarge], 0.5, 0.5)];

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
                                         pointStrokeColor:[kToolStrokeColor colorWithAlphaComponent:0.4]
                                                pointRect:[self iconPointRectForPointSize:self.currentPointSize]
                                          strokePointRect:CGRectInset([self iconPointRectForPointSize:self.currentPointSize], 0.5, 0.5)];

    }
    else {
        icon = [SFSketchIconsKit imageOfCloseIconWithToolStrokeColor:kToolStrokeColor];
    }
    
    [self.paletteToggleButton setImage:icon forState:UIControlStateNormal];
}

#pragma mark - Preferences

- (void) saveCurrentToolToPreferences
{
    SFSketchToolKind tool = SFSketchToolPen;
    
    if ([[self currentTool] isKindOfClass:[SFSketchPenTool class]]) {
        tool = SFSketchToolPen;
    }
    else if ([[self currentTool] isKindOfClass:[SFSketchHighligherTool class]]) {
        tool = SFSketchToolHighligher;
    }
    else if ([[self currentTool] isKindOfClass:[SFSketchEraserTool class]]) {
        tool = SFSketchToolEraser;
    }

    [[NSUserDefaults standardUserDefaults] setObject:@(tool) forKey:@"SFSketchToolKind"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) loadToolFromPreference
{
    NSNumber *tool = [[NSUserDefaults standardUserDefaults] objectForKey:@"SFSketchToolKind"];
    if (tool) {
        switch ([tool longValue]) {
            case SFSketchToolPen:
                [self usePenTool:self];
                break;
            case SFSketchToolHighligher:
                [self useHighlighterTool:self];
                break;
            case SFSketchToolEraser:
                [self useEraserTool:self];
                break;
            default:
                [self usePenTool:self];
                break;
        }
    }
    else {
        [self usePenTool:self];
    }
}

- (void) saveCurrentPointSizeToPreferences
{
    [[NSUserDefaults standardUserDefaults] setObject:@(self.currentPointSize) forKey:@"SFSketchPointSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) loadPointSizeFromPreference
{
    NSNumber *pointSize = [[NSUserDefaults standardUserDefaults] objectForKey:@"SFSketchPointSize"];
    if (pointSize) {
        switch ([pointSize longValue]) {
            case SFSketchPointSizeSmall:
                [self setSmallPointSize:self];
                break;
            case SFSketchPointSizeMedium:
                [self setMediumPointSize:self];
                break;
            case SFSketchPointSizeLarge:
                [self setLargePointSize:self];
                break;
            default:
                [self setSmallPointSize:self];
                break;
        }
    }
    else {
        [self setSmallPointSize:self];
    }
}

- (void) saveCurrentColorToPreferences
{
    NSUInteger currentColorIndex = [self.availableColors indexOfObject:self.currentColor];
    [[NSUserDefaults standardUserDefaults] setObject:@(currentColorIndex) forKey:@"SFSketchColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) loadColorFromPreferences
{
    NSNumber *currentColorIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"SFSketchColor"];
    if (currentColorIndex && self.availableColors.count > [currentColorIndex unsignedIntegerValue]) {
        UIColor *color = [self.availableColors objectAtIndex:[currentColorIndex unsignedIntegerValue]];
        [self setPointColor:color];
    } else {
        [self setPointColor:[UIColor blackColor]];
    }
}

#pragma mark - Undo / Redo

- (void) updateUndoRedoButtonStatus
{
    
    [self.undoButton setEnabled:[self.sketchView.sketchUndoManager canUndo]];
    [self.redoButton setEnabled:[self.sketchView.sketchUndoManager canRedo]];
}

- (IBAction)undo:(id)sender
{
    [self.sketchView undo:sender];
    [self updateUndoRedoButtonStatus];
}

- (IBAction)redo:(id)sender
{
    [self.sketchView redo:sender];
    [self updateUndoRedoButtonStatus];
}

#pragma mark - Apple Pencil

- (void)setupApplePencil
{
    if (@available(iOS 12.1, *)) {
        UIPencilInteraction *pencilInteraction = [UIPencilInteraction new];
        pencilInteraction.delegate = self;
        [self.sketchView addInteraction:pencilInteraction];
    }
}

#pragma mark - UIPencilInteractionDelegate

- (void)pencilInteractionDidTap:(UIPencilInteraction *)interaction API_AVAILABLE(ios(12.1));
{
    switch(UIPencilInteraction.preferredTapAction) {
            
        case UIPencilPreferredActionIgnore:
            break;
            
        /* Switch between the current tool and eraser */
        case UIPencilPreferredActionSwitchEraser:
            [self toggleEraser:self];
            break;
            
        /* Switch between the current tool and the previously used tool */
        case UIPencilPreferredActionSwitchPrevious:
            [self switchToPreviousTool:self];
            break;
            
        /* Show and hide the color palette */
        case UIPencilPreferredActionShowColorPalette:
            [self togglePalette:self];
            break;
            
        default:
            break;
    }
}

#pragma mark - SFSketchViewDelegate

- (void) sketchView: (SFSketchView *) sketchView touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateUndoRedoButtonStatus];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.colorPaletteView) {
        [self updateColorSeparatorVisibility];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        [(SFSketchScrollView *)self.scrollView centerContent];
    }
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        return self.sketchView;
    }
    
    return nil;
}

@end
