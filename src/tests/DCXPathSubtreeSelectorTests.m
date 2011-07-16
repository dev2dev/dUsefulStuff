//
//  DCXPathRootNodeRuleTests.m
//  dXml
//
//  Created by Derek Clarkson on 25/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//
#import <GHUnitIOS/GHUnitIOS.h>
#import "DCXmlNode.h"
#import "DCXPathSubtreeSelector.h"

@interface DCXPathSubtreeSelectorTests : GHTestCase
{
}

@end


@implementation DCXPathSubtreeSelectorTests


- (void) testBasicSelection {
	
	DCXmlNode *root = [DCXmlNode createWithName:@"root"];
	[root addXmlNodeWithName:@"ignored"];
	[root addXmlNodeWithName:@"subnode"];
	
	DCXPathSubtreeSelector *selector = [[[DCXPathSubtreeSelector alloc] initWithElementName:@"subnode"] autorelease];
	NSArray * results = [selector selectNodesFromNode:root index:0];
	
	GHAssertEquals((int)[results count], 1, @"Incorrect number of nodes returned");
	GHAssertEqualStrings(((DCXmlNode *)[results objectAtIndex:0]).name, @"subnode", @"Subnode node not returned.");
	
}

- (void) testSubtreeSearching {
	
	DCXmlNode *root = [DCXmlNode createWithName:@"root"];
	DCXmlNode * ignoredNode = [root addXmlNodeWithName:@"ignored"];
	[root addTextNodeWithValue:@"text value 1"];
	[ignoredNode addXmlNodeWithName:@"subnode"];
	[ignoredNode addTextNodeWithValue:@"text value 2"];
	[root addXmlNodeWithName:@"subnode"];
	
	DCXPathSubtreeSelector *selector = [[[DCXPathSubtreeSelector alloc] initWithElementName:@"subnode"] autorelease];
	id results = [selector selectNodesFromNode:root index:0];
	
	GHAssertTrue([results isKindOfClass:[NSArray class]], @"Should be an array returned.");
	NSArray * resultList = (NSArray *) results;				  
	GHAssertEquals((int)[resultList count], 2, @"Incorrect number of nodes returned");
	DCXmlNode * n1 = (DCXmlNode *) [resultList objectAtIndex:0];
	DCXmlNode * n2 = (DCXmlNode *) [resultList objectAtIndex:1];
	GHAssertEqualStrings(n1.name, @"subnode", @"Subnode node not returned.");
	GHAssertEqualStrings(n2.name, @"subnode", @"Subnode node not returned.");
	GHAssertNotEqualObjects(n1, n2, @"Should be different objects");
}

@end
