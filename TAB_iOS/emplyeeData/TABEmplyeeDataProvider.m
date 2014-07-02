//
//  TABEmplyeeDataProvider.m
//  TAB_iOS
//
//  Created by Zachary BURGESS on 01/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

#import "TABEmplyeeDataProvider.h"
#import "TABEmplyee.h"
#import "HTMLDocument.h"

@interface TABEmplyeeDataProvider ()

@property (strong, nonatomic) NSOperationQueue * queue;

@end

@implementation TABEmplyeeDataProvider

-(id)init {
    self = [super init];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}


- (void)getEmplyeesFromPage:(NSString*)pageURL
            withCompleation:(void(^)(NSArray* arrayOfEmplyees, NSError * error))compleationBlock {
    NSURL * url = [NSURL URLWithString:pageURL];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.queue
                           completionHandler:^(NSURLResponse *responce, NSData * data, NSError *connectionError){
                               if (connectionError) {
                                   compleationBlock(nil,connectionError);
                               }
                               else {
                                   HTMLDocument * doc = [HTMLDocument HTMLDocumentWithHTMLData:data encoding:nil];
                                   NSMutableArray * employees = [NSMutableArray new];
                                   NSArray * array = [doc searchWithXPathQuery:@"row"];
                                   for (HTMLElement*element in array) {
                                       TABEmplyee * employee = [TABEmplyee employeWithDictionary:element.node];
                                       employees[employees.count] = employee;
                                   }
                                   compleationBlock([employees copy],nil);
                               }
                           }];
}

@end
