//
//  SFSketchView.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 15/03/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "SFSketchView.h"
#import "SFSketchLine.h"

@interface SFSketchView ()

@property (strong) NSMutableArray *lines;
@property (nonatomic) CGContextRef imageContext;
@property (nonatomic) CGImageRef image;

@end

@implementation SFSketchView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.lines = [NSMutableArray array];
    }
    return self;
}

- (SFSketchLine *) currentLine
{
    return [self.lines lastObject];
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
    [self.lines removeAllObjects];
    
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
    SFSketchLine *currentLine = [SFSketchLine new];
    [self.lines addObject:currentLine];

    for (UITouch *touch in touches) {
        [currentLine addPointForTouch:touch type:SFSketchPointTypeStandard];

        [currentLine addPointsForPredictedTouches:[event predictedTouchesForTouch:touch]];
        [currentLine addPointsForCoalescedTouches:[event coalescedTouchesForTouch:touch]];

    }
    
    [self setNeedsDisplayInRect:[currentLine boundForLatestUpdate]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    SFSketchLine *currentLine = [self currentLine];

    for (UITouch *touch in touches) {
        [currentLine addPointForTouch:touch type:SFSketchPointTypeStandard];
        
        [currentLine addPointsForPredictedTouches:[event predictedTouchesForTouch:touch]];
        [currentLine addPointsForCoalescedTouches:[event coalescedTouchesForTouch:touch]];
    }

    [self setNeedsDisplayInRect:[currentLine boundForLatestUpdate]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SFSketchLine *currentLine = [self currentLine];
    [currentLine drawInContext:_imageContext];
    CFRelease(_image);
    _image = nil;
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
    
    SFSketchLine *currentLine = [self currentLine];
    [currentLine drawInContext:context];

    [[UIColor redColor] setStroke];
    [[UIBezierPath bezierPathWithRect:rect] stroke];
    
}

@end
