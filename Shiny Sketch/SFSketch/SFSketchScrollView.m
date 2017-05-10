//
//  SFCenteringScrollView.m
//  Shiny Sketch
//
//  Created by Matteo Rattotti on 08/05/2017.
//  Copyright © 2017 Shiny Frog. All rights reserved.
//

#import "SFSketchScrollView.h"

@implementation SFSketchScrollView

- (void)centerContent
{
    CGFloat top = 0, left = 0;
    if (self.contentSize.width < self.bounds.size.width) {
        left = (self.bounds.size.width-self.contentSize.width) * 0.5f;
    }
    if (self.contentSize.height < self.bounds.size.height) {
        top = (self.bounds.size.height-self.contentSize.height) * 0.5f;
    }
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self centerContent];
}

@end
