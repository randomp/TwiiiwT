//
//  User.h
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/24/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *thumbImageUrl;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *bannerImageUrl;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *place;
@property (nonatomic, strong) NSString *introduction;
@property (assign) int followingCount;
@property (assign) int followersCount;
@property (assign) int statusesCount;

- (id)initWithDictionary:(NSDictionary *)dict;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;
+ (void)verifyCurrentUserWithSuccess:(void(^) ())success failure:(void (^) (NSError *error))failure;
+ (void)signOut;
@end
