//
//  NSFNanoStoreQueue.m
//  Midas
//
//  Created by Sagar Shah on 27/10/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import "NSFNanoStoreQueue.h"

static const void * const kDispatchQueueSpecificKey = &kDispatchQueueSpecificKey;

@interface NSFNanoStoreQueue() {
    dispatch_queue_t _queue;
    NSFNanoStoreType storeType;
}

@end

@implementation NSFNanoStoreQueue

@synthesize path = _path;

+ (instancetype)createStoreQueueWithType:(NSFNanoStoreType)theType path:(NSString *)thePath {
    
    NSFNanoStoreQueue *q = [[self alloc] initStoreQueueWithType:theType path:thePath];
    
    return q;
}

+ (Class)storeClass {
    return [NSFNanoStore class];
}

- (instancetype)initStoreQueueWithType:(NSFNanoStoreType)theType path:(NSString *)thePath {
    
    self = [super init];
    
    if (self != nil) {
        
        _store = [[[self class] storeClass] createStoreWithType:theType path:thePath];
        
        storeType = theType;
        
        _path = [[NSString alloc] initWithString:thePath];
        
        _queue = dispatch_queue_create("com.ishisystems.NanoStoreQueue", NULL);
        dispatch_queue_set_specific(_queue, kDispatchQueueSpecificKey, (__bridge void *)self, NULL);
    }
    
    return self;
}

- (NSFNanoStore *)store {
    if (!_store) {
        _store = [[NSFNanoStore alloc] initStoreWithType:storeType path:_path];
    }
    
    return _store;
}

- (void)inStore:(void (^)(NSFNanoStore *store))block {
    NSFNanoStoreQueue *currentSyncQueue = (__bridge id)dispatch_get_specific(kDispatchQueueSpecificKey);
    assert(currentSyncQueue != self && "inStore: was called reentrantly on the same queue, which would lead to a deadlock");
    
    dispatch_sync(_queue, ^() {
        
        NSFNanoStore *store = [self store];
        block(store);
    });
}

- (void)dealloc
{
    self.path = nil;
    _queue = 0x00;
}

@end
