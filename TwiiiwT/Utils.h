//
//  Utils.h
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/28/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (void)loadImageUrl:(NSString *)url inImageView:(UIImageView *)imageView withAnimation:(BOOL)animation;

+ (void)loadImageUrl:(NSString *)url inImageView:(UIImageView *)imageView withAnimation:(BOOL)animation withSuccess:(void (^) ())success;

@end