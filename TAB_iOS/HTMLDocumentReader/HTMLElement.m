//
//  HTMLElement.m
//  TAB iOS test
//
//  Created by Zachary BURGESS on 01/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

#import "HTMLElement.h"

#import <libxml/tree.h>
#import <libxml/parser.h>
#import <libxml/HTMLparser.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>

static NSString * const HTMLNodeContentKey           = @"nodeContent";
static NSString * const HTMLNodeNameKey              = @"nodeName";
static NSString * const HTMLNodeChildrenKey          = @"nodeChildArray";
static NSString * const HTMLNodeAttributeArrayKey    = @"nodeAttributeArray";
static NSString * const HTMLNodeAttributeNameKey     = @"attributeName";
static NSString * const HTMLNodeAttributeContentKey  = @"attributeContent";
static NSString * const HTMLNodeRawKey               = @"raw";

@interface HTMLElement ()

@property (copy, nonatomic, readwrite) NSDictionary * node;
@property (copy, nonatomic) NSString *encoding;
@property (nonatomic, copy, readwrite) NSString *raw;
@property (nonatomic, copy, readwrite) NSString *content;
@property (nonatomic, copy, readwrite) NSString *tagName;
@property (weak, nonatomic, readwrite) HTMLElement *parent;

@end

@implementation HTMLElement

#pragma mark - initilisers

- (id)initWithNode:(NSDictionary*)paramNode
          encoding:(NSString*)paramEncoding {
    self = [super init];
    if (self) {
        _node = paramNode;
        _encoding = paramEncoding;
        _raw = _node[HTMLNodeRawKey];
        _content = _node[HTMLNodeContentKey];
        _tagName = _node[HTMLNodeNameKey];
    }
    return self;
}

+ (instancetype)HTMLElementWithNode:(NSDictionary*)paramNode
                           encoding:(NSString*)paramEncoding {
    return [[HTMLElement alloc] initWithNode:paramNode encoding:paramEncoding];
}

#pragma mark - getters

- (NSArray *)children {
    NSMutableArray *children = [NSMutableArray array];
    for (NSDictionary *child in self.node[HTMLNodeChildrenKey]) {
        HTMLElement *element = [HTMLElement HTMLElementWithNode:child encoding:self.encoding];
        element.parent = self;
        children[children.count] = element;
    }
    return [children copy];
}

- (NSDictionary *)attributes {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    for (NSDictionary * attribute in self.node[HTMLNodeAttributeArrayKey]) {
        if (attribute[HTMLNodeContentKey] && attribute[HTMLNodeAttributeNameKey]) {
            attributes[attribute[HTMLNodeAttributeNameKey]] = attribute[HTMLNodeContentKey];
        }
    }
    return [attributes copy];
}

#pragma mark - searching

- (NSArray *)searchWithXPathQuery:(NSString *)paramQuery {
    
    NSArray * detailNodes = nil;
    detailNodes = [self performHTMLXPathQuery:paramQuery withEncoding:self.encoding];
    
    
    NSMutableArray * elements = [NSMutableArray array];
    for (id newNode in detailNodes) {
        elements[elements.count] = [HTMLElement HTMLElementWithNode:newNode encoding:self.encoding];
    }
    return [elements copy];
}

