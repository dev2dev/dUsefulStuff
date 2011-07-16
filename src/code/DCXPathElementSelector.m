//
//  DCXPathElementRule.m
//  dXml
//
//  Created by Derek Clarkson on 26/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import "DCXPathElementSelector.h"
#import "DCXmlNode.h"
#import <dUsefulStuff/DCCommon.h>

@implementation DCXPathElementSelector

@synthesize elementName;

- (DCXPathElementSelector *) initWithElementName:(NSString *)aElementName {
	self = [super init];
	if (self) {
		self.elementName = aElementName;
	}
	return self;
}

- (NSArray *) selectNodesFromNode:(DCXmlNode * )node index:(int) anIndex {
	DC_LOG(@"Getting sub nodes of %@ by the name of %@ and adding to new list.", node.name, elementName);
	NSArray *nodes = [node xmlNodesWithName:elementName];
	NSMutableArray *results = [NSMutableArray arrayWithCapacity:[nodes count]];
	[results addObjectsFromArray:nodes];
	return results;
}

- (void) dealloc {
	DC_DEALLOC(elementName);
	[super dealloc];
}

@end
