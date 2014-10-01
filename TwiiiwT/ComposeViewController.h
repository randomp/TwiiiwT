//
//  ComposeViewController.h
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/30/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol NewTweetDelegate <NSObject>

- (void)updateWithNewTweet:(Tweet*) tweet;

@end

@interface ComposeViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, assign) id<NewTweetDelegate> myDelegate;
@property (nonatomic, strong) NSString *replyToScreenName;

@end
