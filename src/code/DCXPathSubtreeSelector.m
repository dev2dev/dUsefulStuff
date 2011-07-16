//
//  DCXPathSubtreeSelector.m
//  dXml
//
//  Created by Derek Clarkson on 7/02/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import "DCXPathSubtreeSelector.h"
#import <dUsefulStuff/DCCommon.h>
#import "DCXmlNode.h"
#import "DCDMNode.h"
#import "DCTextNode.h"

@interface DCXPathSubtreeSelector ()
- (void) traverseIntoNode:(DCXmlNode *)parentNode appendingResults:(NSMutableArray *)results;

@end


@implementation DCXPathSubtreeSelector

@synthesize elementName;

- (DCXPathSubtreeSelector *) initWithElementName:(NSString *)aElementName {
	self = [super init];
	if (self) {
		self.elementName = aElementName;
	}
	return self;
}

- (NSArray *) selectNodesFromNode:(DCXmlNode * )node index:(int)anIndex {
	DC_LOG(@"Getting sub nodes of %@ by the name of %@ using a subtree search and adding to new list.", node.name, elementName);
	NSMutableArray *results = [NSMutableArray array];
	[self traverseIntoNode:node appendingResults:results];
	return results;
}


- (void) traverseIntoNode:(DCXmlNode *)parentNode appendingResults:(NSMutableArray *)results {
	
	DC_LOG(@"Traversing into node %@", parentNode.name);
	
	Class textNodeClass = [DCTextNode class];
	for (DCDMNode *node in [parentNode nodes]) {

		// Only accept xml node classes.
		if ([node isKindOfClass:textNodeClass]) {
			DC_LOG(@"Text node found, ignoring.");
			continue;
		}

		// Check the name and add it to the results.
		if ([(DCXmlNode *)node isEqualToName:elementName]) {
			DC_LOG(@"Xml node found with correct name, adding.");
			[results addObject:node];
		}

		// Now recurse into the node.
		[self traverseIntoNode:(DCXmlNode *)node appendingResults:results];

	}
}

- (void) dealloc {
	DC_DEALLOC(elementName);
	[super dealloc];
}

@end
