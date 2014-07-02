//
//  TABEmplyee.m
//  TAB iOS test
//
//  Created by Zachary BURGESS on 01/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

#import "TABEmplyee.h"

@interface TABEmplyee ()

@property (copy, nonatomic, readwrite) NSString *image;
@property (copy, nonatomic, readwrite) NSString *name;
@property (copy, nonatomic, readwrite) NSString *title;
@property (copy, nonatomic, readwrite) NSString *miniBio;

@end

@implementation TABEmplyee

- (id)initWithDictionary:(NSDictionary*)paramDictionary {
    self = [super init];
    if (self) {
        if ([[paramDictionary allKeys] containsObject:@"image"]) {
            _image = paramDictionary[@"image"];
        }
        if ([[paramDictionary allKeys] containsObject:@"name"]) {
            _name = paramDictionary[@"name"];
        }
        if ([[paramDictionary allKeys] containsObject:@"title"]) {
            _title = paramDictionary[@"title"];
        }
        if ([[paramDictionary allKeys] containsObject:@"miniBio"]) {
            _miniBio = paramDictionary[@"miniBio"];
        }
    }
    return self;
}

+ (instancetype)employeWithDictionary:(NSDictionary*)paramDictionary {
    return [[TABEmplyee alloc] initWithDictionary:paramDictionary];
}

@end
