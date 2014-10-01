//
//  Tweet.h
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/27/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *originalUser;
@property (assign) int retweetCount;
@property (assign) int favouritesCount;
@property NSNumber *tweetID;
@property BOOL retweeted;
@property BOOL favorited;
//@property Tweet *retweetedStatus;

- (id)initWithDictionary:(NSDictionary *)dict;
- (User *)author;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
