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
}

- (void)viewWillAppear:(BOOL)animated
{
    NSArray *names = [[History history] allNames];
    NSArray *dates = [[History history] allDates];
    for (int i = 0; i < 5; i++) {
        UILabel *restaurant_label = [_restaurant_labels objectAtIndex:i];
        UILabel *date_label = [_date_labels objectAtIndex:i];
        if (i < [names count]) {
            restaurant_label.text = [names objectAtIndex:i];
            date_label.text = [_dateFormat stringFromDate:[dates objectAtIndex:i]];
        } else {
            restaurant_label.text = @"";
            date_label.text = @"";
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
