//
//  RestaurantsTableViewController.m
//  Where To Eat?
//
//  Created by Robin on 9/7/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import "RestaurantsTableViewController.h"
#import "RestaurantStore.h"

@interface RestaurantsTableViewController ()

@end

@implementation RestaurantsTableViewController

- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super init];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        // Create a new bar button item that will send
        // addNewItem: to BNRItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addRestaurant:)];
        
        // Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[RestaurantStore sharedStore] allNamesForCategory: _category] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *restaurants = [[RestaurantStore sharedStore] allNamesForCategory: _category];
    cell.textLabel.text = [restaurants objectAtIndex:indexPath.row];
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *restaurants = [[RestaurantStore sharedStore] allNamesForCategory:_category];
        [[RestaurantStore sharedStore] removeRestaurantForCategory:_category name:[restaurants objectAtIndex:indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

- (void)setCategory:(NSString *)category
{
    _category = category;
    self.navigationItem.title = category;
}

- (void)addRestaurant:(id)sender
{
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Add a restaurant! \n"
                                                     message:@"\n\n Enter new restaurant name:"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"OK", nil];
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [dialog show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]){
        NSString *text = [alertView textFieldAtIndex:0].text;
        NSArray *restaurants = [[RestaurantStore sharedStore] allNamesForCategory:_category];
        if (![restaurants containsObject:text]) {
            // Create a new Category and add it to the store
            Restaurant *restaurant = [[Restaurant alloc] initWithCategory:_category name:text];
            [[RestaurantStore sharedStore] addRestaurant:restaurant];
            
            // Figure out where that item is in the array
            NSInteger lastRow = [[[RestaurantStore sharedStore] allNamesForCategory:_category] indexOfObject:text];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
            
            // Insert this new row into the table.
            [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationTop];
            
        }
    }
}



@end
