//
//  SYNExampleTableViewController.m
//  SYNParallaxObserverExample
//
//  Created by Sam Corder on 3/13/14.
//  Copyright (c) 2014 Synapptic Labs. All rights reserved.
//

#import "SYNExampleTableViewController.h"

#import "SYNNavBarHideScrollObserver.h"

@interface SYNExampleTableViewController () <UITableViewDataSource>
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

    self.navBarScrollObserver = [[SYNNavBarHideScrollObserver alloc] initWithObservedScrollView:self.tableView navigationController:self.navigationController];
    self.navBarScrollObserver.travelThreshold = self.tableView.rowHeight * 1.5;
    [self.navBarScrollObserver startObserving];
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

/*
   // Override to support conditional editing of the table view.
   - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
   {
    // Return NO if you do not want the specified item to be editable.
    return YES;
   }
 */

/*
   // Override to support editing the table view.
   - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
   {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
   }
 */

/*
   // Override to support rearranging the table view.
   - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
   {
   }
 */

/*
   // Override to support conditional rearranging of the table view.
   - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
   {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
   }
 */

/*
   #pragma mark - Navigation

   // In a story board-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
   {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }

 */

@end
