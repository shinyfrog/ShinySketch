//
//  SFSketchIconsKit.m
//  (null)
//
//  Created on 11/05/2017.
//  Copyright © 2017 (null). All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//

#import "SFSketchIconsKit.h"


@implementation SFSketchIconsKit

#pragma mark Initialization

+ (void)initialize
{
}

#pragma mark Drawing Methods

+ (void)drawEraserToolWithToolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor
{
    [SFSketchIconsKit drawEraserToolWithFrame: CGRectMake(0, 0, 32, 96) resizing: SFSketchIconsKitResizingBehaviorStretch toolFillColor: toolFillColor pointFillColor: pointFillColor toolStrokeColor: toolStrokeColor];
}

+ (void)drawEraserToolWithFrame: (CGRect)targetFrame resizing: (SFSketchIconsKitResizingBehavior)resizing toolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Resize to Target Frame
    CGContextSaveGState(context);
    CGRect resizedFrame = SFSketchIconsKitResizingBehaviorApply(resizing, CGRectMake(0, 0, 32, 96), targetFrame);
    CGContextTranslateCTM(context, resizedFrame.origin.x, resizedFrame.origin.y);
    CGContextScaleCTM(context, resizedFrame.size.width / 32, resizedFrame.size.height / 96);


    //// Layer_2
    {
        //// Layer_1-2
        {
            //// Eraser
            {
                //// Bezier Drawing
                UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint: CGPointMake(2.5, 52.25)];
                [bezierPath addLineToPoint: CGPointMake(2.5, 52.25)];
                [bezierPath addCurveToPoint: CGPointMake(1.75, 51.5) controlPoint1: CGPointMake(2.09, 52.25) controlPoint2: CGPointMake(1.75, 51.91)];
                [bezierPath addLineToPoint: CGPointMake(1.75, 9.5)];
                [bezierPath addLineToPoint: CGPointMake(1.75, 9.51)];
                [bezierPath addCurveToPoint: CGPointMake(10.51, 0.75) controlPoint1: CGPointMake(1.75, 4.67) controlPoint2: CGPointMake(5.67, 0.75)];
                [bezierPath addLineToPoint: CGPointMake(28, 0.75)];
                [bezierPath addLineToPoint: CGPointMake(28, 0.75)];
                [bezierPath addCurveToPoint: CGPointMake(30.25, 3) controlPoint1: CGPointMake(29.24, 0.75) controlPoint2: CGPointMake(30.25, 1.76)];
                [bezierPath addLineToPoint: CGPointMake(30.25, 51.5)];
                [bezierPath addLineToPoint: CGPointMake(30.25, 51.5)];
                [bezierPath addCurveToPoint: CGPointMake(29.5, 52.25) controlPoint1: CGPointMake(30.25, 51.91) controlPoint2: CGPointMake(29.91, 52.25)];
                [bezierPath addLineToPoint: CGPointMake(2.5, 52.25)];
                [bezierPath closePath];
                [toolFillColor setFill];
                [bezierPath fill];


                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
                [bezier2Path moveToPoint: CGPointMake(28, 1.5)];
                [bezier2Path addLineToPoint: CGPointMake(28, 1.5)];
                [bezier2Path addCurveToPoint: CGPointMake(29.5, 3) controlPoint1: CGPointMake(28.83, 1.5) controlPoint2: CGPointMake(29.5, 2.17)];
                [bezier2Path addLineToPoint: CGPointMake(29.5, 51.5)];
                [bezier2Path addLineToPoint: CGPointMake(2.5, 51.5)];
                [bezier2Path addLineToPoint: CGPointMake(2.5, 9.5)];
                [bezier2Path addLineToPoint: CGPointMake(2.5, 9.5)];
                [bezier2Path addCurveToPoint: CGPointMake(10.5, 1.5) controlPoint1: CGPointMake(2.5, 5.08) controlPoint2: CGPointMake(6.08, 1.5)];
                [bezier2Path addLineToPoint: CGPointMake(28, 1.5)];
                [bezier2Path closePath];
                [bezier2Path moveToPoint: CGPointMake(28, 0)];
                [bezier2Path addLineToPoint: CGPointMake(10.5, 0)];
                [bezier2Path addLineToPoint: CGPointMake(10.51, -0)];
                [bezier2Path addCurveToPoint: CGPointMake(1, 9.51) controlPoint1: CGPointMake(5.26, -0) controlPoint2: CGPointMake(1, 4.26)];
                [bezier2Path addLineToPoint: CGPointMake(1, 51.5)];
                [bezier2Path addLineToPoint: CGPointMake(1, 51.5)];
                [bezier2Path addCurveToPoint: CGPointMake(2.5, 53) controlPoint1: CGPointMake(1, 52.33) controlPoint2: CGPointMake(1.67, 53)];
                [bezier2Path addLineToPoint: CGPointMake(29.5, 53)];
                [bezier2Path addLineToPoint: CGPointMake(29.5, 53)];
                [bezier2Path addCurveToPoint: CGPointMake(31, 51.5) controlPoint1: CGPointMake(30.33, 53) controlPoint2: CGPointMake(31, 52.33)];
                [bezier2Path addLineToPoint: CGPointMake(31, 3)];
                [bezier2Path addLineToPoint: CGPointMake(31, 3)];
                [bezier2Path addCurveToPoint: CGPointMake(28, 0) controlPoint1: CGPointMake(31, 1.34) controlPoint2: CGPointMake(29.66, 0)];
                [bezier2Path closePath];
                [pointFillColor setFill];
                [bezier2Path fill];


                //// Rectangle Drawing
                UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.75, 14.75, 30.5, 80.5) cornerRadius: 0.75];
                [toolFillColor setFill];
                [rectanglePath fill];


                //// Bezier 3 Drawing
                UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
                [bezier3Path moveToPoint: CGPointMake(30.5, 15.5)];
                [bezier3Path addLineToPoint: CGPointMake(30.5, 94.5)];
                [bezier3Path addLineToPoint: CGPointMake(1.5, 94.5)];
                [bezier3Path addLineToPoint: CGPointMake(1.5, 15.5)];
                [bezier3Path addLineToPoint: CGPointMake(30.5, 15.5)];
                [bezier3Path closePath];
                [bezier3Path moveToPoint: CGPointMake(30.5, 14)];
                [bezier3Path addLineToPoint: CGPointMake(1.5, 14)];
                [bezier3Path addLineToPoint: CGPointMake(1.5, 14)];
                [bezier3Path addCurveToPoint: CGPointMake(0, 15.5) controlPoint1: CGPointMake(0.67, 14) controlPoint2: CGPointMake(0, 14.67)];
                [bezier3Path addLineToPoint: CGPointMake(0, 94.5)];
                [bezier3Path addLineToPoint: CGPointMake(0, 94.5)];
                [bezier3Path addCurveToPoint: CGPointMake(1.5, 96) controlPoint1: CGPointMake(0, 95.33) controlPoint2: CGPointMake(0.67, 96)];
                [bezier3Path addLineToPoint: CGPointMake(30.5, 96)];
                [bezier3Path addLineToPoint: CGPointMake(30.5, 96)];
                [bezier3Path addCurveToPoint: CGPointMake(32, 94.5) controlPoint1: CGPointMake(31.33, 96) controlPoint2: CGPointMake(32, 95.33)];
                [bezier3Path addLineToPoint: CGPointMake(32, 15.5)];
                [bezier3Path addLineToPoint: CGPointMake(32, 15.5)];
                [bezier3Path addCurveToPoint: CGPointMake(30.5, 14) controlPoint1: CGPointMake(32, 14.67) controlPoint2: CGPointMake(31.33, 14)];
                [bezier3Path closePath];
                [pointFillColor setFill];
                [bezier3Path fill];


                //// Bezier 4 Drawing
                UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
                [bezier4Path moveToPoint: CGPointMake(25, 21)];
                [bezier4Path addLineToPoint: CGPointMake(31, 15)];
                [toolStrokeColor setStroke];
                bezier4Path.lineWidth = 1;
                bezier4Path.miterLimit = 4;
                bezier4Path.lineCapStyle = kCGLineCapRound;
                bezier4Path.lineJoinStyle = kCGLineJoinRound;
                [bezier4Path stroke];


                //// Bezier 5 Drawing
                UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
                [bezier5Path moveToPoint: CGPointMake(21, 21)];
                [bezier5Path addLineToPoint: CGPointMake(27, 15)];
                [toolStrokeColor setStroke];
                bezier5Path.lineWidth = 1;
                bezier5Path.miterLimit = 4;
                bezier5Path.lineCapStyle = kCGLineCapRound;
                bezier5Path.lineJoinStyle = kCGLineJoinRound;
                [bezier5Path stroke];


                //// Bezier 6 Drawing
                UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
                [bezier6Path moveToPoint: CGPointMake(17, 21)];
                [bezier6Path addLineToPoint: CGPointMake(23, 15)];
                [toolStrokeColor setStroke];
                bezier6Path.lineWidth = 1;
                bezier6Path.miterLimit = 4;
                bezier6Path.lineCapStyle = kCGLineCapRound;
                bezier6Path.lineJoinStyle = kCGLineJoinRound;
                [bezier6Path stroke];
            }
        }
    }
    
    CGContextRestoreGState(context);

}

