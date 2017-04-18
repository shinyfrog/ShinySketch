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


@end

@implementation SFSketchView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.strokes = [NSMutableArray array];
    }
    return self;
}

- (CGContextRef)bitmapContext
{
    CGFloat scale = self.window.screen.scale;
    CGSize size = self.bounds.size;
    size.width *= scale; size.height *= scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bitmapContext = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
    CGContextConcatCTM(bitmapContext, scaleTransform);
    
    CGColorSpaceRelease(colorSpace);
    
    return bitmapContext;
}

#pragma mark - Clear

- (void) clear
{
    [self.strokes removeAllObjects];
    
    if (_image) {
        CFRelease(_image);
        _image = nil;
    }
    
    [self setNeedsDisplayInRect:self.bounds];
}


#pragma mark - Touch event handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    [super touchesBegan:touches withEvent:event];
    
    self.currentStroke = [SFSketchStroke new];
    self.currentStroke.line = [SFSketchLine new];
    self.currentStroke.tool = self.currentTool;
    
    [self.strokes addObject:self.currentStroke];

    for (UITouch *touch in touches) {
        [self.currentStroke.line addPointForTouch:touch type:SFSketchPointTypeStandard];
    }
    
    CGRect rectToRedraw = [self.currentStroke boundsForLastSegment];
    [self setNeedsDisplayInRect:rectToRedraw];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    [self.currentStroke.line removePointsForType:SFSketchPointTypePredicted];

    for (UITouch *touch in touches) {

        [self.currentStroke.line addPointForTouch:touch type:SFSketchPointTypeStandard];
        
        /*for (UITouch *predictedTouch in [event predictedTouchesForTouch:touch]) {
            [self.currentStroke.line addPointForTouch:predictedTouch type:SFSketchPointTypePredicted];
        }*/
        
        /*UITouch *predictedTouch = [[event predictedTouchesForTouch:touch] firstObject];
        if (predictedTouch) {
            [self.currentStroke.line addPointForTouch:predictedTouch type:SFSketchPointTypePredicted];
        }*/
    }

    CGRect rectToRedraw = [self.currentStroke boundsForLastSegment];
    [self setNeedsDisplayInRect:rectToRedraw];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    [self.currentStroke.line removePointsForType:SFSketchPointTypePredicted];

    for (UITouch *touch in touches) {
        [self.currentStroke.line addPointForTouch:touch type:SFSketchPointTypeStandard];
    }
    
    
    CGRect rectToRedraw = [self.currentStroke boundsForLastSegment];
    
    CGContextRef bitmapContext = [self bitmapContext];
    
    if (_image) {
        CGContextDrawImage(bitmapContext, self.bounds, _image);
    }
    
    [self.currentStroke drawRect:self.bounds inContext:bitmapContext];
    
    CGImageRelease(_image);

    _image = CGBitmapContextCreateImage(bitmapContext);
    
    CGContextRelease(bitmapContext);

    self.currentStroke = nil;

    [self setNeedsDisplayInRect:rectToRedraw];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    CGRect boundToRefresh = [self.currentStroke boundsForLastSegment];

    [self.strokes removeObject:self.currentStroke];
    self.currentStroke = nil;
    
    [self setNeedsDisplayInRect:boundToRefresh];
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    CGContextRef bitmapContext = [self bitmapContext];
    
    // We have a cached image, drawing it on the bitmap context
    if (_image) {
        CGContextDrawImage(bitmapContext, self.bounds, _image);
    }
    // We have a on-going stroke, drawing it on the bitmap context
    if (_currentStroke) {
        [self.currentStroke drawRect:rect inContext:bitmapContext];
    }
    
    // Creating an image from the bitmap context
    CGImageRef img = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
   
    // Drawing the final image
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, self.bounds, img);
    
    // Releasing the image
    CGImageRelease(img);

    // Debug
    //[[UIColor redColor] setStroke];
    //[[UIBezierPath bezierPathWithRect:[self.currentStroke.tool boundsForLastLineSegmnet:self.currentStroke.line]] stroke];
}

@end
