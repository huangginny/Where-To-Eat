//
//  Restaurant.h
//  Where To Eat?
//
//  Created by Ginny on 9/6/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property NSString *category, *name;

- (instancetype)initWithCategory:(NSString *)category
                            name:(NSString *)name;

@end
