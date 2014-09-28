//
//  DiceTableViewController.h
//  Where To Eat?
//
//  Created by Robin on 9/10/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiceTableViewController : UITableViewController <UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>

@property NSMutableArray *selectedCategory;
@property (weak, nonatomic) IBOutlet UILabel *meals_label;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end
