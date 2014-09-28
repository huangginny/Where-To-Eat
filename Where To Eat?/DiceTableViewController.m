//
//  DiceTableViewController.m
//  Where To Eat?
//
//  Created by Robin on 9/10/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import "DiceTableViewController.h"
#import "SelectableRestaurantStore.h"
#import "Restaurant.h"
#import "RestaurantStore.h"

#import "History.h"

@interface DiceTableViewController ()

@property NSArray *picker_data;
@property Restaurant *restaurant;
@property int history;

@end

@implementation DiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _picker_data = [[NSArray alloc] initWithObjects:@"5",@"4",@"3",@"2",@"1",@"0", nil];
    _history = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismissPicker:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickDays:(id)sender {
    if (_picker.hidden) {
        NSUInteger val = [_picker_data indexOfObject:_meals_label.text];
        _picker.hidden = NO;
        _picker.showsSelectionIndicator = YES;
        [_picker selectRow:val inComponent:0 animated:NO];
        [_picker reloadAllComponents];
    }
    else {
        [self dismissPicker:nil];
    }
}

- (void)updateHistory {
    int current = (int)MIN([_meals_label.text intValue], [[[History history] allNames] count]);
    if (_meals_label.text.intValue != current) {
        _meals_label.text = [NSString stringWithFormat:@"%d", current];
    }
    //NSLog(@"%d",current);
    if (current > _history) {
        NSLog(@"current greater than history");
        // remove from selectedstore
        NSArray *toRemove = [[History history] getRestaurantFromTime:_history toTime:current];
        for (Restaurant *res in toRemove) {
            NSLog(@"%@, %@", res.category, res.name);
            [[SelectableRestaurantStore sharedStore] removeRestaurantForCategory:res.category name:res.name];
        }
    } else if (current < _history) {
        NSLog(@"current less than history");
        // add more selected store
        NSArray *toAdd = [[History history] getRestaurantFromTime:current toTime:_history];
        for (Restaurant *res in toAdd) {
            [[SelectableRestaurantStore sharedStore] addRestaurantForCategory:res.category name:res.name];
        }
    }
    _history = current;
}

/*
 * Click Yes or Cancel to reset
 * Click "Roll again" to remove
 */
- (IBAction)roll:(id)sender {
    [self dismissPicker:nil];
    if ([[SelectableRestaurantStore sharedStore] length] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No restaurant for selection!" message:@"Go and add some more." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    } else {
        NSArray *cats = [[SelectableRestaurantStore sharedStore] allCategories];
        NSString *cat = [cats objectAtIndex:arc4random_uniform([cats count])];
        NSArray *restaurants = [[SelectableRestaurantStore sharedStore] allNamesForCategory:cat];
        
        while (restaurants == nil || [restaurants count] == 0) {
            cat = [cats objectAtIndex:arc4random_uniform([cats count])];
            restaurants = [[SelectableRestaurantStore sharedStore] allNamesForCategory:cat];
        }
        NSString *res = [restaurants objectAtIndex:arc4random_uniform([restaurants count])];
        _restaurant = [[RestaurantStore sharedStore] restaurantForCategory:cat withName:res];
        UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:res message:@"Are you going there now?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", @"Roll Another", nil];
        [dialog show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // Cancel
        if ([[alertView buttonTitleAtIndex:buttonIndex]  isEqual: @"Cancel"]) {
            [[SelectableRestaurantStore sharedStore] refresh];
            _history = 0;
            _meals_label.text = @"0";
        }
    } else if(buttonIndex == 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"This restaurant has been added to calendar." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [[History history] addEntryWithName:_restaurant.name
                                   category:_restaurant.category
                                        date: [NSDate date]];
        [[SelectableRestaurantStore sharedStore] refresh];
        _history = 0;
        _meals_label.text = @"0";
    } else {
        // Roll again
        [[SelectableRestaurantStore sharedStore] removeRestaurantForCategory:_restaurant.category name:_restaurant.name];
        [self roll:nil];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
    
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [_picker_data count];
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component

{
    
    return [_picker_data objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component //calls when any item gets select in picker

{
    _meals_label.text = [_picker_data objectAtIndex:row];
    
}

- (IBAction)dismissPicker:(id)sender {
    if (_picker.hidden == NO) {
        _picker.hidden = YES;
        [self updateHistory];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView
                                  cellForRowAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int customTableCellHeight = 72;
    if (indexPath.section == 1) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        return screenRect.size.height - 270;
    }
    return customTableCellHeight;
}

@end
