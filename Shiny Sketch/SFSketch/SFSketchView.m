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

@property (nonatomic) CGContextRef imageContext;
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

- (CGContextRef)imageContext
{
    if (!_imageContext) {
        CGFloat scale = self.window.screen.scale;
        CGSize size = self.bounds.size;
        size.width *= scale; size.height *= scale;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        _imageContext = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        CGContextConcatCTM(_imageContext, scaleTransform);
        
        CGColorSpaceRelease(colorSpace);
    }
    
    return _imageContext;
}

#pragma mark - Clear

- (void) clear
{
    [self.strokes removeAllObjects];
    
    CGSize imageContextSize = CGSizeMake(CGBitmapContextGetWidth(self.imageContext), CGBitmapContextGetHeight(self.imageContext));
    CGContextClearRect(self.imageContext, CGRectMake(0, 0, imageContextSize.width, imageContextSize.height));
    
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
    
    CGRect rectToRedraw = [self.currentStroke.tool boundsForLastLineSegmnet:self.currentStroke.line];
    [self setNeedsDisplayInRect:rectToRedraw];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    [self.currentStroke.line removePointsForType:SFSketchPointTypePredicted];

    for (UITouch *touch in touches) {

        [self.currentStroke.line addPointForTouch:touch type:SFSketchPointTypeStandard];
        
        UITouch *predictedTouch = [[event predictedTouchesForTouch:touch] firstObject];
        if (predictedTouch) {
            [self.currentStroke.line addPointForTouch:predictedTouch type:SFSketchPointTypePredicted];
        }
    }

    CGRect rectToRedraw = [self.currentStroke.tool boundsForLastLineSegmnet:self.currentStroke.line];
    [self setNeedsDisplayInRect:rectToRedraw];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self.currentStroke.tool drawLine:self.currentStroke.line inContext:_imageContext];
    
    self.currentStroke.line = nil;
    if (_image) {
        CFRelease(_image);
        _image = nil;        
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    CGRect boundToRefresh = [self.currentTool boundsForLine:self.currentStroke.line];

    [self.strokes removeObject:self.currentStroke];
    self.currentStroke = nil;
    
    [self setNeedsDisplayInRect:boundToRefresh];
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!_image) {
        _image = CGBitmapContextCreateImage(self.imageContext);

    }
    CGContextDrawImage(context, self.bounds, _image);
    
    //[[UIColor redColor] setStroke];
    //[[UIBezierPath bezierPathWithRect:rect] stroke];

    [self.currentStroke.tool drawLine:self.currentStroke.line inContext:context];

    //[[UIColor redColor] setStroke];
    //[[UIBezierPath bezierPathWithRect:currentLine.lineBounds] stroke];
}

@end
