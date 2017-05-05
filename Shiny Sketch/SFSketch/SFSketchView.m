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

#pragma mark - Clear

- (void) clear
{
    [self.strokes removeAllObjects];
    
    self.currentBitmapContext = nil;
    
    if (_image) {
        CFRelease(_image);
        _image = nil;
    }
    
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

    if (self.image) {
        CGImageRelease(_image);
    }
    
    self.image = CGBitmapContextCreateImage(self.currentBitmapContext);
    
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
