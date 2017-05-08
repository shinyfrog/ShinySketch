//
//  SFSketchView.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 15/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "SFSketchView.h"
#import "SFSketchLine.h"
#import "SFSketchStroke.h"

@interface SFSketchView ()

@property (nonatomic) CGImageRef image;

@property (strong) NSMutableArray *strokes;
@property (strong) SFSketchStroke *currentStroke;

@property (nonatomic) CGContextRef currentBitmapContext;

@property (strong) NSUndoManager *sketchUndoManager;

@end

@implementation SFSketchView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void) setupView
{
    self.strokes = [NSMutableArray array];
    self.initialSize = self.bounds.size;
    
    self.sketchUndoManager = [NSUndoManager new];
}

- (void) scaleViewForNewSize:(CGSize)size
{
    CGFloat scale;
    
    if (self.initialSize.width > self.initialSize.height) {
        scale = size.width / self.initialSize.width;
    }
    else {
        scale = size.height / self.initialSize.height;
    }
    
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    
    self.transform = transform;
}

- (CGContextRef)bitmapContext
{
    CGFloat scale = self.window.screen.scale;
    CGSize size = self.initialSize;
    size.width *= scale; size.height *= scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bitmapContext = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
    CGContextConcatCTM(bitmapContext, scaleTransform);
    
    CGColorSpaceRelease(colorSpace);
    
    return bitmapContext;
}

- (void)setCurrentBitmapContext:(CGContextRef)currentBitmapContext
{
    if (self.currentBitmapContext) {
        CGContextRelease(self.currentBitmapContext);
    }

    _currentBitmapContext = currentBitmapContext;
}

- (void)setImage:(CGImageRef)image
{
    if (self.image) {
        CGImageRelease(self.image);
    }

    _image = image;
}


#pragma mark - Clear

- (void) clear
{
    // copying the array doesn't duplicate the strokes, but allows the undo manager to work correctly
    [self removeStrokesAndRedraw:[self.strokes copy]];
}


#pragma mark - Undo / Redo

- (IBAction)undo:(id)sender
{
    [self.sketchUndoManager undo];
}

- (IBAction)redo:(id)sender
{
    [self.sketchUndoManager redo];
}


#pragma mark - Strokes Handling

- (void) removeStrokesAndRedraw: (NSArray *) strokes
{
    [[self.sketchUndoManager prepareWithInvocationTarget:self] addStrokesAndRedraw:strokes];

    [self.strokes removeObjectsInArray:strokes];
    self.image = [self imageFromStrokes:self.strokes];
    [self setNeedsDisplayInRect:self.bounds];
    
}

- (void) addStrokesAndRedraw: (NSArray *) strokes
{
    [[self.sketchUndoManager prepareWithInvocationTarget:self] removeStrokesAndRedraw:strokes];

    [self.strokes addObjectsFromArray:strokes];
    self.image = [self imageFromStrokes:self.strokes];
    [self setNeedsDisplayInRect:self.bounds];
    
}



#pragma mark - Touch event handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch Began");
    
    [super touchesBegan:touches withEvent:event];
    
    self.currentBitmapContext = [self bitmapContext];
    if (self.image) {
        CGContextDrawImage(self.currentBitmapContext, self.bounds, _image);
    }
    
    self.currentStroke = [SFSketchStroke new];
    self.currentStroke.line = [SFSketchLine new];
    self.currentStroke.tool = self.currentTool;
    [self.strokes addObject:self.currentStroke];

    CGRect rectToRedraw = [self.currentStroke drawTouches:touches event:event inContext:self.currentBitmapContext];
    
    [self setNeedsDisplayInRect:rectToRedraw];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"Touch Moved");
    
    [super touchesMoved:touches withEvent:event];
    
    CGRect rectToRedraw = [self.currentStroke drawTouches:touches event:event inContext:self.currentBitmapContext];
    
    [self setNeedsDisplayInRect:rectToRedraw];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch Ended");

    [super touchesEnded:touches withEvent:event];

    CGRect rectToRedraw = [self.currentStroke drawTouches:touches event:event inContext:self.currentBitmapContext];
    
    [self setNeedsDisplayInRect:rectToRedraw];
    
    self.image = CGBitmapContextCreateImage(self.currentBitmapContext);
    
    [[self.sketchUndoManager prepareWithInvocationTarget:self] removeStrokesAndRedraw:@[self.currentStroke]];
    
    self.currentStroke = nil;
    self.currentBitmapContext = nil;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch Cancelled");

    [super touchesCancelled:touches withEvent:event];

    [self.strokes removeObject:self.currentStroke];
    self.currentStroke = nil;
    self.currentBitmapContext = nil;
    
    [self setNeedsDisplayInRect:self.bounds];
}

#pragma mark - Draw

- (CGImageRef) imageFromStrokes: (NSArray *) strokes
{
    CGContextRef context = [self bitmapContext];
    for (SFSketchStroke *stroke in strokes) {
        [stroke drawInContext:context];
    }
    
    CGImageRef img = CGBitmapContextCreateImage(context);

    CGContextRelease(context);

    return img;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (self.currentBitmapContext) {
        // Creating an image from the bitmap context
        CGImageRef img = CGBitmapContextCreateImage(self.currentBitmapContext);
        
        // Drawing the final image
        CGContextDrawImage(context, self.bounds, img);
        
        // Releasing the image
        CGImageRelease(img);
    }
    else {
        // Drawing the final image
        CGContextDrawImage(context, self.bounds, self.image);
    }
}

@end
