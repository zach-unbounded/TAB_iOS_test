//
//  TABEmplyeeDataProvider.h
//  TAB_iOS
//
//  Created by Zachary BURGESS on 01/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

/** a data provider for employment records*/
@interface TABEmplyeeDataProvider : NSObject

/** singlton instance */
+ (instancetype)sharedInstance;

/** extracts employee records from a compatible web page with given url
 @param paramPageURL the url of the page
 @param paramCompleationBlock block to be ran on compleation*/
- (void)getEmplyeesFromPage:(NSString*)paramPageURL
            withCompleation:(void(^)(NSArray* arrayOfEmplyees, NSError * error))paramCompleationBlock;

@end