//
//  History.m
//  Where To Eat?
//
//  Created by Robin on 9/20/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import "History.h"
#import "Restaurant.h"
#import "RestaurantStore.h"
#import "SelectableRestaurantStore.h"

@interface History ()

@property (nonatomic, strong) NSMutableArray *queue;
@property (nonatomic, strong) NSMutableArray *dates;

@end

@implementation History

+ (instancetype)history
{
    
    static History *history;
    
    // Do I need to create a sharedStore?
    if (!history) {
        history = [[self alloc] initPrivate];
    }
    
    return history;
}


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[History history]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSString *path1 = [self historyArchivePath];
        NSString *path2 = [self dateArchivePath];
        _queue = [NSKeyedUnarchiver unarchiveObjectWithFile:path1];
        _dates = [NSKeyedUnarchiver unarchiveObjectWithFile:path2];
        if (!_queue) {
            _queue = [[NSMutableArray alloc] init];
            _dates = [[NSMutableArray alloc] init];
        }
        
    }
    return self;
}

- (NSString *)historyArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"histories.archive"];
}

- (NSString *)dateArchivePath
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"dates.archive"];
}

- (BOOL)saveChanges
{
    NSString *path1 = [self historyArchivePath];
    NSString *path2 = [self dateArchivePath];
    // Returns YES on success
    BOOL boolean1 = [NSKeyedArchiver archiveRootObject:_queue
                                       toFile:path1];
    BOOL boolean2 = [NSKeyedArchiver archiveRootObject:_dates toFile:path2];
    return boolean1 && boolean2;
}

/*
 * @params: start(inclusive), end(not inclusive)
 */
- (NSArray *) getRestaurantFromTime: (int)start
                             toTime: (int)end
{
    NSMutableArray *restaurants = [[NSMutableArray alloc] init];
    for (int i = start; i < end; i++) {
        [restaurants addObject:[_queue objectAtIndex:i]];
    }
    return [restaurants copy];
}

- (NSArray *) allNames
{
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (Restaurant *res in _queue) {
        [names addObject:res.name];
    }
    return [names copy];
}

- (NSArray *) allDates
{
    return [_dates copy];
}

- (void) addEntryWithName: (NSString *)name
                 category: (NSString *)category
                     date: (NSDate *)date
{
    if ([_queue count] == 5) {
        // remove the first one
        [_queue removeObjectAtIndex:0];
        [_dates removeObjectAtIndex:0];
    }
    Restaurant *restaurant = [[RestaurantStore sharedStore] restaurantForCategory:category withName:name];
    [_queue addObject:restaurant];
    [_dates addObject:date];
}
@end
