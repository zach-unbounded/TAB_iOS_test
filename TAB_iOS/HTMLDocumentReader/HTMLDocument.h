//
//  HTMLParser.h
//  TAB iOS test
//
//  Created by Zachary BURGESS on 01/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

#import "HTMLElement.h"

/** HTML or XML document parser*/
@interface HTMLDocument : NSObject

/** the documents data*/
@property (copy, nonatomic, readonly) NSData * data;

/** basic initilser
 @param paramData data from the html file
 @param paramEncoding use a special encoding or nil
 @return id current instance initialised */
- (id)initWithData:(NSData*)paramData encoding:(NSString*)paramEncoding;

/** Factory Method for HTML documents
 @param paramData data from the html file
 @param paramEncoding use a special encoding or nil
 @return id an initialised instance of HTMLDocument*/
+ (instancetype)HTMLDocumentWithHTMLData:(NSData *)paramData encoding:(NSString *)paramEncoding;

/** searches the document for elements that respond to query string
 *
 * (i.e. //a[class="link"]) would return all a elements with the class link (i.e. <a href="URL Goes Here" class="link">click me</a>)
 *
 @param paramQuery the query being serched for
 @return an array of 'HTMLElement' instances that reply to the query searched*/
- (NSArray *)searchWithXPathQuery:(NSString *)paramQuery;

@end