#pragma mark -
- (NSDictionary *)dictionaryForNode:(xmlNodePtr)paramNode
                             parent:(NSMutableDictionary *)paramParentResult
                   parentHasContent:(BOOL)paramParentHasContent {
    NSMutableDictionary *dictionaryForNode = [NSMutableDictionary new];
    NSString *nodeContent = nil;
    
    if (paramNode->name) {
        nodeContent = [NSString stringWithCString:(const char *)paramNode->name encoding:NSUTF8StringEncoding];
        dictionaryForNode[HTMLNodeNameKey] = nodeContent;
    }
    
    if (paramNode->content && paramNode->content != (xmlChar *)-1) {
        nodeContent = [NSString stringWithCString:(const char *)paramNode->content encoding:NSUTF8StringEncoding];
        
        if ([dictionaryForNode[HTMLNodeNameKey] isEqual:@"text"] && paramParentResult) {
            if(paramParentHasContent) {
                paramParentResult[HTMLNodeContentKey] = [nodeContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                return nil;
            }
            if (nodeContent != nil) {
                dictionaryForNode[HTMLNodeContentKey] = nodeContent;
            }
            return dictionaryForNode;
        }
        else {
            dictionaryForNode[HTMLNodeContentKey] = nodeContent;
        }
    }
    
    xmlAttr *nodeProperties = paramNode->properties;
    if (nodeProperties) {
        NSMutableArray *attributeArray = [NSMutableArray array];
        while (nodeProperties) {
            NSMutableDictionary *attributeDictionary = [NSMutableDictionary new];
            NSString *attributeName = [NSString stringWithCString:(const char *)nodeProperties->name encoding:NSUTF8StringEncoding];
            if (attributeName) {
                attributeDictionary[HTMLNodeAttributeNameKey] = attributeName;
            }
            
            if (nodeProperties->children) {
                NSDictionary *childDictionary = [self dictionaryForNode:nodeProperties->children
                                                                 parent:attributeDictionary
                                                       parentHasContent:true];
                if (childDictionary) {
                    attributeDictionary[HTMLNodeAttributeContentKey] = childDictionary;
                }
            }
            
            if ([attributeDictionary count] > 0) {
                attributeArray[attributeArray.count] = attributeDictionary;
            }
            nodeProperties = nodeProperties->next;
        }
        
        if ([attributeArray count] > 0) {
            dictionaryForNode[HTMLNodeAttributeArrayKey] = attributeArray;
        }
    }
    
    xmlNodePtr nodesChildren = paramNode->children;
    if (nodesChildren) {
        NSMutableArray *children = [NSMutableArray new];
        while (nodesChildren) {
            NSDictionary *childDictionary = [self dictionaryForNode:nodesChildren
                                                             parent:dictionaryForNode
                                                   parentHasContent:false];
            if (childDictionary) {
                children[children.count] = childDictionary;
            }
            nodesChildren = nodesChildren->next;
        }
        if ([children count] > 0) {
            dictionaryForNode[HTMLNodeChildrenKey] = children;
        }
    }
    
    xmlBufferPtr buffer = xmlBufferCreate();
    xmlNodeDump(buffer, paramNode->doc, paramNode, 0, 0);
    
    NSString *rawContent = [NSString stringWithCString:(const char *)buffer->content encoding:NSUTF8StringEncoding];
    if (rawContent != nil) {
        dictionaryForNode[HTMLNodeRawKey] = rawContent;
    }
    xmlBufferFree(buffer);
    
    return [dictionaryForNode copy];
}

- (NSArray *)performXPathQuery:(NSString *)paramQuery
                        onData:(xmlDocPtr)paramXmlPtr {
    xmlXPathContextPtr pathContext;
    xmlXPathObjectPtr pathObject;
    
    if (paramQuery == nil || ![paramQuery isKindOfClass:[NSString class]])  {
        return nil;
    }
    pathContext = xmlXPathNewContext(paramXmlPtr);
    if(pathContext == NULL) {
        NSLog(@"can't create xml Path context.");
        return nil;
    }
    pathObject = xmlXPathEvalExpression((xmlChar *)[paramQuery cStringUsingEncoding:NSUTF8StringEncoding], pathContext);
    if(pathObject == NULL) {
        NSLog(@"can't evaluate xml Path.");
        xmlXPathFreeContext(pathContext);
        return nil;
    }
    
    xmlNodeSetPtr nodePointers = pathObject->nodesetval;
    if (!nodePointers) {
        NSLog(@"Nodes is nil.");
        xmlXPathFreeObject(pathObject);
        xmlXPathFreeContext(pathContext);
        return nil;
    }
    
    NSMutableArray *nodes = [NSMutableArray array];
    for (NSInteger i = 0; i < nodePointers->nodeNr; i++) {
        NSDictionary *nodeDictionary = [self dictionaryForNode:nodePointers->nodeTab[i]
                                                        parent:nil
                                              parentHasContent:false];
        if (nodeDictionary) {
            nodes[nodes.count] = nodeDictionary;
        }
    }
    xmlXPathFreeObject(pathObject);
    xmlXPathFreeContext(pathContext);
    
    return [nodes copy];
}

- (NSArray *)performHTMLXPathQuery:(NSString *)query
                      withEncoding:(NSString *)encoding {
    xmlDocPtr doc;
    NSData *data = [self.raw dataUsingEncoding:NSUTF8StringEncoding];
    
    /* Load XML document */
    const char *encoded = encoding ? [encoding cStringUsingEncoding:NSUTF8StringEncoding] : NULL;
    
    doc = htmlReadMemory([data bytes], (int)[data length], "", encoded, HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR);
    
    if (doc == NULL) {
        NSLog(@"Unable to parse.");
        return nil;
    }
    
    NSArray *result = [self performXPathQuery:query onData:doc];
    xmlFreeDoc(doc);
    
    return result;
}

@end
