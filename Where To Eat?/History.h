//
//  History.h
//  Where To Eat?
//
//  Created by Robin on 9/20/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject

+ (instancetype) history;

- (NSArray *) getRestaurantFromTime: (int)start
                           toTime: (int)end;

- (NSArray *) allNames;

- (NSArray *) allDates;

- (void) addEntryWithName: (NSString *)name
                 category: (NSString *)category
                     date: (NSDate *)date;

- (BOOL)saveChanges;
@end
