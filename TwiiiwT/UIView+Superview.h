//
//  UIView+Superview.h
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/30/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Superview)

- (UIView *)findSuperviewOfClass:(Class) class;

@end