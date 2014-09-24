//
//  CalendarViewController.h
//  Where To Eat?
//
//  Created by Robin on 9/6/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController

@property IBOutletCollection(UILabel) NSArray *restaurant_labels;
@property IBOutletCollection(UILabel) NSArray *date_labels;

@end
