//
//  TABEmployeeDataProviderTests.m
//  TAB_iOS
//
//  Created by Zachary BURGESS on 02/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TABEmplyeeDataProvider.h"
#import "TABTestConstants.h"

@interface TABEmployeeDataProviderTests : XCTestCase

@end

@implementation TABEmployeeDataProviderTests

- (void)testSharedInstance {
    XCTAssertNotNil([TABEmplyeeDataProvider sharedInstance], @"data provider should be non nil");
}

- (void)testGetEmployeesFromPage {
    BlockStarts();
    [[TABEmplyeeDataProvider sharedInstance] getEmplyeesFromPage:@"http://www.theappbusiness.com/our-team/"
                                                 withCompleation:^(NSArray* arrayOfEmployees, NSError*error ) {
                                                     BlockCompletes();
                                                     XCTAssertNil(error, @"Error should be nil");
                                                     XCTAssertNotNil(arrayOfEmployees, @"array of employees should be non nil");
                                                     XCTAssertTrue(arrayOfEmployees.count > 0, @"array of employees should be more than one");
                                                 }];
    WaitUntilBlockCompletesWithTimeout(TABDefaultTestTimeout);
}

@end
