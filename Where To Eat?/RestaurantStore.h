//
//  RestaurantStore.h
//  Where To Eat?
//
//  Created by Ginny on 9/6/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface RestaurantStore : NSObject

@property (nonatomic, readonly, copy) NSArray *allCategories;

+ (instancetype)sharedStore;

- (void)addCategory:(NSString*)category;

- (void)removeCategory:(NSString*)category;

- (void)renameCategory:(NSString*)category with:(NSString*)newName;

- (void)addRestaurant:(Restaurant*)restaurant;

- (void)removeRestaurantForCategory:(NSString *)category
                               name:(NSString *)name;

- (NSArray*)allNamesForCategory:(NSString*)category;

- (Restaurant*)restaurantForCategory:(NSString*)category withName:(NSString*)name;

- (BOOL)saveChanges;


@end
