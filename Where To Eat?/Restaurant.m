//
//  Restaurant.m
//  Where To Eat?
//
//  Created by Ginny on 9/6/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

- (instancetype)initWithCategory:(NSString *)category
                            name:(NSString *)name
{
    self = [super init];
    if (self){
        self.category = category;
        self.name = name;
    }
    return self;

}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_category forKey:@"category"];
    [aCoder encodeObject:_name forKey:@"name"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.category = [aDecoder decodeObjectForKey:@"category"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}


@end