+ (void)drawPenToolWithToolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor
{
    [SFSketchIconsKit drawPenToolWithFrame: CGRectMake(0, 0, 22, 116) resizing: SFSketchIconsKitResizingBehaviorStretch toolFillColor: toolFillColor pointFillColor: pointFillColor toolStrokeColor: toolStrokeColor];
}

+ (void)drawPenToolWithFrame: (CGRect)targetFrame resizing: (SFSketchIconsKitResizingBehavior)resizing toolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Resize to Target Frame
    CGContextSaveGState(context);
    CGRect resizedFrame = SFSketchIconsKitResizingBehaviorApply(resizing, CGRectMake(0, 0, 22, 116), targetFrame);
    CGContextTranslateCTM(context, resizedFrame.origin.x, resizedFrame.origin.y);
    CGContextScaleCTM(context, resizedFrame.size.width / 22, resizedFrame.size.height / 116);


    //// Layer_2
    {
        //// Layer_1-2
        {
            //// Pen
            {
                //// Bezier Drawing
                UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint: CGPointMake(1.5, 114.33)];
                [bezierPath addLineToPoint: CGPointMake(1.5, 114.33)];
                [bezierPath addCurveToPoint: CGPointMake(0.75, 113.58) controlPoint1: CGPointMake(1.09, 114.33) controlPoint2: CGPointMake(0.75, 113.99)];
                [bezierPath addLineToPoint: CGPointMake(0.75, 36.48)];
                [bezierPath addLineToPoint: CGPointMake(0.75, 36.47)];
                [bezierPath addCurveToPoint: CGPointMake(1.55, 30.75) controlPoint1: CGPointMake(0.75, 34.53) controlPoint2: CGPointMake(1.02, 32.61)];
                [bezierPath addLineToPoint: CGPointMake(6.85, 12.87)];
                [bezierPath addLineToPoint: CGPointMake(6.85, 12.87)];
                [bezierPath addCurveToPoint: CGPointMake(7.57, 12.33) controlPoint1: CGPointMake(6.94, 12.55) controlPoint2: CGPointMake(7.24, 12.33)];
                [bezierPath addLineToPoint: CGPointMake(14.42, 12.33)];
                [bezierPath addLineToPoint: CGPointMake(14.42, 12.33)];
                [bezierPath addCurveToPoint: CGPointMake(15.14, 12.87) controlPoint1: CGPointMake(14.75, 12.33) controlPoint2: CGPointMake(15.05, 12.55)];
                [bezierPath addLineToPoint: CGPointMake(20.4, 30.59)];
                [bezierPath addLineToPoint: CGPointMake(20.45, 30.75)];
                [bezierPath addCurveToPoint: CGPointMake(21.25, 36.47) controlPoint1: CGPointMake(20.98, 32.61) controlPoint2: CGPointMake(21.25, 34.53)];
                [bezierPath addLineToPoint: CGPointMake(21.25, 113.58)];
                [bezierPath addLineToPoint: CGPointMake(21.25, 113.58)];
                [bezierPath addCurveToPoint: CGPointMake(20.5, 114.33) controlPoint1: CGPointMake(21.25, 113.99) controlPoint2: CGPointMake(20.91, 114.33)];
                [bezierPath addLineToPoint: CGPointMake(1.5, 114.33)];
                [bezierPath closePath];
                [toolFillColor setFill];
                [bezierPath fill];


                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
                [bezier2Path moveToPoint: CGPointMake(14.43, 13.08)];
                [bezier2Path addLineToPoint: CGPointMake(19.68, 30.8)];
                [bezier2Path addLineToPoint: CGPointMake(19.73, 30.96)];
                [bezier2Path addCurveToPoint: CGPointMake(20.5, 36.47) controlPoint1: CGPointMake(20.24, 32.75) controlPoint2: CGPointMake(20.5, 34.6)];
                [bezier2Path addLineToPoint: CGPointMake(20.5, 113.58)];
                [bezier2Path addLineToPoint: CGPointMake(1.5, 113.58)];
                [bezier2Path addLineToPoint: CGPointMake(1.5, 36.48)];
                [bezier2Path addLineToPoint: CGPointMake(1.5, 36.47)];
                [bezier2Path addCurveToPoint: CGPointMake(2.27, 30.96) controlPoint1: CGPointMake(1.5, 34.6) controlPoint2: CGPointMake(1.76, 32.75)];
                [bezier2Path addLineToPoint: CGPointMake(7.57, 13.08)];
                [bezier2Path addLineToPoint: CGPointMake(14.42, 13.08)];
                [bezier2Path moveToPoint: CGPointMake(14.42, 11.58)];
                [bezier2Path addLineToPoint: CGPointMake(7.57, 11.58)];
                [bezier2Path addLineToPoint: CGPointMake(7.57, 11.58)];
                [bezier2Path addCurveToPoint: CGPointMake(6.13, 12.64) controlPoint1: CGPointMake(6.91, 11.58) controlPoint2: CGPointMake(6.33, 12.01)];
                [bezier2Path addLineToPoint: CGPointMake(0.89, 30.37)];
                [bezier2Path addLineToPoint: CGPointMake(0.94, 30.21)];
                [bezier2Path addCurveToPoint: CGPointMake(-0, 36.49) controlPoint1: CGPointMake(0.32, 32.24) controlPoint2: CGPointMake(-0, 34.36)];
                [bezier2Path addLineToPoint: CGPointMake(0, 113.58)];
                [bezier2Path addLineToPoint: CGPointMake(0, 113.58)];
                [bezier2Path addCurveToPoint: CGPointMake(1.5, 115.08) controlPoint1: CGPointMake(0, 114.41) controlPoint2: CGPointMake(0.67, 115.08)];
                [bezier2Path addLineToPoint: CGPointMake(20.5, 115.08)];
                [bezier2Path addLineToPoint: CGPointMake(20.5, 115.08)];
                [bezier2Path addCurveToPoint: CGPointMake(22, 113.58) controlPoint1: CGPointMake(21.33, 115.08) controlPoint2: CGPointMake(22, 114.41)];
                [bezier2Path addLineToPoint: CGPointMake(22, 36.48)];
                [bezier2Path addLineToPoint: CGPointMake(22, 36.49)];
                [bezier2Path addCurveToPoint: CGPointMake(21.06, 30.21) controlPoint1: CGPointMake(22, 34.36) controlPoint2: CGPointMake(21.68, 32.24)];
                [bezier2Path addLineToPoint: CGPointMake(15.87, 12.65)];
                [bezier2Path addLineToPoint: CGPointMake(15.87, 12.64)];
                [bezier2Path addCurveToPoint: CGPointMake(14.43, 11.58) controlPoint1: CGPointMake(15.67, 12.01) controlPoint2: CGPointMake(15.09, 11.58)];
                [bezier2Path addLineToPoint: CGPointMake(14.42, 11.58)];
                [bezier2Path closePath];
                [toolStrokeColor setFill];
                [bezier2Path fill];


                //// Bezier 3 Drawing
                UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
                [bezier3Path moveToPoint: CGPointMake(1, 34.08)];
                [bezier3Path addLineToPoint: CGPointMake(21, 34.08)];
                [toolFillColor setFill];
                [bezier3Path fill];
                [toolStrokeColor setStroke];
                bezier3Path.lineWidth = 1;
                bezier3Path.miterLimit = 4;
                bezier3Path.lineCapStyle = kCGLineCapRound;
                bezier3Path.lineJoinStyle = kCGLineJoinRound;
                [bezier3Path stroke];


                //// Bezier 4 Drawing
                UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
                [bezier4Path moveToPoint: CGPointMake(17.25, 76.52)];
                [bezier4Path addLineToPoint: CGPointMake(17.25, 37.78)];
                [toolStrokeColor setStroke];
                bezier4Path.lineWidth = 1.5;
                bezier4Path.miterLimit = 4;
                bezier4Path.lineCapStyle = kCGLineCapRound;
                bezier4Path.lineJoinStyle = kCGLineJoinRound;
                [bezier4Path stroke];


                //// Bezier 5 Drawing
                UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
                [bezier5Path moveToPoint: CGPointMake(12.44, 1.08)];
                [bezier5Path addLineToPoint: CGPointMake(12.44, 1.09)];
                [bezier5Path addCurveToPoint: CGPointMake(10.59, 0.06) controlPoint1: CGPointMake(12.21, 0.29) controlPoint2: CGPointMake(11.38, -0.17)];
                [bezier5Path addCurveToPoint: CGPointMake(9.57, 1.06) controlPoint1: CGPointMake(10.1, 0.2) controlPoint2: CGPointMake(9.71, 0.58)];
                [bezier5Path addLineToPoint: CGPointMake(6.75, 10.58)];
                [bezier5Path addLineToPoint: CGPointMake(15.25, 10.58)];
                [bezier5Path addLineToPoint: CGPointMake(12.44, 1.08)];
                [bezier5Path closePath];
                [pointFillColor setFill];
                [bezier5Path fill];
            }
        }
    }
    
    CGContextRestoreGState(context);

}

