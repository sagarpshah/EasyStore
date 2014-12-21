//
//  Holiday.h
//  SyncDemo
//
//  Created by Sagar Shah on 17/12/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSFNanoObject.h"

@interface Holiday : NSFNanoObject

@property (strong, nonatomic) NSString *objectID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSDate *date;

- (void)setHoliday:(Holiday *)aHoliday;

@end
