//
//  HTMLElementTests.m
//  TAB_iOS
//
//  Created by Zachary BURGESS on 02/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HTMLElement.h"

static NSString * const TABTestHTMLSearchString = @"//div[@class='special_div']";

@interface HTMLElementTests : XCTestCase

@property (strong, nonatomic) HTMLElement * element;

@property (strong, nonatomic) HTMLElement * elementInit;

@property (strong, nonatomic) NSDictionary * testDictionary;

@end

@implementation HTMLElementTests

- (void)setUp {
    [super setUp];
    self.testDictionary = @{ @"nodeAttributeArray" : @[ @{ @"attributeName" : @"class", @"nodeContent" : @"html_body" } ], @"nodeChildArray" : @[ @{ @"nodeChildArray" : @[ @{ @"nodeChildArray" : @[ @{ @"nodeContent" : @"this is a test document", @"nodeName" : @"text" } ], @"nodeName" : @"p", @"raw" : @"<p>this is a test document</p>" } ], @"nodeName" : @"div", @"raw" : @"<div><p>this is a test document</p></div>" }, @{ @"nodeAttributeArray" : @[ @{ @"attributeName" : @"class", @"nodeContent" : @"special_div" } ], @"nodeChildArray" : @[ @{ @"nodeChildArray" : @[ @{ @"nodeContent" : @"this is a special div", @"nodeName" : @"text" } ], @"nodeName" : @"p", @"raw" : @"<p>this is a special div</p>" } ], @"nodeName" : @"div", @"raw" : @"<div class=\"special_div\"><p>this is a special div</p></div>" }, @{ @"nodeAttributeArray" : @[ @{ @"attributeName" : @"id", @"nodeContent" : @"special" } ], @"nodeChildArray" : @[ @{ @"nodeChildArray" : @[ @{ @"nodeContent" : @"this is special", @"nodeName" : @"text" } ], @"nodeName" : @"p", @"raw" : @"<p>this is special</p>" } ], @"nodeName" : @"div", @"raw" : @"<div id=\"special\"><p>this is special</p></div>" } ], @"nodeName" : @"body", @"raw" : @"<body><div><p>this is a test document</p></div><div class=\"special_div\"><p>this is a special div</p></div><div id=\"special\"><p>this is special</p></div></body>" };
    self.element = [HTMLElement HTMLElementWithNode:self.testDictionary encoding:nil];
    self.elementInit = [[HTMLElement alloc] initWithNode:self.testDictionary encoding:nil];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitilisation {
    XCTAssertTrue(self.element, @"Error seting up element form test dictionary via Factory method");
    XCTAssertTrue(self.elementInit, @"Error seting up element form test dictionary via init/alloc methods");
}

- (void)testNode {
    NSDictionary * node = self.element.node;
    XCTAssertTrue(node, @"should have a node");
    XCTAssertTrue(node.count == 4, @"node should not be empty dictionary");
}

- (void)testRaw {
    NSString * rawString = self.element.raw;
    XCTAssertTrue(rawString, @"should have a raw string");
    XCTAssertTrue(rawString.length > 0, @"raw should not be empty string");
}

- (void)testTagName {
    NSString * tagString = self.element.tagName;
    XCTAssertTrue(tagString, @"should have a raw string");
    XCTAssertTrue(tagString.length > 0, @"raw should not be empty string");
}

- (void)testAttributes {
    NSDictionary * attributesDictionary = self.element.attributes;
    XCTAssertTrue(attributesDictionary, @"Attributes dictionary should exist");
    XCTAssertTrue(attributesDictionary.count > 0, @"Attributes dictionary should contain attributes");
    XCTAssertTrue([attributesDictionary[@"class"] isEqualToString:@"html_body"], @"element should have class called html_body");
}

- (void)testChildren {
    NSArray * childrenArray = self.element.children;
    XCTAssertTrue(childrenArray, @"Array of children should exist");
    XCTAssertTrue(childrenArray.count == 3, @"Array of children should contain childen");
    XCTAssertTrue([childrenArray[0] isKindOfClass:[HTMLElement class]], @"children array should contain HTMLELements.");
}

- (void)testParentOfChildren {
    HTMLElement * exampleChild = self.element.children[0];
    XCTAssertTrue(exampleChild.parent == self.element, @"Our element should be parent of thier children.");
}

- (void)testContent {
    HTMLElement * exampleChild = self.element.children[0];
    HTMLElement * paragraphChild = exampleChild.children[0];
    HTMLElement * textChild = paragraphChild.children[0];
    XCTAssertTrue([textChild.tagName isEqualToString:@"text"], @"text child should have text as tag name");
    XCTAssertTrue([textChild.content isEqualToString:@"this is a test document"], @"text child should have text as 'this is a test document'");
}

- (void)testSearch {
    NSArray *array = [self.element searchWithXPathQuery:TABTestHTMLSearchString];
    XCTAssertTrue(array.count > 0, @"nothing in the body of the HTML");
}

#warning Add more tests based on actual usage

@end
