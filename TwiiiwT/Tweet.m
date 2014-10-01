//
//  Tweet.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/27/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "Tweet.h"
#import "APIField.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    NSLog(@"initilize");
    if (self) {
        self.text = (NSString *)dict[tweetText];
        self.tweetID = (NSNumber *)dict[tweetID];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:dict[tweetCteateAt]];
        self.retweetCount = (int)dict[tweetRetweetCount];
        self.favouritesCount = (int)dict[tweetFavoriteCount];
        self.retweeted = [dict[tweetRetweeted] boolValue];
        self.favorited = [dict[tweetFavorited] boolValue];
        self.user = [[User alloc] initWithDictionary:dict[tweetUser]];
        //NSLog(@"retweet status: %@", dict[tweetRetweetedStatus]);
        //NSLog(@"retweet user: %@, class: %@", dict[tweetRetweetedStatus][tweetUser], [dict[tweetRetweetedStatus][tweetUser] class]);
        if (dict[tweetRetweetedStatus][tweetUser]) {
            self.originalUser = [[User alloc] initWithDictionary:dict[tweetRetweetedStatus][tweetUser]];
        } else {
            self.originalUser = nil;
        }
        //self.retweetedStatus = [[Tweet alloc] initWithDictionary:dict[tweetRetweetedStatus]];
    }
    return self;
}

- (User *)author {
    return self.originalUser == nil ? self.user : self.originalUser;
    //return self.user;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *params in array) {
        NSLog(@"tweet: %@", params);
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

@end