+ (void)drawMarkerToolWithToolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor
{
    [SFSketchIconsKit drawMarkerToolWithFrame: CGRectMake(0, 0, 22, 115) resizing: SFSketchIconsKitResizingBehaviorStretch toolFillColor: toolFillColor pointFillColor: pointFillColor toolStrokeColor: toolStrokeColor];
}

+ (void)drawMarkerToolWithFrame: (CGRect)targetFrame resizing: (SFSketchIconsKitResizingBehavior)resizing toolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Resize to Target Frame
    CGContextSaveGState(context);
    CGRect resizedFrame = SFSketchIconsKitResizingBehaviorApply(resizing, CGRectMake(0, 0, 22, 115), targetFrame);
    CGContextTranslateCTM(context, resizedFrame.origin.x, resizedFrame.origin.y);
    CGContextScaleCTM(context, resizedFrame.size.width / 22, resizedFrame.size.height / 115);


    //// Layer_2
    {
        //// Layer_1-2
        {
            //// Marker
            {
                //// Bezier Drawing
                UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint: CGPointMake(1.5, 114.2)];
                [bezierPath addLineToPoint: CGPointMake(1.5, 114.2)];
                [bezierPath addCurveToPoint: CGPointMake(0.75, 113.45) controlPoint1: CGPointMake(1.09, 114.2) controlPoint2: CGPointMake(0.75, 113.86)];
                [bezierPath addLineToPoint: CGPointMake(0.75, 33.65)];
                [bezierPath addLineToPoint: CGPointMake(0.75, 33.58)];
                [bezierPath addCurveToPoint: CGPointMake(1.61, 28.7) controlPoint1: CGPointMake(0.75, 31.92) controlPoint2: CGPointMake(1.04, 30.27)];
                [bezierPath addLineToPoint: CGPointMake(4.75, 21.25)];
                [bezierPath addLineToPoint: CGPointMake(4.75, 13.95)];
                [bezierPath addLineToPoint: CGPointMake(4.75, 13.95)];
                [bezierPath addCurveToPoint: CGPointMake(5.5, 13.2) controlPoint1: CGPointMake(4.75, 13.54) controlPoint2: CGPointMake(5.09, 13.2)];
                [bezierPath addLineToPoint: CGPointMake(16.5, 13.2)];
                [bezierPath addLineToPoint: CGPointMake(16.5, 13.2)];
                [bezierPath addCurveToPoint: CGPointMake(17.25, 13.95) controlPoint1: CGPointMake(16.91, 13.2) controlPoint2: CGPointMake(17.25, 13.54)];
                [bezierPath addLineToPoint: CGPointMake(17.25, 21.3)];
                [bezierPath addLineToPoint: CGPointMake(20.35, 28.67)];
                [bezierPath addLineToPoint: CGPointMake(20.39, 28.77)];
                [bezierPath addCurveToPoint: CGPointMake(21.25, 33.66) controlPoint1: CGPointMake(20.96, 30.34) controlPoint2: CGPointMake(21.25, 32)];
                [bezierPath addLineToPoint: CGPointMake(21.25, 113.47)];
                [bezierPath addLineToPoint: CGPointMake(21.25, 113.47)];
                [bezierPath addCurveToPoint: CGPointMake(20.5, 114.22) controlPoint1: CGPointMake(21.25, 113.88) controlPoint2: CGPointMake(20.91, 114.22)];
                [bezierPath addLineToPoint: CGPointMake(1.5, 114.2)];
                [bezierPath closePath];
                [toolFillColor setFill];
                [bezierPath fill];


                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
                [bezier2Path moveToPoint: CGPointMake(16.5, 13.95)];
                [bezier2Path addLineToPoint: CGPointMake(16.5, 21.45)];
                [bezier2Path addLineToPoint: CGPointMake(19.66, 29)];
                [bezier2Path addLineToPoint: CGPointMake(19.68, 29.06)];
                [bezier2Path addCurveToPoint: CGPointMake(20.5, 33.7) controlPoint1: CGPointMake(20.22, 30.55) controlPoint2: CGPointMake(20.5, 32.12)];
                [bezier2Path addLineToPoint: CGPointMake(20.5, 113.49)];
                [bezier2Path addLineToPoint: CGPointMake(1.5, 113.49)];
                [bezier2Path addLineToPoint: CGPointMake(1.5, 33.65)];
                [bezier2Path addLineToPoint: CGPointMake(1.5, 33.7)];
                [bezier2Path addCurveToPoint: CGPointMake(2.32, 29.06) controlPoint1: CGPointMake(1.5, 32.12) controlPoint2: CGPointMake(1.78, 30.55)];
                [bezier2Path addLineToPoint: CGPointMake(5.5, 21.45)];
                [bezier2Path addLineToPoint: CGPointMake(5.5, 13.95)];
                [bezier2Path addLineToPoint: CGPointMake(16.5, 13.95)];
                [bezier2Path closePath];
                [bezier2Path moveToPoint: CGPointMake(16.5, 12.45)];
                [bezier2Path addLineToPoint: CGPointMake(5.5, 12.45)];
                [bezier2Path addLineToPoint: CGPointMake(5.5, 12.45)];
                [bezier2Path addCurveToPoint: CGPointMake(4, 13.95) controlPoint1: CGPointMake(4.67, 12.45) controlPoint2: CGPointMake(4, 13.12)];
                [bezier2Path addLineToPoint: CGPointMake(4, 21.15)];
                [bezier2Path addLineToPoint: CGPointMake(1, 28.38)];
                [bezier2Path addLineToPoint: CGPointMake(1, 28.44)];
                [bezier2Path addLineToPoint: CGPointMake(1, 28.45)];
                [bezier2Path addCurveToPoint: CGPointMake(0, 33.57) controlPoint1: CGPointMake(0.37, 30.09) controlPoint2: CGPointMake(0.03, 31.82)];
                [bezier2Path addLineToPoint: CGPointMake(0, 113.45)];
                [bezier2Path addLineToPoint: CGPointMake(0, 113.45)];
                [bezier2Path addCurveToPoint: CGPointMake(1.5, 114.95) controlPoint1: CGPointMake(0, 114.28) controlPoint2: CGPointMake(0.67, 114.95)];
                [bezier2Path addLineToPoint: CGPointMake(20.5, 114.95)];
                [bezier2Path addLineToPoint: CGPointMake(20.5, 114.95)];
                [bezier2Path addCurveToPoint: CGPointMake(22, 113.45) controlPoint1: CGPointMake(21.33, 114.95) controlPoint2: CGPointMake(22, 114.28)];
                [bezier2Path addLineToPoint: CGPointMake(22, 33.65)];
                [bezier2Path addLineToPoint: CGPointMake(22, 33.64)];
                [bezier2Path addCurveToPoint: CGPointMake(21.1, 28.51) controlPoint1: CGPointMake(22, 31.89) controlPoint2: CGPointMake(21.69, 30.15)];
                [bezier2Path addLineToPoint: CGPointMake(21.07, 28.38)];
                [bezier2Path addLineToPoint: CGPointMake(18.07, 21.15)];
                [bezier2Path addLineToPoint: CGPointMake(18.07, 13.95)];
                [bezier2Path addLineToPoint: CGPointMake(18.07, 13.95)];
                [bezier2Path addCurveToPoint: CGPointMake(16.57, 12.45) controlPoint1: CGPointMake(18.07, 13.12) controlPoint2: CGPointMake(17.4, 12.45)];
                [bezier2Path addLineToPoint: CGPointMake(16.5, 12.45)];
                [bezier2Path closePath];
                [toolStrokeColor setFill];
                [bezier2Path fill];


                //// Bezier 3 Drawing
                UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
                [bezier3Path moveToPoint: CGPointMake(1.5, 32.09)];
                [bezier3Path addLineToPoint: CGPointMake(20.5, 32.09)];
                [toolFillColor setFill];
                [bezier3Path fill];
                [toolStrokeColor setStroke];
                bezier3Path.lineWidth = 1;
                bezier3Path.miterLimit = 4;
                bezier3Path.lineCapStyle = kCGLineCapRound;
                bezier3Path.lineJoinStyle = kCGLineJoinRound;
                [bezier3Path stroke];


                //// Bezier 4 Drawing
                UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
                [bezier4Path moveToPoint: CGPointMake(5.5, 11.45)];
                [bezier4Path addLineToPoint: CGPointMake(16.5, 11.45)];
                [bezier4Path addLineToPoint: CGPointMake(16.5, 1)];
                [bezier4Path addLineToPoint: CGPointMake(16.5, 1)];
                [bezier4Path addCurveToPoint: CGPointMake(15.5, 0) controlPoint1: CGPointMake(16.5, 0.45) controlPoint2: CGPointMake(16.05, 0)];
                [bezier4Path addCurveToPoint: CGPointMake(15.09, 0.09) controlPoint1: CGPointMake(15.36, 0) controlPoint2: CGPointMake(15.22, 0.03)];
                [bezier4Path addLineToPoint: CGPointMake(6.09, 4.18)];
                [bezier4Path addLineToPoint: CGPointMake(6.09, 4.18)];
                [bezier4Path addCurveToPoint: CGPointMake(5.5, 5.09) controlPoint1: CGPointMake(5.73, 4.34) controlPoint2: CGPointMake(5.5, 4.7)];
                [bezier4Path addLineToPoint: CGPointMake(5.5, 11.45)];
                [bezier4Path closePath];
                [pointFillColor setFill];
                [bezier4Path fill];


                //// Bezier 5 Drawing
                UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
                [bezier5Path moveToPoint: CGPointMake(17, 72.95)];
                [bezier5Path addLineToPoint: CGPointMake(17, 35.95)];
                [toolStrokeColor setStroke];
                bezier5Path.lineWidth = 1;
                bezier5Path.miterLimit = 4;
                bezier5Path.lineCapStyle = kCGLineCapRound;
                bezier5Path.lineJoinStyle = kCGLineJoinRound;
                [bezier5Path stroke];
            }
        }
    }
    
    CGContextRestoreGState(context);

}

