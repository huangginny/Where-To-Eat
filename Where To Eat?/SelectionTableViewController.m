//
//  SelectionTableViewController.m
//  Where To Eat?
//
//  Created by Robin on 9/7/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import "SelectionTableViewController.h"
#import "RestaurantStore.h"
#import "SelectableRestaurantStore.h"
#import "HeaderTableViewCell.h"

@implementation SelectionTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Select restaurants";
    //self.tableView.sectionHeaderHeight = 60;
    self.tableView.sectionFooterHeight = 0;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[[RestaurantStore sharedStore] allCategories] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *category = [[[RestaurantStore sharedStore] allCategories] objectAtIndex:section];
    return [[[RestaurantStore sharedStore] allNamesForCategory: category] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSString *category = [[[RestaurantStore sharedStore] allCategories] objectAtIndex:indexPath.section];
    NSArray *restaurants = [[RestaurantStore sharedStore] allNamesForCategory: category];
    
    cell.textLabel.text = [restaurants objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([[[SelectableRestaurantStore sharedStore] allCategories] containsObject:category]
        && [[[SelectableRestaurantStore sharedStore] allNamesForCategory:category] containsObject:cell.textLabel.text]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *category = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    NSString *restaurant = cell.textLabel.text;
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [[SelectableRestaurantStore sharedStore] removeRestaurantForCategory:category name:restaurant];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [[SelectableRestaurantStore sharedStore] addRestaurantForCategory:category name:restaurant];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    NSUInteger length = [[[SelectableRestaurantStore sharedStore] allNamesForCategory:category] count];
    if (length == 0 || length == 1) {
        [self.tableView reloadData];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[RestaurantStore sharedStore] allCategories] objectAtIndex:section];
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerIdentifier = @"headerCell";
    HeaderTableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:headerIdentifier];
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    NSString *category = [self tableView:tableView titleForHeaderInSection:section];
    headerView.categoryLabel.text = category;

    if ([[[SelectableRestaurantStore sharedStore] allNamesForCategory:category] count] == 0) {
        [headerView setTitleForButton:@"Select all"];
    } else {
        [headerView setTitleForButton:@"Deselect all"];
    }
    headerView.selectionButton.tag = section;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (IBAction)selectCellsInSection:(id)sender {
    
    NSInteger section = [sender tag];
    
    NSInteger row = [self.tableView numberOfRowsInSection:section];
    NSString *category = [[[RestaurantStore sharedStore] allCategories] objectAtIndex:section];
    if ([[sender titleForState:UIControlStateNormal]  isEqual: @"Select all"]) {
        for (int r = 0; r < row; r ++) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:section]];
            NSString *name = cell.textLabel.text;
            [[SelectableRestaurantStore sharedStore] addRestaurantForCategory:category name:name];
        }
    } else {
        [[SelectableRestaurantStore sharedStore] removeCategory:category];
    }
    [self.tableView reloadData];
}


@end
