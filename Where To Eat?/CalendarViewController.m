//
//  CalendarViewController.m
//  Where To Eat?
//
//  Created by Robin on 9/6/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import "CalendarViewController.h"
#import "History.h"

@interface CalendarViewController ()

@property (strong, nonatomic) NSDateFormatter *dateFormat;
@property (strong, nonatomic) NSMutableArray *strings;

@end

@implementation CalendarViewController

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
    // Do any additional setup after loading the view from its nib.
    _dateFormat = [[NSDateFormatter alloc] init];
    [_dateFormat setDateFormat:@"MMM dd"];
    _strings = [[NSMutableArray alloc] init];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    _strings = [[NSMutableArray alloc] init];
    [[[History history] allDates] enumerateObjectsUsingBlock:^ (id obj, NSUInteger idx, BOOL *stop) {
        NSString *nextDate = [_dateFormat stringFromDate:obj];
        if ([_strings count] == 0 || ![nextDate isEqualToString:[_strings lastObject]]) {
            [_strings addObject:[_dateFormat stringFromDate:obj]];
        }
    }];
    int num = [_strings count];
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int count = 0;
    for (NSDate *date in [[History history] allDates]) {
        NSString *formatted = [_dateFormat stringFromDate:date];
        if ([formatted isEqualToString:[_strings objectAtIndex:section]]) {
            count ++;
        }
    }
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_strings objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *section_date = [_strings objectAtIndex:indexPath.section];
    int count = 0;
    for (int i = 0; i < 5; i++) {
        NSString *date = [_dateFormat stringFromDate:[[[History history] allDates] objectAtIndex:i]];
        if ([date isEqualToString:section_date]) {
            if (count == indexPath.row) {
                cell.textLabel.text = [[[History history] allNames] objectAtIndex:i];
                break;
            } else {
                count ++;
            }
        }
    }
    return cell;
}

@end