+ (void)drawColorToolWithFrame: (CGRect)frame toolFillColor: (UIColor*)toolFillColor toolStrokeColor: (UIColor*)toolStrokeColor
{

    //// Oval bg Drawing
    UIBezierPath* ovalBgPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + floor(frame.size.width * 0.03750) + 0.5, CGRectGetMinY(frame) + floor(frame.size.height * 0.03750) + 0.5, floor(frame.size.width * 0.96250) - floor(frame.size.width * 0.03750), floor(frame.size.height * 0.96250) - floor(frame.size.height * 0.03750))];
    [toolFillColor setFill];
    [ovalBgPath fill];


    //// Oval stroke Drawing
    UIBezierPath* ovalStrokePath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + floor(frame.size.width * 0.06250) + 0.5, CGRectGetMinY(frame) + floor(frame.size.height * 0.06250) + 0.5, floor(frame.size.width * 0.95000 + 0.5) - floor(frame.size.width * 0.06250) - 0.5, floor(frame.size.height * 0.95000 + 0.5) - floor(frame.size.height * 0.06250) - 0.5)];
    [toolStrokeColor setStroke];
    ovalStrokePath.lineWidth = 1.5;
    [ovalStrokePath stroke];
}

+ (void)drawPointToolWithFrame: (CGRect)frame toolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor pointRect: (CGRect)pointRect
{

    //// Oval bg Drawing
    UIBezierPath* ovalBgPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + floor(frame.size.width * 0.03750) + 0.5, CGRectGetMinY(frame) + floor(frame.size.height * 0.03750) + 0.5, floor(frame.size.width * 0.96250) - floor(frame.size.width * 0.03750), floor(frame.size.height * 0.96250) - floor(frame.size.height * 0.03750))];
    [toolFillColor setFill];
    [ovalBgPath fill];


    //// Oval stroke Drawing
    UIBezierPath* ovalStrokePath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + floor(frame.size.width * 0.06250) + 0.5, CGRectGetMinY(frame) + floor(frame.size.height * 0.06250) + 0.5, floor(frame.size.width * 0.95000 + 0.5) - floor(frame.size.width * 0.06250) - 0.5, floor(frame.size.height * 0.95000 + 0.5) - floor(frame.size.height * 0.06250) - 0.5)];
    [toolStrokeColor setStroke];
    ovalStrokePath.lineWidth = 1.5;
    [ovalStrokePath stroke];


    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: pointRect];
    [pointFillColor setFill];
    [ovalPath fill];
}

