//
//  DCXPathRootNodeRule.m
//  dXml
//
//  Created by Derek Clarkson on 25/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import "DCXPathRootSelector.h"
#import "DCXmlNode.h"
#import <dUsefulStuff/DCCommon.h>

@implementation DCXPathRootSelector

- (NSArray *) selectNodesFromNode:(DCXmlNode * )node index:(int)anIndex {

	DCXmlNode *root = node;
	while (root.parentNode != nil) {
		root = root.parentNode;
	}
	DC_LOG(@"Found root node: %@", root.name);
	return [NSArray arrayWithObject:root];

}

@end
