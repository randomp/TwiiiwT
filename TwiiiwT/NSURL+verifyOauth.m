//
//  NSURL+verifyOauth.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/26/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "NSURL+verifyOauth.h"

@implementation NSURL (verifyOauth)

- (BOOL)verifyOauth {
    NSArray *entries = [[self query] componentsSeparatedByString:@"&"];
    for (NSString *entry in entries) {
        NSArray *keyValue = [entry componentsSeparatedByString:@"="];
        NSString *key = [keyValue objectAtIndex:0];
        if ([key isEqualToString:@"oauth_verifier"]) {
            NSString *val = [keyValue objectAtIndex:1];
            if (val) {
                return YES;
            }
        }
    }
    return NO;
}

@end