+ (void)drawCloseIconWithToolStrokeColor: (UIColor*)toolStrokeColor
{
    [SFSketchIconsKit drawCloseIconWithFrame: CGRectMake(0, 0, 16, 16) resizing: SFSketchIconsKitResizingBehaviorStretch toolStrokeColor: toolStrokeColor];
}

+ (void)drawCloseIconWithFrame: (CGRect)targetFrame resizing: (SFSketchIconsKitResizingBehavior)resizing toolStrokeColor: (UIColor*)toolStrokeColor
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Resize to Target Frame
    CGContextSaveGState(context);
    CGRect resizedFrame = SFSketchIconsKitResizingBehaviorApply(resizing, CGRectMake(0, 0, 16, 16), targetFrame);
    CGContextTranslateCTM(context, resizedFrame.origin.x, resizedFrame.origin.y);
    CGContextScaleCTM(context, resizedFrame.size.width / 16, resizedFrame.size.height / 16);


    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(14.86, 14.86)];
    [bezier2Path addCurveToPoint: CGPointMake(14.01, 14.71) controlPoint1: CGPointMake(14.66, 15.05) controlPoint2: CGPointMake(14.28, 14.99)];
    [bezier2Path addLineToPoint: CGPointMake(1.57, 2.28)];
    [bezier2Path addCurveToPoint: CGPointMake(1.42, 1.42) controlPoint1: CGPointMake(1.29, 2) controlPoint2: CGPointMake(1.23, 1.62)];
    [bezier2Path addLineToPoint: CGPointMake(1.42, 1.42)];
    [bezier2Path addCurveToPoint: CGPointMake(2.28, 1.57) controlPoint1: CGPointMake(1.62, 1.23) controlPoint2: CGPointMake(2, 1.29)];
    [bezier2Path addLineToPoint: CGPointMake(14.71, 14.01)];
    [bezier2Path addCurveToPoint: CGPointMake(14.86, 14.86) controlPoint1: CGPointMake(14.99, 14.28) controlPoint2: CGPointMake(15.05, 14.66)];
    [bezier2Path closePath];
    [toolStrokeColor setStroke];
    bezier2Path.lineWidth = 1;
    bezier2Path.miterLimit = 4;
    [bezier2Path stroke];


    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(1.14, 14.86)];
    [bezierPath addCurveToPoint: CGPointMake(1.99, 14.71) controlPoint1: CGPointMake(1.34, 15.05) controlPoint2: CGPointMake(1.72, 14.99)];
    [bezierPath addLineToPoint: CGPointMake(14.43, 2.28)];
    [bezierPath addCurveToPoint: CGPointMake(14.58, 1.42) controlPoint1: CGPointMake(14.71, 2) controlPoint2: CGPointMake(14.77, 1.62)];
    [bezierPath addLineToPoint: CGPointMake(14.58, 1.42)];
    [bezierPath addCurveToPoint: CGPointMake(13.72, 1.57) controlPoint1: CGPointMake(14.38, 1.23) controlPoint2: CGPointMake(14, 1.29)];
    [bezierPath addLineToPoint: CGPointMake(1.29, 14.01)];
    [bezierPath addCurveToPoint: CGPointMake(1.14, 14.86) controlPoint1: CGPointMake(1.01, 14.28) controlPoint2: CGPointMake(0.95, 14.66)];
    [bezierPath closePath];
    [toolStrokeColor setStroke];
    bezierPath.lineWidth = 1;
    bezierPath.miterLimit = 4;
    [bezierPath stroke];
    
    CGContextRestoreGState(context);

}

