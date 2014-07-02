//
//  TABEmplyeeDataProvider.m
//  TAB_iOS
//
//  Created by Zachary BURGESS on 01/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

#import "TABEmplyeeDataProvider.h"
#import "TABEmployee.h"
#import "HTMLDocument.h"

static NSString * const TABEmployeeProviderUserDivClassKey          = @"//div[@class='col col2']";
static NSString * const TABEmployeeProviderUserNameTagKey           = @"//h3";
static NSString * const TABEmployeeProviderUserTitleTagKey          = @"//p";
static NSString * const TABEmployeeProviderUserDescriptionTagKey    = @"//p[@class='user-description']";
static NSString * const TABEmployeeProviderUserImageTagKey          = @"//img";
static NSString * const TABEmployeeProviderUserImageAttributeKey    = @"src";

static TABEmplyeeDataProvider *sharedInstance = nil;

@interface TABEmplyeeDataProvider ()

@property (strong, nonatomic) NSOperationQueue * queue;

@property (strong, nonatomic) NSCache * imageCache;

@end

@implementation TABEmplyeeDataProvider

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [TABEmplyeeDataProvider new];
    });
    return sharedInstance;
}

-(id)init {
    self = [super init];
    if (self) {
        _queue = [NSOperationQueue new];
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
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       compleationBlock(nil,connectionError);
                                   });
                               }
                               else {
                                   HTMLDocument * doc = [HTMLDocument HTMLDocumentWithHTMLData:data encoding:nil];
                                   NSMutableArray * employees = [NSMutableArray new];
                                   NSArray * array = [doc searchWithXPathQuery:TABEmployeeProviderUserDivClassKey];
                                   for (HTMLElement * element in array) {
                                       NSString * name = ((HTMLElement *)((HTMLElement *)[element searchWithXPathQuery:TABEmployeeProviderUserNameTagKey][0]).children[0]).content;
#warning check this doesn't break if the right p is not in the right order!
                                       NSString * title = ((HTMLElement *)((HTMLElement *)[element searchWithXPathQuery:TABEmployeeProviderUserTitleTagKey][0]).children[0]).content;
                                       NSString * description = ((HTMLElement *)((HTMLElement *)[element searchWithXPathQuery:TABEmployeeProviderUserDescriptionTagKey][0]).children[0]).content;
                                       NSString * imageUrl = ((HTMLElement*)[element searchWithXPathQuery:TABEmployeeProviderUserImageTagKey][0]).attributes[TABEmployeeProviderUserImageAttributeKey];
                                       NSDictionary *employeeDictionary = @{TABEmployeeNameKey: name,TABEmployeeTitleKey: title,TABEmployeeMiniBioKey:description,TABEmployeeImageKey:imageUrl};
                                       TABEmployee * employee = [TABEmployee employeWithDictionary:employeeDictionary];
                                       employees[employees.count] = employee;
                                   }
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       compleationBlock([employees copy],nil);
                                   });
                               }
                           }];
}

- (void)getImageForURL:(NSString*)paramUrl withCompleation:(void(^)(UIImage* image, NSError * error))paramCompleation {
    if([self.imageCache objectForKey:paramUrl]) {
        UIImage * image = [self.imageCache objectForKey:paramUrl];
        paramCompleation(image,nil);
    }
    else {
        NSURL * url = [NSURL URLWithString:paramUrl];
        NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:self.queue
                               completionHandler:^(NSURLResponse *responce, NSData * data, NSError *connectionError) {
                                   if (connectionError) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           paramCompleation(nil,connectionError);
                                       });
                                   }
                                   else {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [self.imageCache setObject:[UIImage imageWithData:data] forKey:paramUrl];
                                           paramCompleation([UIImage imageWithData:data],nil);
                                       });
                                   }
                               }];
    }
}

@end
