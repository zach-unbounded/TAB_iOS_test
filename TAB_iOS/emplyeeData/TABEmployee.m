//
//  TABEmployee.m
//  TAB iOS test
//
//  Created by Zachary BURGESS on 01/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

#import "TABEmployee.h"

@interface TABEmployee ()

@property (copy, nonatomic, readwrite) NSString *image;
@property (copy, nonatomic, readwrite) NSString *name;
@property (copy, nonatomic, readwrite) NSString *title;
@property (copy, nonatomic, readwrite) NSString *miniBio;

@end

@implementation TABEmployee

- (id)initWithDictionary:(NSDictionary*)paramDictionary {
    self = [super init];
    if (self) {
        if ([[paramDictionary allKeys] containsObject:TABEmployeeImageKey]) {
            _image = paramDictionary[TABEmployeeImageKey];
        }
        if ([[paramDictionary allKeys] containsObject:TABEmployeeNameKey]) {
            _name = paramDictionary[TABEmployeeNameKey];
        }
        if ([[paramDictionary allKeys] containsObject:TABEmployeeTitleKey]) {
            _title = paramDictionary[TABEmployeeTitleKey];
        }
        if ([[paramDictionary allKeys] containsObject:TABEmployeeMiniBioKey]) {
            _miniBio = paramDictionary[TABEmployeeMiniBioKey];
        }
    }
    return self;
}

+ (instancetype)employeWithDictionary:(NSDictionary*)paramDictionary {
    return [[TABEmployee alloc] initWithDictionary:paramDictionary];
}

@end