#pragma mark Generated Images

+ (UIImage*)imageOfEraserToolWithToolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(32, 96), NO, 0);
    [SFSketchIconsKit drawEraserToolWithToolFillColor: toolFillColor pointFillColor: pointFillColor toolStrokeColor: toolStrokeColor];

    UIImage* imageOfEraserTool = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageOfEraserTool;
}

+ (UIImage*)imageOfPenToolWithToolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(22, 116), NO, 0);
    [SFSketchIconsKit drawPenToolWithToolFillColor: toolFillColor pointFillColor: pointFillColor toolStrokeColor: toolStrokeColor];

    UIImage* imageOfPenTool = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageOfPenTool;
}

+ (UIImage*)imageOfMarkerToolWithToolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(22, 115), NO, 0);
    [SFSketchIconsKit drawMarkerToolWithToolFillColor: toolFillColor pointFillColor: pointFillColor toolStrokeColor: toolStrokeColor];

    UIImage* imageOfMarkerTool = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageOfMarkerTool;
}

+ (UIImage*)imageOfColorToolWithSize: (CGSize)imageSize toolFillColor: (UIColor*)toolFillColor toolStrokeColor: (UIColor*)toolStrokeColor
{
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    [SFSketchIconsKit drawColorToolWithFrame: CGRectMake(0, 0, imageSize.width, imageSize.height) toolFillColor: toolFillColor toolStrokeColor: toolStrokeColor];

    UIImage* imageOfColorTool = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageOfColorTool;
}

