//
//  Holiday.m
//  SyncDemo
//
//  Created by Sagar Shah on 17/12/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import "Holiday.h"

#define ID      @"objectID"
#define NAME    @"nameKey"
#define DETAILS @"detailsKey"
#define DATE    @"dateKey"

@implementation Holiday

- (id)initNanoObjectFromDictionaryRepresentation:(NSDictionary *)theDictionary forKey:(NSString *)aKey store:(NSFNanoStore *)theStore {
    if (self = [super initNanoObjectFromDictionaryRepresentation:theDictionary forKey:aKey store:theStore]) {
        if (theDictionary != nil) {
            self.objectID = [theDictionary objectForKey:ID];
            self.name = [theDictionary objectForKey:NAME];
            self.details = [theDictionary objectForKey:DETAILS];
            self.date = [theDictionary objectForKey:DATE];
        }
    }
    
    return self;
}

- (NSDictionary *)nanoObjectDictionaryRepresentation {
    NSMutableDictionary *representation = [[NSMutableDictionary alloc] initWithDictionary:[super nanoObjectDictionaryRepresentation]];
    
    [representation setObject:_objectID forKey:ID];
    [representation setObject:_name forKey:NAME];
    [representation setObject:_details forKey:DETAILS];
    [representation setObject:_date forKey:DATE];
    
    return representation;
}

- (id)rootObject {
    return self;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"Holiday - %@", self.key];
}

- (void)setHoliday:(Holiday *)aHoliday {
    self.name = aHoliday.name;
    self.details = aHoliday.details;
    self.date = aHoliday.date;
}

- (void)dealloc {
    self.objectID = nil;
    self.name = nil;
    self.details = nil;
    self.date = nil;
}

@end
