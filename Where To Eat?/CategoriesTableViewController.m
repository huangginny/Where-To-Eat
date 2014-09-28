//
//  CategoriesTableViewController.m
//  Where To Eat?
//
//  Created by Robin on 9/7/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import "CategoriesTableViewController.h"
#import "RestaurantStore.h"
#import "SelectableRestaurantStore.h"
#import "RestaurantsTableViewController.h"

@interface CategoriesTableViewController ()

@end

@implementation CategoriesTableViewController

- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationItem *bar = self.navigationItem;
    bar.leftBarButtonItem = self.editButtonItem;
    
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
    return [[[RestaurantStore sharedStore] allCategories] count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableview
    NSArray *items = [[RestaurantStore sharedStore] allCategories];
    NSString *item = items[indexPath.row];
    
    cell.textLabel.text = item;
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *categories = [[RestaurantStore sharedStore] allCategories];
        NSString *category = categories[indexPath.row];
        [[RestaurantStore sharedStore] removeCategory:category];
        [[SelectableRestaurantStore sharedStore] removeCategory:category];
        
        // Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }

}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantsTableViewController *rvc = [[RestaurantsTableViewController alloc] init];
    
    NSArray *categories = [[RestaurantStore sharedStore] allCategories];
    NSString *selectedCategory = categories[indexPath.row];
    
    // Give detail view controller a pointer to the item object in row
    rvc.category = selectedCategory;
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:rvc
                                         animated:YES];
}

- (IBAction)addNewCategory:(id)sender
{
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Add a category! \n"
                                                     message:@"\n\n Enter new category name:"
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
        if (![[[RestaurantStore sharedStore] allCategories] containsObject:text]) {
            // Create a new Category and add it to the store
            [[RestaurantStore sharedStore] addCategory:text];
            
            // Figure out where that item is in the array
            NSInteger lastRow = [[[RestaurantStore sharedStore] allCategories] indexOfObject:text];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
            
            // Insert this new row into the table.
            [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationTop];
            
        }
    }
}


@end
