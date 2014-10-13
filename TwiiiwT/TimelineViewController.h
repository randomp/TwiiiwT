//
//  TimelineViewController.h
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/26/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"

typedef enum {
    timelineView,
    mentionsView
} ViewMode;

@interface TimelineViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NewTweetDelegate>

@property ViewMode mode;
-(id)initWithMode:(ViewMode)aMode;

@end
