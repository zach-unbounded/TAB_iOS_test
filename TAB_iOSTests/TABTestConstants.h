//
//  NSObject_TDTestConstants.h
//  TAB_iOS
//
//  Created by Zachary BURGESS on 02/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

static NSTimeInterval const TABDefaultTestTimeout = 5;

// Set the flag for a block completion handler
#define BlockStarts() __block BOOL testBlock__waitingForResponse = YES

// Set the flag to stop the loop
#define BlockCompletes() \
do { \
    testBlock__waitingForResponse = NO; \
    CFRunLoopStop([[NSRunLoop currentRunLoop] getCFRunLoop]); \
} while(0)

// Wait and loop until flag is set
#define WaitUntilBlockCompletesWithTimeout(timeout) WaitWithConditions(testBlock__waitingForResponse, timeout)

// Macro - Wait for condition to be NO/false in blocks and asynchronous calls
#define WaitWithConditions(condition, timeout) \
do { \
    NSDate *testBlock__timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeout]; \
    while(condition && [testBlock__timeoutDate timeIntervalSinceNow] > 0.0) { \
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:testBlock__timeoutDate]; \
    } \
    XCTAssertFalse(testBlock__waitingForResponse, @"Timeout reached"); \
} while(0)