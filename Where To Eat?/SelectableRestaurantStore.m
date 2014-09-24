//
//  SelectableRestaurantStore.m
//  Where To Eat?
//
//  Created by Robin on 9/16/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import "SelectableRestaurantStore.h"
#import "RestaurantStore.h"

@interface SelectableRestaurantStore ()

@property (nonatomic, strong) NSMutableDictionary *restaurants;

@end

@implementation SelectableRestaurantStore

+ (instancetype)sharedStore
{
    
    static SelectableRestaurantStore *sharedStore;
    
    // Do I need to create a sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[SelectableRestaurantStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        if (!_restaurants) {
            _restaurants = [[NSMutableDictionary alloc] init];
            _length = 0;
            for (NSString *cat in [[RestaurantStore sharedStore] allCategories]) {
                NSMutableArray *restaurants = [[NSMutableArray alloc] init];
                [_restaurants setObject:restaurants forKey:cat];
                for (NSString *res in [[RestaurantStore sharedStore] allNamesForCategory:cat]) {
                    [restaurants addObject:res];
                    _length += 1;
                }
            }
        }
    }
    return self;
}

- (void)refresh
{
    _restaurants = [[NSMutableDictionary alloc] init];
    _length = 0;
    for (NSString *cat in [[RestaurantStore sharedStore] allCategories]) {
        NSMutableArray *restaurants = [[NSMutableArray alloc] init];
        [_restaurants setObject:restaurants forKey:cat];
        for (NSString *res in [[RestaurantStore sharedStore] allNamesForCategory:cat]) {
            [restaurants addObject:res];
            _length += 1;
        }
    }
}

- (void)addCategory:(NSString*)category{
    if (! [[_restaurants allKeys] containsObject:category]) {
        NSMutableArray *restaurants = [[NSMutableArray alloc] init];
        [_restaurants setObject:restaurants forKey:category];
    }
}

- (void)removeCategory:(NSString*)category{
    if ([[_restaurants allKeys] containsObject:category]) {
        int len = [[_restaurants objectForKey:category] count];
        [_restaurants removeObjectForKey:category];
        _length -= len;
    }
}

- (void)addRestaurantForCategory:(NSString *)category
                            name:(NSString *)name
{
    NSMutableArray *restaurants = [_restaurants objectForKey:category];
    if (! restaurants){
        restaurants = [[NSMutableArray alloc] init];
        [_restaurants setObject:restaurants forKey:category];
    }
    if (! [restaurants containsObject:name]) {
        [restaurants addObject:name];
        _length += 1;
    }
}

- (void)removeRestaurantForCategory:(NSString *)category
                               name:(NSString *)name
{
    if ([[_restaurants allKeys] containsObject:category]) {
        NSMutableArray *restaurants = [_restaurants objectForKey:category];
        if ([restaurants containsObject:name]) {
            [restaurants removeObject:name];
            _length -= 1;
        }
    }
}

- (void)renameCategory:(NSString*)category
                  with:(NSString*)newName
{
    NSMutableArray *restaurants = [_restaurants objectForKey:category];
    [self removeCategory:category];
    [_restaurants setObject:restaurants forKey:newName];
}

- (NSArray *)allCategories
{
    return [_restaurants allKeys];
}

- (NSArray*)allNamesForCategory:(NSString*)category{
    NSMutableArray *restaurants = [_restaurants objectForKey:category];
    return restaurants;
}

@end

