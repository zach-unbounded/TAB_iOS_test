//
//  TABEmployee.h
//  TAB iOS test
//
//  Created by Zachary BURGESS on 01/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

static NSString * const TABEmployeeImageKey     = @"image";
static NSString * const TABEmployeeNameKey      = @"name";
static NSString * const TABEmployeeTitleKey     = @"title";
static NSString * const TABEmployeeMiniBioKey   = @"miniBio";

/** an employee record*/
@interface TABEmployee : NSObject

/** the url of the employee's image*/
@property (copy, nonatomic, readonly) NSString *image;

/** the employee's name*/
@property (copy, nonatomic, readonly) NSString *name;

/** the employee's job title*/
@property (copy, nonatomic, readonly) NSString *title;

/** a min bio for the employee*/
@property (copy, nonatomic, readonly) NSString *miniBio;

/** initialize with dictionary
 @param paramDictionary a dictionary containing the employee details
 @return the instance initilized*/
- (id)initWithDictionary:(NSDictionary*)paramDictionary;

/** factory method with dictionary
 @param paramDictionary a dictionary containing the employee details
 @return an initilized instance*/
+ (instancetype)employeWithDictionary:(NSDictionary*)paramDictionary;

@end
