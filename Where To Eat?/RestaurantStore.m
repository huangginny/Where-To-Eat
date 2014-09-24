//
//  RestaurantStore.m
//  Where To Eat?
//
//  Created by Ginny on 9/6/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import "RestaurantStore.h"
#import "SelectableRestaurantStore.h"

@interface RestaurantStore ()

@property (nonatomic, strong) NSMutableDictionary *restaurants;

@end

@implementation RestaurantStore

+ (instancetype)sharedStore
{
    
    static RestaurantStore *sharedStore;
        
    // Do I need to create a sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[RestaurantStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSString *path = [self restaurantsArchivePath];
        _restaurants = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!_restaurants) {
            _restaurants = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (void)addCategory:(NSString*)category{
    NSMutableDictionary *restaurants = [[NSMutableDictionary alloc] init];
    [_restaurants setObject:restaurants forKey:category];
    [[SelectableRestaurantStore sharedStore] addCategory:category];
}

- (void)removeCategory:(NSString*)category{
    [_restaurants removeObjectForKey:category];
    [[SelectableRestaurantStore sharedStore] removeCategory:category];
}

- (void)renameCategory:(NSString*)category
                  with:(NSString*)newName{
    NSMutableDictionary *restaurants = [_restaurants objectForKey:category];
    [self removeCategory:category];
    [_restaurants setObject:restaurants forKey:newName];
    [[SelectableRestaurantStore sharedStore] renameCategory:category with:newName];
}

- (void)addRestaurant:(Restaurant *)restaurant{
    NSMutableDictionary *restaurants = [_restaurants objectForKey:restaurant.category];
    if (! restaurants){
        restaurants = [[NSMutableDictionary alloc] init];
        [_restaurants setObject:restaurants forKey:restaurant.category];
    }
    [restaurants setObject:restaurant forKey:restaurant.name];
    [[SelectableRestaurantStore sharedStore] addRestaurantForCategory:restaurant.category name:restaurant.name];
}

- (void)removeRestaurantForCategory:(NSString *)category
                               name:(NSString *)name
{
    NSMutableDictionary *restaurants = [_restaurants objectForKey:category];
    [restaurants removeObjectForKey:name];
    [[SelectableRestaurantStore sharedStore] removeRestaurantForCategory:category name:name];
}

- (NSArray *)allCategories
{
    return [[_restaurants allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSArray*)allNamesForCategory:(NSString*)category{
    NSMutableDictionary *restaurants = [_restaurants objectForKey:category];
    return [[restaurants allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (Restaurant *)restaurantForCategory:(NSString*)category withName:(NSString*)name{
    NSMutableDictionary *restaurants = [_restaurants objectForKey:category];
    return [restaurants objectForKey:name];
}

- (NSString *)restaurantsArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"restaurants.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self restaurantsArchivePath];
    
    // Returns YES on success
    return [NSKeyedArchiver archiveRootObject:_restaurants
                                       toFile:path];
}


@end
