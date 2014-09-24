//
//  HeaderTableViewCell.m
//  Where To Eat?
//
//  Created by Robin on 9/18/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import "HeaderTableViewCell.h"
#import "SelectionTableViewController.h"

@interface HeaderTableViewCell ()

@end

@implementation HeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleForButton:(NSString *)title
{
    [_selectionButton setTitle:title forState:UIControlStateNormal];
    [_selectionButton setNeedsDisplay];
}

@end
