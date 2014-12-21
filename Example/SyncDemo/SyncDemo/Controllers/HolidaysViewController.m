//
//  HolidaysViewController.m
//  SyncDemo
//
//  Created by Sagar Shah on 17/12/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import "HolidaysViewController.h"
#import "HolidayTableViewCell.h"
#import "AFHTTPRequestOperation.h"
#import "Constants.h"
#import "Holiday.h"
#import "AppDelegate.h"
#import "HolidayHelper.h"

@interface HolidaysViewController () {
    NSMutableArray *holidaysArray;
    AppDelegate *appDelegate;
}

@property (strong, nonatomic) AFHTTPRequestOperation *holidayFetchOperation;

@end

@implementation HolidaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.holidayTableView.separatorInset = UIEdgeInsetsZero;
    if ([self.holidayTableView respondsToSelector:@selector(layoutMargins)]) {
        self.holidayTableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    holidaysArray = [[NSMutableArray alloc] init];
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
//    [self fetchLocalHolidays];
    [self fetchHolidays];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)fetchLocalHolidays {
    [appDelegate.nanoStoreQueue inStore:^(NSFNanoStore *store) {
        NSFNanoSearch *search = [NSFNanoSearch searchWithStore:store];
        search.filterClass = NSStringFromClass([Holiday class]);
        
        NSArray *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
        [holidaysArray addObjectsFromArray:searchResults];
    }];
}

- (void)fetchHolidays {
    if ([_holidayFetchOperation isExecuting]) {
        [_holidayFetchOperation cancel];
        _holidayFetchOperation = nil;
    }
    
    NSString *parseRestAPIURLString = [kServerBaseURL stringByAppendingString:kServerAPIPath];
    NSString *retrieveHolidaysURLString = [parseRestAPIURLString stringByAppendingString:NSStringFromClass([Holiday class])];
    
    __weak __typeof(self) weakSelf = self;
    
    self.holidayFetchOperation = [appDelegate.operationManager GET:retrieveHolidaysURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf parseHolidaysResultAndDisplay:[responseObject objectForKey:@"results"]];
        
        if (operation == _holidayFetchOperation) {
            strongSelf.holidayFetchOperation = nil;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        if (operation == _holidayFetchOperation) {
            __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.holidayFetchOperation = nil;
        }
    }];
}

- (void)parseHolidaysResultAndDisplay:(NSArray *)results {
    
//////    **** Step - 1 **** Parse all holidays from server & save it.
    
    NSArray *parsedHolidays = [HolidayHelper parseHolidays:results];
    [holidaysArray setArray:parsedHolidays];
    
//////
    
//////    **** Step - 2 **** Parse all holidays from server & update existing
    
//    NSArray *parsedHolidays = [HolidayHelper parseHolidays:results];
//    
//    NSArray *existingHolidays = [[NSMutableArray alloc] initWithArray:holidaysArray];
//    [holidaysArray removeAllObjects];
//    
//    for (Holiday *holiday in parsedHolidays) {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.objectID LIKE '%@'", holiday.objectID];
//        NSArray *array = [existingHolidays filteredArrayUsingPredicate:predicate];
//        if (array.count) {
//            Holiday *existingHoliday = [array objectAtIndex:0];
//            [existingHoliday setHoliday:holiday];
//            [holidaysArray addObject:existingHoliday];
//        } else {
//            [holidaysArray addObject:holiday];
//        }
//    }
    
/////
    
    [appDelegate.nanoStoreQueue inStore:^(NSFNanoStore *store) {
        [store addObjectsFromArray:holidaysArray error:nil];
    }];
    [_holidayTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return holidaysArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"HolidayTableViewCell";
    
    HolidayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    Holiday *holiday = [holidaysArray objectAtIndex:indexPath.row];
    
    cell.holidayTitleLabel.text = holiday.name;
    
    return cell;
}

- (void)dealloc {
    self.holidayTableView = nil;
    
    if ([_holidayFetchOperation isExecuting]) {
        [_holidayFetchOperation cancel];
    }
    
    self.holidayFetchOperation = nil;
}

@end
