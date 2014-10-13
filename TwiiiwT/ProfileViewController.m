//
//  ProfileViewController.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 10/10/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "ProfileViewController.h"
#import "TweetViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ProfileCell.h"
#import "StatsCell.h"
#import "TwitterClient.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) TwitterClient *client;
@property (strong, nonatomic) TweetCell *prototypeCell;
@property (strong, nonatomic) UIScrollView *profileScrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@end

@implementation ProfileViewController {
    CGPoint panStartCoordinate;
    NSString *direction;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
        self.client = [TwitterClient instance];
        self.tweets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCellProfile"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:[ProfileCell identifier]];
    [self.tableView registerNib:[UINib nibWithNibName:@"StatsCell" bundle:nil] forCellReuseIdentifier:[StatsCell identifier]];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];

}

- (void)viewDidAppear:(BOOL)animated {
    [self setUpNavigationbar];
    [self fetchData];
}

- (TweetCell *)prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCellProfile"];
    }
    return _prototypeCell;
}


#pragma mark - Tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : self.tweets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 150 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        self.profileScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 155)];
        
        ProfileCell *firstCell = [self.tableView dequeueReusableCellWithIdentifier:[ProfileCell identifier]];
        firstCell.isDescription = YES;
        [firstCell configureCellWithUser:self.user];
        CGRect firstFrame;
        firstFrame.origin.x = 0;
        firstFrame.origin.y = 0;
        firstFrame.size = self.profileScrollView.frame.size;
        firstCell.frame = firstFrame;
        [self.profileScrollView addSubview:firstCell];
        
        ProfileCell *secondCell = [self.tableView dequeueReusableCellWithIdentifier:[ProfileCell identifier]];
        secondCell.isDescription = NO;
        [secondCell configureCellWithUser:self.user];
        CGRect secondFrame;
        secondFrame.origin.x = self.view.frame.size.width;
        secondFrame.origin.y = 0;
        secondFrame.size = self.profileScrollView.frame.size;
        secondCell.frame = secondFrame;
        [self.profileScrollView addSubview:secondCell];
        
        [self.profileScrollView setContentSize:CGSizeMake(self.profileScrollView.frame.size.width * 2, self.profileScrollView.frame.size.height)];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnProfileCell:)];
        pan.cancelsTouchesInView = NO;
        [self.profileScrollView addGestureRecognizer:pan];
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 155)];
        [container addSubview:self.profileScrollView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, 115.0, self.view.frame.size.width, 50)];
        [self.pageControl setNumberOfPages:2];
        [container addSubview:self.pageControl];
        [self.pageControl addTarget:self action:@selector(clickOnPageControl) forControlEvents:UIControlEventValueChanged];
        
        return container;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        [self.prototypeCell configureCellWithTweet:self.tweets[indexPath.row]];
        [self.prototypeCell layoutSubviews];
        
        CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height + 1;
    } else {
        return 65;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        StatsCell *cell = (StatsCell *) [self.tableView dequeueReusableCellWithIdentifier:[StatsCell identifier] forIndexPath:indexPath];
        if (!cell) {
            cell = [[StatsCell alloc] init];
        }
        cell.user = self.user;
        return cell;
    } else {
        TweetCell *cell = (TweetCell *) [self.tableView dequeueReusableCellWithIdentifier:@"TweetCellProfile" forIndexPath:indexPath];
        if (!cell) {
            cell = [[TweetCell alloc] init];
        }
        [cell configureCellWithTweet:self.tweets[indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TweetViewController *tweetViewController = [[TweetViewController alloc] init];
    tweetViewController.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:tweetViewController animated:YES];
}

- (IBAction)panOnProfileCell:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.view];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            panStartCoordinate = point;
            break;
        case UIGestureRecognizerStateChanged: {
            float distance = point.x - panStartCoordinate.x;
            if (distance > 0) {
                direction = @"R";
            } else {
                direction = @"L";
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if ([direction isEqualToString:@"R"]) {
                self.pageControl.currentPage -= 1;
            } else {
                self.pageControl.currentPage += 1;
            }
            [self scrollPage];
            break;
        }
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;
    }
}

- (void)clickOnPageControl {
    [self scrollPage];
}

- (void)scrollPage {
    CGRect frame;
    frame.origin.x = self.profileScrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.profileScrollView.frame.size;
    [self.profileScrollView scrollRectToVisible:frame animated:YES];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat distance = self.tableView.contentOffset.y;
    if (distance < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"distanceChanged" object:[NSNumber numberWithFloat:distance]];
    }
}

- (void)fetchData {
    TwitterClient *client = [TwitterClient instance];
    [client timelineWithScreenName:self.user.screenName
                           success:^(AFHTTPRequestOperation *operation, id response) {
                               NSError *error;
                               self.tweets = [Tweet tweetsWithArray:response];
                               if (error) {
                                   NSLog(@"[ProfileViewController fetchData] transform error: %@", error.description);
                               }
                               NSLog(@"[ProfileViewController fetchData] success row count: %ld", self.tweets.count);
                               [self.tableView reloadData];
                           }
                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               NSLog(@"[ProfileViewController fetchData] error: %@", error.description);
                           }];
}

- (void)setUpNavigationbar {
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuIcon"]landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(clickOnMenuButton)];
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)clickOnMenuButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hamburgerClicked" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
