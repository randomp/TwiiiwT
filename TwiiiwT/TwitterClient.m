//
//  TwitterClient.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/24/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "TwitterClient.h"
#import "User.h"

NSString const *twitterApiBaseURL = @"https://api.twitter.com";
NSString const *twitterConsumerKey = @"WpcNCwLM1viqKjd7NAcc99Sea";
NSString const *twitterConsumerSecret = @"3wyNpHA2nasmOeAvFQQy4NKZvUrSBrB1S4alAnVtehyK0Midhk";

@implementation TwitterClient

# pragma mark - class methods
+ (TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:twitterApiBaseURL] consumerKey:twitterConsumerKey consumerSecret:twitterConsumerSecret];
    });
    return instance;
}

#pragma mark - instance methods

-(void)login {
    [self.requestSerializer removeAccessToken];
    
    [self fetchRequestTokenWithPath:@"oauth/request_token"
                             method:@"GET"
                        callbackURL:[NSURL URLWithString:@"TwiiiwT://oauth"]
                              scope:nil
                            success:^(BDBOAuthToken *requestToken) {
                                NSLog(@"[TwitterClient login] success");
                                NSString *authURL = [NSString
                                                     stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",
                                                     requestToken.token];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
                            } failure:^(NSError *error) {
                                NSLog(@"[TwitterClient login] failure %@", [error description]);
                            }];
}

-(void)finishLogin:(NSString *)queryString withCompletion:(void (^)())completion {
    [self fetchAccessTokenWithPath:@"/oauth/access_token"
                            method:@"POST"
                      requestToken:[BDBOAuthToken tokenWithQueryString:queryString]
                           success:^(BDBOAuthToken *accessToken) {
                               NSLog(@"[TwitterClient finishLogin] success");
                               [self.requestSerializer saveAccessToken:accessToken];
                               [User verifyCurrentUserWithSuccess:^{
                                   if (completion) {
                                       completion();
                                   }
                               } failure:^(NSError *error) {
                                   NSLog(@"[TwitterClient finishLogin] verify failure: %@", error.description);
                               }];
                               
                           } failure:^(NSError *error) {
                               NSLog(@"[TwitterClient finishLogin] failure: %@", error.description);
                           }];
}

- (AFHTTPRequestOperation *)verifyCredentialWithSuccess:(void (^) (AFHTTPRequestOperation *operation, id respond))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)homeTimelineWithParams:(NSDictionary *)params
                                           success:(void (^) (AFHTTPRequestOperation *operation, id response))success
                                           failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)retweetWithId:(NSNumber *)tweetId
                                  success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId] parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)destroyWithId:(NSNumber *)tweetId
                                  success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self POST:[NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", tweetId] parameters:nil success:success failure:failure];
}


- (AFHTTPRequestOperation *)favoriteWithId:(NSNumber *)tweetId
                                   success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"id": tweetId};
    return [self POST:@"1.1/favorites/create.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)removeFavoriteWithId:(NSNumber *)tweetId
                                         success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"id": tweetId};
    return [self POST:@"1.1/favorites/destroy.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)updateWithStatus:(NSString *)status
                                     success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"status": status};
    return [self POST:@"1.1/statuses/update.json" parameters:parameters success:success failure:failure];
}

@end