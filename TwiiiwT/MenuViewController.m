//
//  MenuViewController.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 10/12/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "AccountCell.h"
#import "MenuCell.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView reloadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:[MenuCell identifier]];
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountCell" bundle:nil] forCellReuseIdentifier:[AccountCell identifier]];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:[AccountCell identifier]];
    cell.user = [User currentUser];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserImageTap:)];
    [cell.profileImageView addGestureRecognizer:tapGestureRecognizer];
    return cell.contentView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:[MenuCell identifier] forIndexPath:indexPath];
    [cell setMenuItem:self.menuItems[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuSelected" object:self.menuItems[indexPath.row]];
}

- (void)onUserImageTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    profileViewController.user = [User currentUser];
    [self presentViewController:profileViewController animated:YES completion:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"menuSelected" object:profileViewController];
}


@end
