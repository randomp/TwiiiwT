//
//  User.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/24/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"
#import "APIField.h"

NSString const *currentUserStoreKey = @"currentUser";

@implementation User

static User *_currentuser;

+ (User *)currentUser {
    if (!_currentuser) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:currentUserStoreKey];
        if (userData) {
            NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:userData options:NSJSONReadingMutableContainers error:nil];
            _currentuser = [[User alloc] initWithDictionary:userDictionary];
        }
    }
    return _currentuser;
}

+ (void)setCurrentUser:(User *)user {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _currentuser = user;
    if (user) {
        NSData *userData = [NSJSONSerialization dataWithJSONObject:user.data options:NSJSONWritingPrettyPrinted error:nil];
        [defaults setObject:userData forKey:currentUserStoreKey];
    } else {
        [defaults removeObjectForKey:currentUserStoreKey];
    }
    [defaults synchronize];
}

+ (void)signOut {
    [User setCurrentUser:nil];
    [[[TwitterClient instance] requestSerializer] removeAccessToken];
}

+ (void)verifyCurrentUserWithSuccess:(void(^) ())success failure:(void (^) (NSError *error))failure {
    [[TwitterClient instance] verifyCredentialWithSuccess:^(AFHTTPRequestOperation *operation, id respond) {
        NSLog(@"[User] verify user successfully");
        User *user = [[User alloc] initWithDictionary:respond];
        [User setCurrentUser:user];
        if (success) {
            success();
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[User] verigy user fail");
        if (failure) {
            failure(error);
        }
    }];
}


- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.data = dict;
        self.name = (NSString *) dict[userName];
        self.thumbImageUrl = (NSString *) dict[userProfileImageURL];
        self.profileImageUrl = [self.thumbImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
        self.bannerImageUrl = (NSString *) dict[userBannerImageURL];
        self.screenName = (NSString *) dict[userScreenName];
        self.place = (NSString *) dict[userLocation];
        self.introduction = (NSString *) dict[userDescription];
        self.followingCount = (int) dict[userFollowingCount];
        self.followersCount = (int) dict[userFollowerCount];
        self.statusesCount = (int) dict[userStatusesCount];
    }
    return self;
}

@end
