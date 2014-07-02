//
//  HTMLElement.h
//  TAB iOS test
//
//  Created by Zachary BURGESS on 01/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

/** class for an element of a HTML document */
@interface HTMLElement : NSObject

/** the element's data*/
@property (copy, nonatomic, readonly) NSDictionary * node;

/** the element's raw data*/
@property (nonatomic, copy, readonly) NSString *raw;

/** holds this tag's innerHTML content */
@property (nonatomic, copy, readonly) NSString *content;

/** hold the current tag's name */
@property (nonatomic, copy, readonly) NSString *tagName;

/** Returns tag attributes with name as key and content as value */
@property (strong, nonatomic, readonly) NSDictionary *attributes;

/** holds the children of a given node */
@property (strong, nonatomic, readonly) NSArray *children;

/** this element's parent element*/
@property (weak, nonatomic, readonly) HTMLElement *parent;

/** initiliser method
 @param paramNode the node data
 @param paramEncodeing the encoding type of the node
 @return self initilised */
- (id)initWithNode:(NSDictionary*)paramNode encoding:(NSString*)paramEncoding;

/** factory method
 @param paramNode the node data
 @param paramEncodeing the encoding type of the node
 @return a initilised and alocated HTMLElement */
+ (instancetype)HTMLElementWithNode:(NSDictionary*)paramNode encoding:(NSString*)paramEncoding;

/** searches the document for elements that respond to query string
 *
 * (i.e. //a[class="link"]) would return all a elements with the class link (i.e. <a href="URL Goes Here" class="link">click me</a>)
 *
 @param paramQuery the query being serched for
 @return an array of 'HTMLElement' instances that reply to the query searched*/
- (NSArray *)searchWithXPathQuery:(NSString *)paramQuery;

@end