+ (UIImage*)imageOfPointToolWithSize: (CGSize)imageSize toolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor pointRect: (CGRect)pointRect
{
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    [SFSketchIconsKit drawPointToolWithFrame: CGRectMake(0, 0, imageSize.width, imageSize.height) toolFillColor: toolFillColor pointFillColor: pointFillColor toolStrokeColor: toolStrokeColor pointRect: pointRect];

    UIImage* imageOfPointTool = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageOfPointTool;
}

+ (UIImage*)imageOfCloseIconWithToolStrokeColor: (UIColor*)toolStrokeColor
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(16, 16), NO, 0);
    [SFSketchIconsKit drawCloseIconWithToolStrokeColor: toolStrokeColor];

    UIImage* imageOfCloseIcon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageOfCloseIcon;
}

@end



CGRect SFSketchIconsKitResizingBehaviorApply(SFSketchIconsKitResizingBehavior behavior, CGRect rect, CGRect target)
{
    if (CGRectEqualToRect(rect, target) || CGRectEqualToRect(target, CGRectZero))
        return rect;

    CGSize scales = CGSizeZero;
    scales.width = ABS(target.size.width / rect.size.width);
    scales.height = ABS(target.size.height / rect.size.height);

    switch (behavior)
    {
        case SFSketchIconsKitResizingBehaviorAspectFit:
        {
            scales.width = MIN(scales.width, scales.height);
            scales.height = scales.width;
            break;
        }
        case SFSketchIconsKitResizingBehaviorAspectFill:
        {
            scales.width = MAX(scales.width, scales.height);
            scales.height = scales.width;
            break;
        }
        case SFSketchIconsKitResizingBehaviorStretch:
            break;
        case SFSketchIconsKitResizingBehaviorCenter:
        {
            scales.width = 1;
            scales.height = 1;
            break;
        }
    }

    CGRect result = CGRectStandardize(rect);
    result.size.width *= scales.width;
    result.size.height *= scales.height;
    result.origin.x = target.origin.x + (target.size.width - result.size.width) / 2;
    result.origin.y = target.origin.y + (target.size.height - result.size.height) / 2;
    return result;
}
