//
//  TwitterClient.h
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/24/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

-(void)login;
-(void)finishLogin:(NSString *)queryString withCompletion:(void (^) ())completion;

- (AFHTTPRequestOperation *)verifyCredentialWithSuccess:(void (^) (AFHTTPRequestOperation *operation, id respond))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)homeTimelineWithParams:(NSDictionary *)params success:(void (^) (AFHTTPRequestOperation *operation, id response))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)retweetWithId:(NSNumber *)tweetId success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)destroyWithId:(NSNumber *)tweetId success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)favoriteWithId:(NSNumber *)tweetId success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)removeFavoriteWithId:(NSNumber *)tweetId success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)updateWithStatus:(NSString *)status success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;
@end