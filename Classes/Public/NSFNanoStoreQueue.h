//
//  NSFNanoStoreQueue.h
//  Midas
//
//  Created by Sagar Shah on 27/10/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSFNanoStore;

@interface NSFNanoStoreQueue : NSObject {
    NSFNanoStore *_store;
}

@property (atomic, strong) NSString *path;

+ (instancetype)createStoreQueueWithType:(NSFNanoStoreType)theType path:(NSString *)thePath;

- (instancetype)initStoreQueueWithType:(NSFNanoStoreType)theType path:(NSString *)thePath;

- (void)inStore:(void (^)(NSFNanoStore *store))block;

@end
