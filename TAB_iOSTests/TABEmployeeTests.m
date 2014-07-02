//
//  TAB_iOSTests.m
//  TAB_iOSTests
//
//  Created by Zachary BURGESS on 02/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TABEmployee.h"

static NSString * const TABEmployeeTestName = @"frank Mercer";
static NSString * const TABEmployeeTestTitle = @"worker bee";
static NSString * const TABEmployeeTestBio = @"The was born, then went to school, then he got some jobs, then this job!";
static NSString * const TABEmployeeTestImage = @"http://www.fm-base.co.uk/forum/attachments/football-manager-2014-manager-stories/618828d1403554937-ups-downs-building-one-default_original_profile_pic.png";

@interface TABEmployeeTests : XCTestCase

@property (strong, nonatomic) NSDictionary * employeeBuildingDictionary;

@property (strong, nonatomic) TABEmployee * employee;

@end

@implementation TABEmployeeTests

- (void)setUp {
    [super setUp];
    self.employeeBuildingDictionary = @{TABEmployeeNameKey:TABEmployeeTestName,
                                        TABEmployeeTitleKey:TABEmployeeTestTitle,
                                        TABEmployeeMiniBioKey:TABEmployeeTestBio,
                                        TABEmployeeImageKey:TABEmployeeTestImage};
    self.employee = [TABEmployee employeWithDictionary:self.employeeBuildingDictionary];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitilizer {
    TABEmployee *tempEmployee = [[TABEmployee alloc] initWithDictionary:self.employeeBuildingDictionary];
    XCTAssertTrue(tempEmployee, @"un able to make an employee with the expected dictionary");
}

- (void)testFactoryMethod {
    XCTAssertTrue(self.employee, @"un able to make an employee with the factory method using expected dictionary");
}

- (void)testAccess {
    XCTAssertTrue([self.employee.name isEqualToString:TABEmployeeTestName], @"wrong name using expected dictionary");
    XCTAssertTrue([self.employee.title isEqualToString:TABEmployeeTestTitle], @"wrong title using expected dictionary");
    XCTAssertTrue([self.employee.miniBio isEqualToString:TABEmployeeTestBio], @"wrong mini bio using expected dictionary");
    XCTAssertTrue([self.employee.image isEqualToString:TABEmployeeTestImage], @"wrong image using expected dictionary");
}

@end
