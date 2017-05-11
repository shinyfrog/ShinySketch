//
//  SFSketchIconsKit.h
//  (null)
//
//  Created on 11/05/2017.
//  Copyright © 2017 (null). All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//

#import <UIKit/UIKit.h>



typedef enum : NSInteger
{
    SFSketchIconsKitResizingBehaviorAspectFit, //!< The content is proportionally resized to fit into the target rectangle.
    SFSketchIconsKitResizingBehaviorAspectFill, //!< The content is proportionally resized to completely fill the target rectangle.
    SFSketchIconsKitResizingBehaviorStretch, //!< The content is stretched to match the entire target rectangle.
    SFSketchIconsKitResizingBehaviorCenter, //!< The content is centered in the target rectangle, but it is NOT resized.

} SFSketchIconsKitResizingBehavior;

extern CGRect SFSketchIconsKitResizingBehaviorApply(SFSketchIconsKitResizingBehavior behavior, CGRect rect, CGRect target);


@interface SFSketchIconsKit : NSObject

// Generated Images
+ (UIImage*)imageOfEraserToolWithToolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor;
+ (UIImage*)imageOfPenToolWithToolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor;
+ (UIImage*)imageOfMarkerToolWithToolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor;
+ (UIImage*)imageOfColorToolWithSize: (CGSize)imageSize toolFillColor: (UIColor*)toolFillColor toolStrokeColor: (UIColor*)toolStrokeColor;
+ (UIImage*)imageOfPointToolWithSize: (CGSize)imageSize toolFillColor: (UIColor*)toolFillColor pointFillColor: (UIColor*)pointFillColor toolStrokeColor: (UIColor*)toolStrokeColor pointRect: (CGRect)pointRect;
+ (UIImage*)imageOfCloseIconWithToolStrokeColor: (UIColor*)toolStrokeColor;

@end
