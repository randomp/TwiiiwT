//
//  UIView+Superview.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/30/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "UIView+Superview.h"

@implementation UIView (Superview)

- (UIView *)findSuperviewOfClass:(Class) class {
    UIView *superView = self.superview;
    while (superView != nil && ![superView isKindOfClass:class]) {
        superView = superView.superview;
    }
    return superView;
}

@end