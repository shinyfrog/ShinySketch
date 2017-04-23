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

    /*
    for (UITouch *touch in touches) {
        [self.currentStroke.line addPointForTouch:touch type:SFSketchPointTypeStandard];
    }

    CGRect rectToRedraw = [self.currentStroke boundsForLastSegment];

    [self.currentStroke drawRect:rectToRedraw inContext:self.currentBitmapContext];
    
    [self setNeedsDisplayInRect:rectToRedraw];
 */
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"Touch Moved");
    
    [super touchesMoved:touches withEvent:event];
    
    CGRect rectToRedraw = [self.currentStroke drawTouches:touches event:event inContext:self.currentBitmapContext];
    
    [self setNeedsDisplayInRect:rectToRedraw];

    //creare un contesto nuovo
    //disegnare l’immagine di cache
    //disegnare solo i nuovi punti

    /*
    [self.currentStroke.line removePointsForType:SFSketchPointTypePredicted];

    for (UITouch *touch in touches) {

        [self.currentStroke.line addPointForTouch:touch type:SFSketchPointTypeStandard];
        
//        for (UITouch *predictedTouch in [event predictedTouchesForTouch:touch]) {
//            [self.currentStroke.line addPointForTouch:predictedTouch type:SFSketchPointTypePredicted];
//        }
//        
//        UITouch *predictedTouch = [[event predictedTouchesForTouch:touch] firstObject];
//        if (predictedTouch) {
//            [self.currentStroke.line addPointForTouch:predictedTouch type:SFSketchPointTypePredicted];
//        }
    }

    CGRect rectToRedraw = [self.currentStroke boundsForLastSegment];
    
    //CGContextClearRect(self.currentBitmapContext, rectToRedraw);
    
    if (self.image) {
        //CGContextDrawImage(self.currentBitmapContext, self.bounds, _image);
    }

    [self.currentStroke drawRect:rectToRedraw inContext:self.currentBitmapContext];

    [self setNeedsDisplayInRect:rectToRedraw];*/
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

    /*
    [self.currentStroke.line removePointsForType:SFSketchPointTypePredicted];

    for (UITouch *touch in touches) {
        [self.currentStroke.line addPointForTouch:touch type:SFSketchPointTypeStandard];
    }
    
    
    CGRect rectToRedraw = [self.currentStroke boundsForLastSegment];
    
    [self.currentStroke drawRect:rectToRedraw inContext:self.currentBitmapContext];
    
    if (self.image) {
        CGImageRelease(_image);
    }
    
    self.image = CGBitmapContextCreateImage(self.currentBitmapContext);

    self.currentStroke = nil;
     */

    /*
    CGContextRef bitmapContext = [self bitmapContext];
    
    if (_image) {
        CGContextDrawImage(bitmapContext, self.bounds, _image);
    }
    
    [self.currentStroke drawRect:self.bounds inContext:bitmapContext];
    
    CGImageRelease(_image);

    _image = CGBitmapContextCreateImage(bitmapContext);
    
    CGContextRelease(bitmapContext);

    self.currentStroke = nil;
     */

    //[self setNeedsDisplayInRect:rectToRedraw];
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
    /*
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
*/
    // Debug
    //[[UIColor redColor] setStroke];
    //[[UIBezierPath bezierPathWithRect:[self.currentStroke.tool boundsForLastLineSegmnet:self.currentStroke.line]] stroke];
}

@end
