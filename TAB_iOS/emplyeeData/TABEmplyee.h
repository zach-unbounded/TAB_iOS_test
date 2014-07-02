//
//  TABEmploye.h
//  TAB iOS test
//
//  Created by Zachary BURGESS on 01/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

/** */
@interface TABEmplyee : NSObject

/** */
@property (copy, nonatomic, readonly) NSString *image;
/** */
@property (copy, nonatomic, readonly) NSString *name;
/** */
@property (copy, nonatomic, readonly) NSString *title;
/** */
@property (copy, nonatomic, readonly) NSString *miniBio;

/** */
- (id)initWithDictionary:(NSDictionary*)paramDictionary;

/** */
+ (instancetype)employeWithDictionary:(NSDictionary*)paramDictionary;

@end
