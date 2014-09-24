//
//  SelectableRestaurantStore.h
//  Where To Eat?
//
//  Created by Robin on 9/16/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface SelectableRestaurantStore : NSObject

@property (nonatomic, readonly, copy) NSArray *allCategories;
@property int length;

+ (instancetype)sharedStore;

- (void)refresh;

- (void)addCategory:(NSString*)category;

- (void)removeCategory:(NSString*)category;

- (void)renameCategory:(NSString*)category
                  with:(NSString *)newName;

- (void)addRestaurantForCategory:(NSString *)category
                            name:(NSString *)name;

- (void)removeRestaurantForCategory:(NSString *)category
                               name:(NSString *)name;

- (NSArray*)allNamesForCategory:(NSString*)category;

@end
