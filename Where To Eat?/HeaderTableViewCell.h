//
//  HeaderTableViewCell.h
//  Where To Eat?
//
//  Created by Robin on 9/18/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionTableViewController.h"

@interface HeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectionButton;

- (void)setTitleForButton: (NSString *)title;
@end
