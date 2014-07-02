//
//  HTMLDocumentTests.m
//  TAB_iOS
//
//  Created by Zachary BURGESS on 01/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HTMLDocument.h"

static NSString * const TABTestHtmlFile = @"doctest.html";

static NSString * const TABTestHTMLSearchString = @"//body";

@interface HTMLDocumentTests : XCTestCase

@property (strong, nonatomic) HTMLDocument * HTMLDocument;

@property (strong, nonatomic) HTMLDocument * HTMLInitDocument;

@end

@implementation HTMLDocumentTests

-(NSData *)loadFile:(NSString *)name {
    NSBundle *unitTestBundle = [NSBundle bundleForClass:[self class]];
    NSString *pathForFile    = [unitTestBundle pathForResource:name ofType:nil];
    NSData   *data           = [[NSData alloc] initWithContentsOfFile:pathForFile];
    return data;
}

- (void)setUp {
    [super setUp];
    self.HTMLDocument = [HTMLDocument HTMLDocumentWithHTMLData:[self loadFile:TABTestHtmlFile] encoding:nil];
    self.HTMLInitDocument = [[HTMLDocument alloc] initWithData:[self loadFile:TABTestHtmlFile] encoding:nil];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testHTMLFactoryMethod {
    XCTAssertTrue(self.HTMLDocument.data, @"document should have data");
}

- (void)testHTMLBasicInitiliser {
    XCTAssertTrue(self.HTMLInitDocument.data, @"document should have data");
}

- (void)testHTMLSearchForBody {
    NSArray *array = [self.HTMLDocument searchWithXPathQuery:TABTestHTMLSearchString];
    XCTAssertTrue(array.count > 0, @"nothing in the body of the HTML");
}

#warning Add more tests based on actual usage

@end
