//
//  Utils.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/28/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "Utils.h"
#import "UIImageView+AFNetworking.h"

@implementation Utils

+ (void)loadImageUrl:(NSString *)url inImageView:(UIImageView *)imageView withAnimation:(BOOL)animation {
    [Utils loadImageUrl:url inImageView:imageView withAnimation:animation withSuccess:nil];
}

+ (void)loadImageUrl:(NSString *)url inImageView:(UIImageView *)imageView withAnimation:(BOOL)animation withSuccess:(void (^) ())success {
    NSURL *urlObject = [NSURL URLWithString:url];
    __weak UIImageView *iv = imageView;
    
    [imageView
     setImageWithURLRequest:[NSURLRequest requestWithURL:urlObject]
     placeholderImage:nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
         BOOL isCached = (request == nil);
         if (!isCached && animation) {
             iv.alpha = 0.0;
             iv.image = image;
             [UIView animateWithDuration:0.5
                              animations:^{
                                  iv.alpha = 1.0;
                              }];
         } else {
             iv.image = image;
         }
         if (success) {
             success();
         }
     }
     failure:nil];
}

@end
