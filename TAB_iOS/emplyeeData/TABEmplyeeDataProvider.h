//
//  TABEmplyeeDataProvider.h
//  TAB_iOS
//
//  Created by Zachary BURGESS on 01/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

/** */
@interface TABEmplyeeDataProvider : NSObject

/** */
- (void)getEmplyeesFromPage:(NSString*)pageURL
            withCompleation:(void(^)(NSArray* arrayOfEmplyees, NSError * error))compleationBlock;

@end