//
//  DCXPathParentNodeRule.m
//  dXml
//
//  Created by Derek Clarkson on 27/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import "DCXPathParentSelector.h"
#import "DCXmlNode.h"
#import <dUsefulStuff/DCCommon.h>


@implementation DCXPathParentSelector

- (NSArray *) selectNodesFromNode:(DCXmlNode * )node index:(int)anIndex {
	NSMutableArray * result = [NSMutableArray array];
	if (node.parentNode != nil) {
		DC_LOG(@"Adding parent node of %@", node.name);
		[result addObject:node.parentNode];
	}
	return result;
}
@end
