//
//  APIField.h
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/26/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIField : NSObject

#pragma mark - Fields for User

FOUNDATION_EXPORT NSString * const userName;
FOUNDATION_EXPORT NSString * const userProfileImageURL;
FOUNDATION_EXPORT NSString * const userBannerImageURL;
FOUNDATION_EXPORT NSString * const userScreenName;
FOUNDATION_EXPORT NSString * const userFollowingCount;
FOUNDATION_EXPORT NSString * const userFollowerCount;
FOUNDATION_EXPORT NSString * const userStatusesCount;
FOUNDATION_EXPORT NSString * const userLocation;
FOUNDATION_EXPORT NSString * const userDescription;

#pragma mark = Fields for Tweet
FOUNDATION_EXPORT NSString * const tweetText;
FOUNDATION_EXPORT NSString * const tweetID;
FOUNDATION_EXPORT NSString * const tweetUser;
FOUNDATION_EXPORT NSString * const tweetCteateAt;
FOUNDATION_EXPORT NSString * const tweetRetweeted;
FOUNDATION_EXPORT NSString * const tweetFavorited;
FOUNDATION_EXPORT NSString * const tweetRetweetCount;
FOUNDATION_EXPORT NSString * const tweetFavoriteCount;
FOUNDATION_EXPORT NSString * const tweetRetweetedStatus;

@end
