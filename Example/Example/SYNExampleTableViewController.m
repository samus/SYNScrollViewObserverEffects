//
//  SYNExampleTableViewController.m
//  SYNParallaxObserverExample
//
//  Created by Sam Corder on 3/13/14.
//  Copyright (c) 2014 Synapptic Labs. All rights reserved.
//

#import "SYNExampleTableViewController.h"

#import "SYNNavBarHideScrollObserver.h"

@interface SYNExampleTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *rows;
@property (strong, nonatomic) SYNNavBarHideScrollObserver *navBarScrollObserver;
@end

@implementation SYNExampleTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.rows = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",
                  @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j",
                  @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t",
                  @"u", @"v", @"w", @"x", @"y", @"z"];

    self.navBarScrollObserver = [[SYNNavBarHideScrollObserver alloc] initWithObservedScrollView:self.tableView inViewController:self];
    self.navBarScrollObserver.travelThreshold = self.tableView.rowHeight * 1.5;
    [self.navBarScrollObserver startObserving];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = self.rows[indexPath.row];
    // Configure the cell...

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detail" sender:self];
}

@end
